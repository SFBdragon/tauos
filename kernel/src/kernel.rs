#![no_std]
#![no_main]
#![feature(asm)]
#![feature(alloc_error_handler)]


use core::panic::PanicInfo;
 
use amd64;
use libkernel::*;

const KERNEL_HEAP_GRANULARITY: usize = 10;

#[global_allocator]
static mut ALLOCATOR: mem::sysalloc::SysAlloc::<KERNEL_HEAP_GRANULARITY> = unsafe { mem::sysalloc::SysAlloc::<KERNEL_HEAP_GRANULARITY>::new_invalid() };


static mut PAYLOAD: Option<BootPayload> = None;

#[no_mangle]
pub extern "sysv64" fn _start(payload: BootPayload) -> ! {
    println!("KERNEL START");
    
    unsafe {
        // store the payload in a static variable
        // this circumvents the difficulty of accessing the data after the stack switch
        PAYLOAD = Some(payload);

        // switch the stacks onto loader pre-allocated stack area
        // mem::KERNEL_STACK_BOTTOM itself is unmapped, thus reduce by sixteen (preserves alignment)
        asm!("mov rsp, {}", in(reg) mem::KERNEL_STACK_BOTTOM - 0x10, options(preserves_flags));
    };

    // jump to main immediately; don't touch the stack
    main();
}

fn main() -> ! {
    // retrieve the payload
    let payload = unsafe { core::mem::replace(&mut PAYLOAD, None).unwrap() };

    println!("KERNEL MAIN");
    println!("UART Chip Version: {:?}", out::uart::UART_COM1.1);
    

    // parse out tables
    //let mut rsdp: *const c_void;
    for table in payload.st.config_table() {
        match table.guid {
            uefi::table::cfg::ACPI2_GUID => { /* rsdp = table.address; */ },
            uefi::table::cfg::ACPI_GUID => { },
            uefi::table::cfg::PROPERTIES_TABLE_GUID => { /* not useful */ },
            _ => (),
        }
    }

    
    let payload = mem::paging_setup(payload);
    mem::alloc_setup();
    
    unsafe { *payload.frame_buffer_ptr.cast() = u128::MAX; }



    unsafe {
        ALLOCATOR.init(mem::sysalloc::ArenaConfig { base: 0, size: 0, smlst_pow2: 0 }, core::ptr::null_mut());
    }

    println!("here8");
    amd64::hlt_loop();
    
    
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
