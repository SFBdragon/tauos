#![no_std]
#![no_main]

#![feature(ptr_metadata)]
#![feature(alloc_error_handler)]


extern crate alloc;


#[allow(dead_code)]
mod bootboot;

use core::{panic::PanicInfo, sync::atomic::{AtomicUsize, Ordering}, ptr, mem};
 
use alloc::vec::Vec;
use amd64::{self, paging, registers::{self, CR3}};
use libkernel::{println, memm, utils};


#[no_mangle]
pub extern "C" fn _start() -> ! {
    // ASSUME BOOTBOOT

    unsafe { memm::KRNL_DEFAULT_PAT.write(); }

    static THREAD_TICKET: AtomicUsize = AtomicUsize::new(0);
    let thread_ticket = THREAD_TICKET.fetch_add(1, Ordering::SeqCst);
    
    static IS_MAPPER_INITD_PML4: AtomicUsize = AtomicUsize::new(usize::MAX);
    
    if thread_ticket == 0 {
        println!("[BSP] KERNEL _START!");

        unsafe {
            // set up mapper & physical memory management

            let mmap_size = (*bootboot::BOOTBOOT).size as usize - mem::size_of::<bootboot::BootBoot>();
            let mmap_len = mmap_size / mem::size_of::<bootboot::MMapEntry>();
            let mmap = core::slice::from_raw_parts_mut(bootboot::MMAP, mmap_len)/* .split_last_mut().unwrap().1 */;

            // check if free blocks are actually usable
            for entry in mmap.iter_mut().filter(|e| e.data & bootboot::MMAP_FREE != 0) {
                let base_ptr = entry.ptr as *mut u8;
                let val = base_ptr.read_volatile();
                base_ptr.write_volatile(0xAE);
                let invalid = base_ptr.read_volatile() != 0xAE;
                base_ptr.write_volatile(val);
                if invalid {
                    entry.data &= !bootboot::MMAP_FREE;
                }
            }

            let mmap_iter = &mmap.iter()
                .filter(|&entry| entry.data & bootboot::MMAP_FREE != 0)
                .map(|entry| (
                    entry.ptr as usize,
                    entry.data as usize & bootboot::MMAP_DATA_SIZE_MASK as usize,
                ));
            let pml4_paddr = memm::Mapper::setup(mmap_iter);

            // set up allocator

            /* println!("mapped");

            const KRNL_HEAP_BASE: *mut u8 = (memm::KRNL_STACK_ACME - (paging::PDPTE_SIZE * 2)) as *mut _;
            const KRNL_HEAP_SIZE: usize = paging::PDE_SIZE * 32;
            const KRNL_HEAP_SMLL: usize = 64;
            memm::MAPPER.lock().map(
                KRNL_HEAP_BASE,
                KRNL_HEAP_SIZE,
                paging::PTE::RW,
                paging::PTE::RW,
                CR3::read().get_laddr_offset(memm::PHYS_LADDR_OFFSET)
            );
            println!("mapped alloc");

            let (llists_len, bitmap_len) = memm::talloc::Talloc::slice_lengths(
                KRNL_HEAP_SIZE, KRNL_HEAP_SMLL);
            let slice_bytes = llists_len * mem::size_of::<utils::llist::LlistNode<()>>() + bitmap_len;
            memm::MAPPER.lock().map(
                KRNL_HEAP_BASE.wrapping_sub(slice_bytes),
                slice_bytes,
                paging::PTE::RW,
                paging::PTE::RW,
                CR3::read().get_laddr_offset(memm::PHYS_LADDR_OFFSET)
            );
            println!("mapped alloc slice");
            let llists = core::ptr::slice_from_raw_parts_mut(KRNL_HEAP_BASE.wrapping_sub(slice_bytes) as *mut _, llists_len);
            let bitmap = core::ptr::slice_from_raw_parts_mut(KRNL_HEAP_BASE.wrapping_sub(bitmap_len) as *mut _, bitmap_len);

            println!("afdsg");

            memm::ALLOCATOR.new_valid(
                KRNL_HEAP_BASE, 
                KRNL_HEAP_SIZE, 
                KRNL_HEAP_SMLL, 
                llists, 
                bitmap
            );
            let range = memm::ALLOCATOR.lock().bound_available(KRNL_HEAP_BASE, KRNL_HEAP_SIZE);
            memm::ALLOCATOR.lock().release(range); */

            IS_MAPPER_INITD_PML4.store(pml4_paddr, Ordering::SeqCst);
        }
    } else {
        //println!("T{}: waiting...", thread_ticket);
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

    /* let mut vec = Vec::new();
    vec.push("something");
    vec.push("victory");
    println!("{}", vec.pop().unwrap()); */

    amd64::hlt_loop();

    // extract data from bb structs
    
    // framebuffer setup?
    
    // alloc

    // acpi rsdp
    // acpihandler
    // acpi
    // madt
    
    //mem::segmentation_setup();

    // apic
    // idt & interrupt handling


    //amd64::hlt_loop()
}

#[panic_handler]
fn panic_handler(info: &PanicInfo) -> ! {
    println!("{}", info);

    amd64::hlt_loop()
}

#[alloc_error_handler]
fn alloc_error_handler(layout: core::alloc::Layout) -> ! {
    panic!("Allocator Error: {:?}", layout)
}



pub fn segmentation_setup() {
    // todo: properly alloc gdt and finish tss/fs/gs/other setup


    // Segmentation is mostly disabled in long, 64-bit mode. However some elements are still used:
    //  - The attributes of a code segment
    //  - The FS and GS registers and associated data segments
    //  - The TS register and associated TSS
    //
    // For now, the GDT set up by the UEFI is taken over and overwritten, and a basic layout is issued.

    // nab the uefi gdt for now
    /* let uefi_gdt = segmentation::sgdt();
    

    uefi_gdt.iter_mut().for_each(|entry| *entry = 0);

    uefi_gdt[0] = 0;
    uefi_gdt[1] = 
        ( CodeSegmentDescriptor::PRESENT
        | CodeSegmentDescriptor::CONFORMING
        | CodeSegmentDescriptor::EXECUTABLE
        | CodeSegmentDescriptor::TYPE
        | CodeSegmentDescriptor::LONG_MODE
        | CodeSegmentDescriptor::DPL_RING0).bits();

    unsafe {
        // load in the GDT just to make sure
        segmentation::lgdt(uefi_gdt);

        // reset CS register so that the new GDT entry is used
        segmentation::cs_write(SegmentSelector::new_gdt(amd64::PrivLvl::Ring0, 1));
    } */
} 

