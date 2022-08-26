#![no_std]
#![no_main]

#![feature(alloc_error_handler)]

#![feature(const_slice_from_raw_parts)]
#![feature(nonnull_slice_from_raw_parts)]
#![feature(slice_ptr_get)]
#![feature(allocator_api)]
#![feature(abi_x86_interrupt)]
#![feature(slice_ptr_len)]

#![feature(naked_functions)]
#![feature(core_intrinsics)]
#![feature(asm_const)]

extern crate alloc;


#[allow(dead_code)]
mod bootboot;

use core::{panic::PanicInfo, sync::atomic::{AtomicUsize, Ordering}, alloc::{Layout, GlobalAlloc, AllocError}, ptr};
 
use alloc::boxed::Box;
use amd64::{self, paging, registers::CR3};
use sys::{println, memm::{self, talloc::{Tallock, Talloc}}, from_phys_addr, cfg, out::framebuffer};


// NO GLOBAL ALLOCATOR
// Each CPU gets their own allocator, use that one.
struct Panicator;
unsafe impl GlobalAlloc for Panicator {
    unsafe fn alloc(&self, _: Layout) -> *mut u8 { panic!("No global allocator!"); }
    unsafe fn dealloc(&self, _: *mut u8, _: Layout) { panic!("No global allocator!"); }
}
#[global_allocator]
static PANICATOR: Panicator = Panicator;
#[alloc_error_handler]
fn alloc_error_handler(layout: core::alloc::Layout) -> ! {
    panic!("Allocator Error: {:?}", layout)
}


#[no_mangle]
pub extern "C" fn _start() -> ! {
    // ASSUME BOOTBOOT
    
    unsafe { memm::KRNL_DEFAULT_PAT.write(); }

    static THREAD_TICKET: AtomicUsize = AtomicUsize::new(0);
    let thread_ticket = THREAD_TICKET.fetch_add(1, Ordering::SeqCst);
    
    static IS_MAPPER_INITD_PML4: AtomicUsize = AtomicUsize::new(usize::MAX);
    
    if thread_ticket == 0 {
        unsafe {
            sys::out::terminal::TERM1.lock().fb = sys::out::framebuffer::FrameBuffer::new(
                bootboot::FRAMEBUFFER, 
                (*bootboot::BOOTBOOT).fb_width as usize,
                (*bootboot::BOOTBOOT).fb_height as usize,
                (*bootboot::BOOTBOOT).fb_scanline as usize,
                match (*bootboot::BOOTBOOT).fb_type {
                    bootboot::FB_ABGR => framebuffer::PixelFormat::ABGR,
                    bootboot::FB_ARGB => framebuffer::PixelFormat::ARGB,
                    bootboot::FB_BGRA => framebuffer::PixelFormat::BGRA,
                    bootboot::FB_RGBA => framebuffer::PixelFormat::RGBA,
                    _ => panic!()
                }
            );
        }

        println!("[BSP] KERNEL _START! ");
        sys::print!("{}", char::from_u32(31).unwrap());

        if true { // BOOTBOOT
            // Store configuration file as static data.
            // SAFETY: this is only called once,
            // mapping is unchanged, bootloader is BOOTBOOT
            cfg::init_boot_cfg(unsafe { bootboot::env_cfg_as_str() });
        }

        // set up mapper & physical memory management
        let pml4_paddr = unsafe {
            let iter = bootboot::mmap_available_iter();
            memm::Mapper::setup(&iter)
        };

        IS_MAPPER_INITD_PML4.store(pml4_paddr, Ordering::SeqCst);
    } else {
        while IS_MAPPER_INITD_PML4.load(Ordering::SeqCst) == usize::MAX {
            unsafe {
                core::arch::asm!("pause", options(nomem, nostack, preserves_flags));
            }
        }
    }
    
    unsafe {
        CR3::set_nflags(IS_MAPPER_INITD_PML4.load(Ordering::SeqCst));
    }


    // map thread stack by thread_ticket index
    let stack_acme = memm::KRNL_STACK_ACME - (memm::KRNL_STACK_SIZE + paging::PTE_SIZE) * thread_ticket;
    unsafe {
        // todo: map stacks with 2mib gap?
        let _mapping = memm::MAPPER.lock().map(
            (stack_acme - memm::KRNL_STACK_SIZE) as *mut u8,
            memm::KRNL_STACK_SIZE, 
            paging::PTE::RW, 
            paging::PTE::RW,
            CR3::read().get_laddr_offset(memm::PHYS_LADDR_OFFSET)
        );
    }

    unsafe {
        // switch the stacks onto loader pre-allocated stack area
        // mem::KERNEL_STACK_BOTTOM itself is unmapped, thus reduce by sixteen (preserves alignment)
        core::arch::asm!(
            // set the stack pointer
            "mov rsp, {}",
            in(reg) stack_acme - 0x10,
            options(preserves_flags)
        );
    };
    
    // jump to init immediately; don't touch the stack
    init();
}

