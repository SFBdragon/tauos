#![no_std]
#![no_main]
#![feature(ptr_metadata)]
#![feature(alloc_error_handler)]

use core::{panic::PanicInfo, slice};
 
use amd64::{self, paging::{self, PTE}, registers::{CR3, CR0}, segmentation::{CodeSegmentDescriptor, self, SegmentSelector}};
use libkernel::{BootPayload, memman, println, out};
use uefi::table::boot::MemoryType;


static mut PAYLOAD: Option<BootPayload> = None;

#[no_mangle]
#[allow(improper_ctypes_definitions)] // doesn't get called by C code
pub extern "sysv64" fn _start(payload: BootPayload) -> ! {
    println!("KERNEL START");
    
    unsafe {
        // store the payload in a static variable
        // this circumvents the difficulty of accessing old stack data after the stack switch
        PAYLOAD = Some(payload);

        // switch the stacks onto loader pre-allocated stack area
        // mem::KERNEL_STACK_BOTTOM itself is unmapped, thus reduce by sixteen (preserves alignment)
        core::arch::asm!("mov rsp, {}", in(reg) memman::KERNEL_STACK_BOTTOM - 0x10, options(preserves_flags));
    };

    // jump to init immediately; don't touch the stack
    init();
}

fn init() -> ! {
    // retrieve the payload
    let payload = unsafe { core::mem::replace(&mut PAYLOAD, None).unwrap() };

    println!("KERNEL INIT");
    println!("UART Chip Version: {:?}", out::uart::UART_COM1.1);

    println!("{}", payload.mmap.iter().fold(0, |s, x| s + x.page_count));
    

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

    
    let payload = unsafe { paging_setup(payload) };
    
    unsafe { *payload.frame_buffer_ptr.cast() = u128::MAX; }

    unsafe { alloc_setup(&payload); } // todo

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


/// # Safety:
/// Do not call twice. Assumes UEFI- & OS loader-defined handoff state.
pub unsafe fn paging_setup(mut payload: crate::BootPayload) -> crate::BootPayload {

    /*                                     SET UP PAGING
    Goals:
    - all pages should be immediately accessible without walking
    - all of physical memory should be immediately accessible without walking
    - the linear addresses to achieve the above should not interfere with the canonical lower half

    Solution:
    A combination of the resursive page table entry mechanism and fixed-offset memory mapping.
    - The recursive index is 256 (0o400, 0x100) (the first of the canonical higher half).
    - The fixed offset is 0xffff_8080_0000_0000, essentially FROM pml4t index 257, mapped using 1GiB size pages.

    Rationale:
    While fixed-offset mapping can be employed in a manner that dually allows for immidiate addressal of 
    page tables by laying the tables out over physical memory in a regular manner (fragmenting physical
    address space but allowing virtual address space to rectify that), it risks colliding with already
    reserved memory, which UEFI makes no guarantees as to where that may be. Thus page tables are stored
    wherever available, and rescursive paging allows for immediate access to them, all the while addressing
    unmapped page tables is still convenient.
    
    Notes:
    It is guaranteed by the handoff state of UEFI and the OS loader that physical memory is flat/identity-mapped
    and that segmentation, by virtue of being in long mode, is essentially disabled.
    All pages are located within LOADER_DATA and BOOT_SERVICES_DATA memory regions as speficied by the UEFI map.
    */

    #[inline]
    fn pt_from_getter<F: FnMut() -> u64>(get_page: &mut F) -> &'static mut [PTE] {
        unsafe {
            let table = core::slice::from_raw_parts_mut(get_page() as *mut PTE, 512);
            table.fill(PTE::empty());
            table
        }
    }


    // find the size of physical memory
    let total_phys_pages = payload.mmap.iter().fold(0, |acc, desc| acc + desc.page_count);
    let total_phys_size = total_phys_pages * paging::PTE_MAPPED_SIZE;

    // find a large hole in physical memory free for use (there's generally at least one massive one)
    let largest = payload.mmap.iter_mut()
        .filter(|desc| desc.ty == MemoryType::CONVENTIONAL)
        .max_by(|x, y| x.phys_start.cmp(&y.phys_start))
        .expect("failed to find a free memory region");
    // create an iterator over the pages therein
    let mut page_iter = 
        (largest.phys_start as isize..(largest.phys_start + largest.page_count * paging::PTE_MAPPED_SIZE) as isize)
        .step_by(paging::PTE_MAPPED_SIZE as usize)
        .rev()
        .map(|x| x as u64);
    // create getter
    let mut get_page = || page_iter.next().unwrap();

    // set up CR3
    let mut cr3 = CR3::without_pcid(0);
    let pml4t = pt_from_getter(&mut get_page);
    cr3.set_paddr(pml4t.as_ptr() as u64);

    // install recursive entry
    pml4t[memman::RECURSIVE_INDEX as usize] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pml4t.as_ptr() as u64);

    // map physical memory
    let pmap_pdpt = pt_from_getter(&mut get_page);
    pml4t[paging::pml4t_index(memman::PHYS_LADDR_OFFSET)] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pmap_pdpt.as_ptr() as u64);

    for phys_gibi in 0..((total_phys_size + paging::PDPE_MAPPED_SIZE - 1) / paging::PDPE_MAPPED_SIZE) { // round up
        pmap_pdpt[phys_gibi as usize] = PTE::PRESENT | PTE::WRITE | PTE::HUGE_PAGE | PTE::from_paddr(phys_gibi * paging::PDPE_MAPPED_SIZE);
    }

    // map the UEFI GOP frame buffer into fixed-offset space too
    // it is identity mapped outside of physical address space - per testing
    pmap_pdpt[paging::pdpt_index(payload.frame_buffer_ptr as u64 + memman::PHYS_LADDR_OFFSET)] = 
        PTE::PRESENT | PTE::WRITE | PTE::HUGE_PAGE | PTE::from_paddr(payload.frame_buffer_ptr as u64);
    // check if a second page is needed (shouldn't be the case, the framebuffer is usually - per testing - gibibyte-aligned)
    let fb_size = payload.frame_buffer_info.stride() * payload.frame_buffer_info.resolution().1 * out::framebuffer::PIXEL_WIDTH;
    if (payload.frame_buffer_ptr as u64 & (paging::PDPE_MAPPED_SIZE - 1)) + fb_size as u64 > paging::PDPE_MAPPED_SIZE {
        pmap_pdpt[payload.frame_buffer_ptr as usize / paging::PDPE_MAPPED_SIZE as usize + 1] = PTE::PRESENT | PTE::WRITE | PTE::HUGE_PAGE
            | PTE::from_paddr(payload.frame_buffer_ptr as u64 + paging::PDPE_MAPPED_SIZE & !(paging::PDPE_MAPPED_SIZE - 1));
    }
    

    // map the kernel
    
    // install a recursive entry into the existing UEFI-setup pml4t
    {
        let uefi_cr3 = CR3::read();
        let uefi_pml4t = unsafe { slice::from_raw_parts_mut(uefi_cr3.get_paddr() as *mut PTE, 512) };
        unsafe { CR0::write(&(CR0::read() & !CR0::WP)); } // UEFI page tables tend to be write-protected
        uefi_pml4t[memman::RECURSIVE_INDEX as usize] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(uefi_cr3.get_paddr());
        unsafe { CR0::write(&(CR0::read() | CR0::WP)); } // reset to prevent silent bugs
    }

    // hunt down the locations of the physical memory of the load segments
    let elf = match elf_rs::Elf::from_bytes(payload.bin).expect("elf data parse failed") {
        elf_rs::Elf::Elf64(elf) => elf,
        elf_rs::Elf::Elf32(_) => panic!("32 bit kernel binary is unsuported"),
    };

    let phdr_iter = elf.program_headers().iter()
        .filter(|&phdr| phdr.ph_type() == elf_rs::ProgramType::LOAD && phdr.flags() != 0 );
    for phdr in phdr_iter {
        // get physical address of the program segment

        let phys_base = unsafe { *(paging::recur_to_pte(phdr.vaddr(), memman::RECURSIVE_INDEX) as *mut PTE) }.get_paddr();

        // remap the program segment

        let page_count = (phdr.memsz() + paging::PTE_MAPPED_SIZE - 1) / paging::PTE_MAPPED_SIZE;

        let mut leaf_entry = PTE::PRESENT;
        if phdr.flags() & 0b01 == 0 {
            leaf_entry |= PTE::NO_EXECUTE;
        }
        if phdr.flags() & 0b10 != 0 {
            leaf_entry |= PTE::WRITE;
        } 

        unsafe {
            libkernel::memman::map_pages_when_ident(
                &mut phdr.vaddr().clone(),
                &mut phys_base.clone(),
                &mut page_count.clone(), 
                PTE::PRESENT | PTE::WRITE, 
                leaf_entry, 
                4,
                pml4t,
                &mut get_page,
            );
        }
    }

    // remap the stack
    unsafe {
        let stack_virt_base = memman::KERNEL_STACK_BOTTOM - memman::KERNEL_STACK_PAGE_COUNT * paging::PTE_MAPPED_SIZE;
        libkernel::memman::map_pages_when_ident(
            &mut stack_virt_base.clone(),
            &mut (*(paging::recur_to_pte(stack_virt_base, memman::RECURSIVE_INDEX) as *const PTE)).get_paddr(),
            &mut memman::KERNEL_STACK_PAGE_COUNT.clone(), 
            PTE::PRESENT | PTE::WRITE, 
            PTE::PRESENT | PTE::WRITE | PTE::NO_EXECUTE, 
            4,
            pml4t,
            &mut get_page,
        );
    }

    
    // create a hole in the memory map to reserve the memory that has been used
    let next_page = (&mut get_page)();
    let pages_consumed = (next_page - largest.phys_start) / paging::PTE_MAPPED_SIZE;
    largest.page_count -= pages_consumed;

    
    // load in the new CR3, which automatically invalidates TLB pages
    unsafe { CR3::write(cr3); }


    // fix up references

    payload.mmap = unsafe {
        slice::from_raw_parts_mut(
            payload.mmap.as_mut_ptr().cast::<u8>().wrapping_add(memman::PHYS_LADDR_OFFSET as usize).cast(), 
            core::ptr::metadata(payload.mmap))
    };
    payload.bin = unsafe {
        slice::from_raw_parts(
            payload.bin.as_ptr().wrapping_add(memman::PHYS_LADDR_OFFSET as usize), 
            core::ptr::metadata(payload.bin))
    };
    payload.frame_buffer_ptr = payload.frame_buffer_ptr.wrapping_add(memman::PHYS_LADDR_OFFSET as usize);

    
    // fix up UEFI system table references and runtime mappings
    payload.mmap.iter_mut().for_each(|desc| desc.virt_start = desc.phys_start + memman::PHYS_LADDR_OFFSET);

    
    payload
}

/* 
#[global_allocator]
static mut ALLOCATOR: memman::talloc::Talloc = unsafe { 
    let x = memman::talloc::Talloc::new_invalid();
    x.init_arena(base, size, smallest_allocatable_size);
    x
};

static mut MAPPER: map = unsafe { map }; */

/// # Safety:
/// Do not call twice. Assumes allocators have yet to be initialized.
pub unsafe fn alloc_setup(_payload: &BootPayload) {
    // todo!

    

    // maybe dont seperate into mapping setup and alloc setup due to tracking memory reservation requirements?
    // extend this to paging setup? no need, there's a hole in mmem to detect

    // use an allocator to manage physical memory with page-granularity
    // reserve all the pages that need to be reserved
    // set up a mapper that uses the pmemallocator to map pages


   /*  unsafe {
        ALLOCATOR.init_books( // fixme: use the mapper
            slice::from_raw_parts_mut(data, ALLOCATOR.llists_len()),
            slice::from_raw_parts_mut(data, ALLOCATOR.bitmap_len())
        );
    } */
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
    let uefi_gdt = segmentation::sgdt();
    

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
        segmentation::cs_write(SegmentSelector::new_gdt(amd64::PriviledgeLevel::Ring0, 1));
    }
}