fn init() -> ! {
    static THREAD_TICKET: AtomicUsize = AtomicUsize::new(0);
    let thread_ticket = THREAD_TICKET.fetch_add(1, Ordering::SeqCst);

    println!("T{}: KERNEL INIT", thread_ticket);

    let mut talloc = unsafe { allocator_setup(thread_ticket) };
    let (gdt, idt, tss) = unsafe { setup_sys_tables(talloc.as_ref()) };

    if thread_ticket == 0 {
        /* println!("sizeof inttrapgate: {}", core::mem::size_of::<IntTrapGate<interrupts::ISR>>());
        println!("sizeof idt: {}", core::mem::size_of::<[IntTrapGate<interrupts::ISR>; 256]>());
        println!("sizeof idt: {}", core::mem::size_of::<IDT>()); */
        // ISRs with error codes are breaking!
        unsafe { core::arch::asm!("int3"); }
        //unsafe { core::arch::asm!("mov rcx, 0", "div rcx"); }
        unsafe { core::arch::asm!("nop"); }
        //unsafe { core::arch::asm!("mov [0x100], rax"); }
        unsafe { core::arch::asm!("int 13"); }
        //unsafe { segmentation::cs_write(SegSel::new_gdt(amd64::PrivLvl::Ring0, 0)); }
        //println!("{:?}", amd64::registers::CR0::read());
        // unsafe { amd64::registers::CR0::write(amd64::registers::CR0::read() &! amd64::registers::CR0::PG); }
    }

    // double/triple buffer the framebuffer!
    

    amd64::hlt_loop();


    // extract data from bb structs

    // acpi rsdp
    // acpihandler
    // acpi
    // madtd

    // apic
    // idt & interrupt handling


    //amd64::hlt_loop()
}


#[panic_handler]
fn panic_handler(info: &PanicInfo) -> ! {
    println!("{}", info);

    amd64::hlt_loop()
}



/// Sets up an allocator for this CPU and returns itself allocated on it's own heap.
unsafe fn allocator_setup(thread_ticket: usize) -> Box<Tallock, &'static Tallock> {
    use core::alloc::Allocator;

    let heap_base = -(paging::PDPTE_SIZE as isize) * (2 + thread_ticket as isize);
    let heap_size = cfg::heap_init_size();
    let heap_smlst_block = cfg::heap_smlst_block();

    memm::MAPPER.lock().map(
        heap_base as *mut u8,
        heap_size,
        paging::PTE::RW,
        paging::PTE::RW,
        core::ptr::slice_from_raw_parts_mut(from_phys_addr!(CR3::read().paddr, paging::PTE), 512)
    );

    let tallock = memm::talloc::Tallock(spin::Mutex::new(
        memm::talloc::Talloc::new(
            heap_base, 
            heap_size, 
            heap_smlst_block, 
            core::ptr::slice_from_raw_parts_mut(heap_base as *mut _, heap_size), 
            oom_handler
        )   
    ));

    let tallock_ptr = tallock.allocate(Layout::new::<Tallock>()).expect("Tallock allocate failed.");
    tallock_ptr.as_mut_ptr().cast::<Tallock>().write(tallock);

    let tallock_box = Box::from_raw_in(
        tallock_ptr.as_mut_ptr().cast::<Tallock>(), 
        tallock_ptr.as_mut_ptr().cast::<Tallock>().as_ref().unwrap()
    );

    tallock_box
}

fn oom_handler(talloc: &mut Talloc, layout: Layout) -> Result<(), AllocError> {
    let (arena_base, arena_size) = talloc.get_arena();

    let max_arena_size = paging::PDPTE_SIZE - cfg::stack_size() - paging::PTE_SIZE;
    let lgr_size = (arena_size * 2).min(max_arena_size);
    let free_mem_size = talloc.req_free_mem(arena_base, lgr_size);

    // ensure there is 1) sufficient room to expand, 2) enough space for status data
    if arena_size < lgr_size - free_mem_size {
        unsafe {
            memm::MAPPER.lock().map(
                (arena_base + arena_size as isize) as *mut _, 
                lgr_size - arena_size, 
                paging::PTE::RW, 
                paging::PTE::RW, 
                CR3::read().get_laddr_offset(memm::PHYS_LADDR_OFFSET),
            );
    
            talloc.extend(
                arena_base,
                lgr_size,
                core::ptr::slice_from_raw_parts_mut((arena_base + arena_size as isize) as *mut _, lgr_size - arena_size)
            );

        }

        Ok(())
    } else {
        Err(AllocError)
    }
}


use amd64::{
    PrivLvl,
    segmentation::{self, SegSel, SysSegDesc, TaskStateSeg, CodeSegDesc, DataSegDesc},
    interrupts::{self, IDT, Ssdt, IntTrapGate, InterruptStackFrame},
};


pub const KRNL_CODE_SEG_IDX: u16 = 1;
pub const KRNL_CODE_SEG_SEL: SegSel = SegSel::new_gdt(PrivLvl::Ring0, KRNL_CODE_SEG_IDX);
pub const USER_CODE_SEG_IDX: u16 = 2;
pub const USER_CODE_SEG_SEL: SegSel = SegSel::new_gdt(PrivLvl::Ring3, USER_CODE_SEG_IDX);
pub const DATA_SEG_IDX: u16 = 3;
pub const DATA_SEG_SEL: SegSel = SegSel::new_gdt(PrivLvl::Ring3, DATA_SEG_IDX);
pub const TSS_SEG_IDX: u16 = 4;
pub const TSS_SEG_SEL: SegSel = SegSel::new_gdt(PrivLvl::Ring0, TSS_SEG_IDX);

pub unsafe fn setup_sys_tables(talloc: &crate::memm::talloc::Tallock)
-> (Box<[u64], &Tallock>, Box<IDT, &Tallock>, Box<TaskStateSeg, &Tallock>, ) {

    let tss = TaskStateSeg::new([ptr::null_mut(); 3], [ptr::null_mut(); 7]);
    let mut tss = Box::new_in(tss, talloc);

    let tss_desc = SysSegDesc::new(
        tss.as_mut() as *mut _ as *mut _,
        TaskStateSeg::LIMIT,
        Ssdt::AvlTss,
        PrivLvl::Ring0,
        false,
    );
    let gdt = [
        0,
        (CodeSegDesc::default() | CodeSegDesc::DPL_RING0).bits(),
        (CodeSegDesc::default() | CodeSegDesc::DPL_RING3).bits(),
        DataSegDesc::default().bits(),
        tss_desc.to_bits()[0],
        tss_desc.to_bits()[1],
    ];
    let mut gdt = Box::new_in(gdt, talloc);

    // load global descriptor table
    segmentation::lgdt(gdt.as_mut() as *mut _);
    // switch to new code segment
    segmentation::cs_write(KRNL_CODE_SEG_SEL);
    // switch data segments
    core::arch::asm!(
        "mov ds, {0:x}",
        "mov es, {0:x}",
        "mov fs, {0:x}",
        "mov gs, {0:x}",
        "mov ss, {0:x}",
        in(reg) DATA_SEG_IDX,
    );
    // load new tss into the task register
    segmentation::ltr(TSS_SEG_SEL);


    let mut idt = Box::new_in(IDT::empty(), talloc);

    // todo: create some ISTs and have abort exceptions use them
    // todo: create more ISRs

    idt.div_by_zero_fault = IntTrapGate::new(div_by_zero_fault as u64, KRNL_CODE_SEG_SEL, 0, Ssdt::InterruptGate, PrivLvl::Ring0);
    idt.debug = IntTrapGate::new(debug_exception as u64, KRNL_CODE_SEG_SEL, 0, Ssdt::InterruptGate, PrivLvl::Ring0);
    idt.break_point_trap = IntTrapGate::new(naked_breakpoint_trap_wrapper as u64, KRNL_CODE_SEG_SEL, 0, Ssdt::InterruptGate, PrivLvl::Ring0);
    idt.double_fault_abort = IntTrapGate::new(double_fault_abort as u64,KRNL_CODE_SEG_SEL,0,Ssdt::InterruptGate,PrivLvl::Ring0);
    idt.page_fault = IntTrapGate::new(naked_page_fault_wrapper as u64,KRNL_CODE_SEG_SEL,0,Ssdt::InterruptGate,PrivLvl::Ring0);
    idt.general_protection_fault = IntTrapGate::new(naked_general_protection_fault_wrapper as u64,KRNL_CODE_SEG_SEL,0,Ssdt::InterruptGate,PrivLvl::Ring0);
    idt.segment_not_present_fault = IntTrapGate::new(segment_not_present_fault as u64,KRNL_CODE_SEG_SEL,0,Ssdt::InterruptGate,PrivLvl::Ring0);
    idt.alignment_check_fault = IntTrapGate::new(alignment_check_fault as u64,KRNL_CODE_SEG_SEL,0,Ssdt::InterruptGate,PrivLvl::Ring0);

    interrupts::lidt(idt.as_ref() as *const _);

    (gdt, idt, tss)
}


extern "x86-interrupt" fn div_by_zero_fault(stack_frame: InterruptStackFrame) {
    crate::println!("DIV BY ZERO FAULT!\nStack Frame: {:#?}", stack_frame);

    amd64::hlt_loop();
}

extern "x86-interrupt" fn debug_exception(stack_frame: InterruptStackFrame) {
    crate::println!("DEBUG EXCEPTION!\nStack Frame: {:#?}", stack_frame);
}

#[no_mangle]
extern "x86-interrupt" fn break_point_trap(stack_frame: InterruptStackFrame) {
    /* let rsp: *const u64;
    unsafe { core::arch::asm!("lea {}, [rsp+0]", out(reg) rsp, options(nomem, nostack, preserves_flags)); }
    let slice = core::ptr::slice_from_raw_parts(rsp.wrapping_sub(0x100), 0x200);
    println!();
    for i in (0..slice.len()).rev() {
        sys::print!("{:x} ", unsafe { *slice.get_unchecked(i) });
    }
    let ptr = core::ptr::addr_of!(stack_frame);
    println!("{:p} {:p}", rsp, ptr); */
    crate::println!("BREAK POINT TRAP!\nStack Frame: {:#?}", &stack_frame);
}

/* #[naked]
extern "C" fn naked_page_fault_wrapper() -> ! {
    unsafe {
        asm!("mov rdi, rsp; call $0"
             :: "i"(divide_by_zero_handler as extern "C" fn(_) -> !)
             : "rdi" : "intel");
        ::core::intrinsics::unreachable();
    }
} */
/* extern "C" fn naked_breakpoint_trap_wrapper() -> ! {
    unsafe {
        core::arch::asm!(
            "add rsp, 8",
            "mov rdi, rsp",
            "call naked_breakpoint_trap",
            options(noreturn),
        );
    }
} */
#[no_mangle]
extern "sysv64" fn naked_breakpoint_trap(stack_frame: &InterruptStackFrame) {
    /* let rsp: *const u64;
    unsafe { core::arch::asm!("mov {}, rsp", out(reg) rsp, options(nostack, nomem, preserves_flags)); }
    println!("rsp: {:p}", rsp);
    /* let rsp = rsp.wrapping_add(rsp as usize % 16);
    for i in -0x100..0x100 {
        sys::print!("{:p}:{:x} ", unsafe { rsp.offset(i) }, unsafe { *rsp.offset(i) });
    } */ */

    crate::println!(
        "NAKED BREAKPOINT TRAP!\nStack Frame: {:#?}",
        unsafe { /* &* */stack_frame },
    );
    /* amd64::hlt_loop(); */
}
/* extern "C" fn naked_page_fault_wrapper() -> ! {
    unsafe {
        core::arch::asm!(
            "add rsp, 8",
            "pop rsi",
            "mov rdi, rsp",
            "call naked_page_fault",
            options(noreturn),
        );
    }
} */
#[no_mangle]
extern "sysv64" fn naked_page_fault(stack_frame: &InterruptStackFrame, err_code: u64) -> ! {
    let rsp: *const u64;
    unsafe { core::arch::asm!("mov {}, rsp", out(reg) rsp, options(nostack, nomem, preserves_flags)); }
    println!("rsp: {:p}", rsp);
    /* let rsp = rsp.wrapping_add(rsp as usize % 16);
    for i in -0x100..0x100 {
        sys::print!("{:p}:{:x} ", unsafe { rsp.offset(i) }, unsafe { *rsp.offset(i) });
    } */

    let cr2 = amd64::registers::cr2_read();
    crate::println!(
        "PAGE FAULT!\nStack Frame: {:#?}\nError code: {:?}\nCR2: {:p}",
        stack_frame,
        unsafe { interrupts::PfErrCode::from_bits_unchecked(err_code) },
        cr2
    );
    amd64::hlt_loop();
}

/* extern { fn naked_general_protection_fault_wrapper() -> !; }
core::arch::global_asm!(
    "naked_general_protection_fault_wrapper:",
    "and rsp, 0xfffffffffffffff0",
    "pop rsi",
    "mov rdi, rsp",
    "call naked_general_protection_fault"
); */

/* extern { fn naked_page_fault_wrapper() -> !; }
core::arch::global_asm!(
    "naked_page_fault_wrapper:",
    "and rsp, 0xfffffffffffffff0",
    "pop rsi",
    "mov rdi, rsp",
    "call naked_page_fault"
); */

/* extern { fn naked_breakpoint_trap_wrapper() -> !; }
core::arch::global_asm!(
    "naked_breakpoint_trap_wrapper:",
    "jmp break_point_trap",
    "iretq",
); */


extern { fn naked_breakpoint_trap_wrapper(); }
core::arch::global_asm!("
naked_breakpoint_trap_wrapper:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11

    mov rdi, rsp
    add rdi, 0x48

    //sub rsp, 8

    call naked_breakpoint_trap

    //add rsp, 8

    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax

    iretq"
);
extern { fn naked_page_fault_wrapper() -> !; }
core::arch::global_asm!("
naked_page_fault_wrapper:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11

    mov rsi, [rsp+0x48]
    mov rdi, rsp
    add rdi, 0x50

    sub rsp, 8

    call naked_page_fault

    add rsp, 8

    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax

    add rsp, 8

    iretq"
);
extern { fn naked_general_protection_fault_wrapper() -> !; }
core::arch::global_asm!("
naked_general_protection_fault_wrapper:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11

    mov rsi, [rsp+0x40]
    mov rdi, rsp
    add rdi, 0x48

    sub rsp, 8

    call naked_general_protection_fault

    add rsp, 8

    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax

    add rsp, 8

    iretq"
);

#[no_mangle]
extern "x86-interrupt" fn page_fault(stack_frame: InterruptStackFrame/* , err_code: u64 */) {
    /* unsafe { core::arch::asm!("add rsp, 8", options(nomem, preserves_flags)); } */
    /* let rsp: *const u64;
    unsafe { core::arch::asm!("lea {}, [rsp+0]", out(reg) rsp, options(nomem, nostack, preserves_flags)); }
    let slice = core::ptr::slice_from_raw_parts(rsp.wrapping_sub(0x100), 0x200);
    println!();
    for i in (0..slice.len()).rev() {
        sys::println!("{:p} {:x}", unsafe {  slice.get_unchecked(i) }, unsafe { *slice.get_unchecked(i) });
    }
    //unsafe { core::arch::asm!("lea rsp, [rsp-16]", options(nomem, nostack, preserves_flags)); }
    let ptr = core::ptr::addr_of!(stack_frame);
    println!("rsp {:p}, isf ptr {:p}", rsp, ptr);
    // let ptr = ptr.cast::<u8>().wrapping_sub(128).cast::<InterruptStackFrame>(); */

    let stack_frame = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u8>().wrapping_add(8).cast::<InterruptStackFrame>() };
    let err_code = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u64>()/* .wrapping_sub(1) */ };

    let cr2 = amd64::registers::cr2_read();
    crate::println!(
        "PAGE FAULT!\nStack Frame: {:#?}\nError code: {:?}\nCR2: {:p}",
        &stack_frame,
        unsafe { interrupts::PfErrCode::from_bits_unchecked(err_code) },
        cr2
    );

    amd64::hlt_loop();
}

extern "x86-interrupt" fn double_fault_abort(stack_frame: InterruptStackFrame/* , err_code: u64 */) -> ! {
    let stack_frame = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u8>().wrapping_add(8).cast::<InterruptStackFrame>() };
    let err_code = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u64>()/* .wrapping_sub(1) */ };

    crate::println!("DOUBLE FAULT!\nStack Frame: {:#?}\nError Code: {:#?}", stack_frame, err_code);

    amd64::hlt_loop();
}

/* extern "C" fn naked_general_protection_fault_wrapper() -> ! {
    unsafe {
        core::arch::asm!(
            //"add rsp, 8",
            "pop rsi",
            "mov rdi, rsp",
            "call naked_general_protection_fault",
            options(noreturn),
        );
    }
} */
#[no_mangle]
extern "sysv64" fn naked_general_protection_fault(stack_frame: &InterruptStackFrame, err_code: u64) -> ! {
    crate::println!(
        "NAKED GENERAL PROTECTION FAULT!\nStack Frame: {:#?}\nError code: {:#x}",
        stack_frame,
        err_code
    );
    amd64::hlt_loop();
}
extern "x86-interrupt" fn general_protection_fault(stack_frame: InterruptStackFrame/* , err_code: u64 */) {
    let stack_frame = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u8>()/* .wrapping_add(8) */.cast::<InterruptStackFrame>() };
    let err_code = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u64>().wrapping_sub(1) };

    crate::println!("GENERAL PROTECTION FAULT!\nStack Frame: {:#?}", stack_frame);
    if err_code != 0 {
        crate::println!("Error Code: {:#x}", err_code);
    }

    amd64::hlt_loop();
}

extern "x86-interrupt" fn segment_not_present_fault(stack_frame: InterruptStackFrame/* , err_code: u64 */) {
    let stack_frame = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u8>().wrapping_add(8).cast::<InterruptStackFrame>() };
    let err_code = unsafe { *core::ptr::addr_of!(stack_frame).cast::<u64>()/* .wrapping_sub(1) */ };

    crate::println!("SEGMENT NOT PRESENT FAULT!\nStack Frame: {:#?}\nError Code: {:#x}", stack_frame, err_code);

    amd64::hlt_loop();
}

extern "x86-interrupt" fn alignment_check_fault(stack_frame: InterruptStackFrame, err_code: u64) {
    crate::println!("ALIGNMENT CHECK FAULT!\nStack Frame: {:#?}\nError Code: {:#x}", stack_frame, err_code);

    amd64::hlt_loop();
}




