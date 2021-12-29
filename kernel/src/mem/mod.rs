//! Module for memory management-related code of the OS.

//mod pmemm;
pub mod sysalloc;

use amd64::{
    registers::{CR3, CR0},
    segmentation::{self, CodeSegmentDescriptor, SegmentSelector},
    paging::{self, PTE}
};
use core::slice;
use uefi::table::boot::MemoryType;

/// Kernel code model lower bound address.
pub const KERNEL_CM_LOWER_BOUND: u64 = 0o177777_777_776_000_000_0000;
/// Kernel code model upper bound address.
pub const KERNEL_CM_UPPER_BOUND: u64 = 0o177777_777_777_770_000_0000;

/// The offset to displace physical addresses into linear address space.
pub const PHYS_LADDR_OFFSET: u64 = paging::CANONICAL_HIGHER_HALF + paging::PML4E_MAPPED_SIZE;
/// The index to recurr through the PML4T onto itself.
pub const RECURSIVE_INDEX: u64 = 0o400;

pub const KERNEL_STACK_BOTTOM: u64 = KERNEL_CM_LOWER_BOUND - paging::PTE_MAPPED_SIZE;
pub const KERNEL_STACK_PAGE_COUNT: u64 = 32;



#[inline]
fn pt_from_getter<F: FnMut() -> u64>(get_page: &mut F) -> &'static mut [PTE] {
    unsafe {
        let table = slice::from_raw_parts_mut(get_page() as *mut PTE, 512);
        table.fill(PTE::empty());
        table
    }
}

/// Maps the memory of base `phys_base` and size `page_count * 4KiB`, to `virt_base` linear address
/// and subsequent addresses according to the size. Pages use flags `branch_entry` for non-PTEs
/// (PDEs, PDPEs, etc.), and `leaf_entry` for PTEs. `table` does not have to be active. `level` would
/// be `4` for a PML4T. `get_page` should return the base of available pages to be used to store page tables.
/// 
/// 
/// 
/// NOTE: `virt_base`, `phys_base`, and `page_count` are all modified over the course of the function.
/// It is recommended that you provide a reference to a clone of the values instead. Using the modified
/// values are implementation-defined, and the implementation may change.
/// # Safety:
/// * the current memory translation must be identity mapping
/// * `EFER::NXE` must be set if the specified `PTE`s use the corresponding flag
/// * `virt_base` should not be occupied under the provided PML4T
/// * `get_pages` should return sufficient valid pages for mapping
/// * the specified `PTE`s must be valid
/// * `pml4t` must be valid
/// * and probably more...
pub unsafe fn map_pages_when_ident<F>(virt_base: &mut u64, phys_base: &mut u64, page_count: &mut u64,
branch_entry: PTE, leaf_entry: PTE, level: usize, table: &mut [PTE], get_page: &mut F)
where F: FnMut() -> u64 {
    if level > 1 {
        while *page_count > 0 {
            let table_index = ((*virt_base & 0o7770 << level * 9) >> level * 9 + 3) as usize;

            // allocate new page table if none exists
            if !table[table_index].contains(PTE::PRESENT) {
                let page_table = pt_from_getter(get_page);
                table[table_index] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(page_table.as_ptr() as u64);
            }
            
            let lower_table = slice::from_raw_parts_mut(table[table_index].get_paddr() as *mut PTE, 512);

            map_pages_when_ident(
                virt_base,
                phys_base,
                page_count,
                branch_entry,
                leaf_entry,
                level - 1,
                lower_table,
                get_page);

            if table_index == 511 {
                break;
            }
        }
    } else {
        while *page_count > 0 {
            let table_index = paging::pt_index(*virt_base); // level = 1
            table[table_index] = PTE::from_paddr(*phys_base) | leaf_entry;
            
            *page_count -= 1;
            *virt_base += paging::PTE_MAPPED_SIZE;
            *phys_base += paging::PTE_MAPPED_SIZE;

            if table_index == 511 {
                break;
            }
        }
    }
}


pub fn paging_setup(mut payload: crate::BootPayload) -> crate::BootPayload {

    /*                                     SET UP PAGING
    Goals:
     - all pages should be immediately accessible without 'walking'
     - all of physical memory should be immediately accessible without 'walking'
     - the linear addresses to achieve the above should not interfere with the canonical lower half

    A combination of the resursive page table entry mechanism and a fixed-offset memory mapping are used.

    While fixed-offset mapping can be employed in a manner that dually allows for immidiate addressal of 
    page tables by laying the tables out over physical memory in a regular manner (fragmenting physical
    address space but allowing virtual address space to rectify that), it risks colliding with already
    reserved memory, which UEFI makes no guarantees as to where that may be. Thus page tables are stored
    wherever available, and rescursive paging allows for immediate access to them, all the while addressing
    unmapped page tables is still convenient.
    
    The recursive index is 256 (0o400, 0x100) (the first of the canonical higher half).
    The fixed offset is 0xffff_8080_0000_0000, essentially FROM pml4t index 257, mapped using 1GiB size pages.
    
    It is guaranteed by the handoff state of UEFI and the OS loader that physical memory is flat/identity-mapped
    and that segmentation, by virtue of being in long mode, is essentially disabled.
    All pages are located within LOADER_DATA and BOOT_SERVICES_DATA memory regions as speficied by the UEFI map.
    */

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
    pml4t[RECURSIVE_INDEX as usize] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pml4t.as_ptr() as u64);

    // map physical memory
    let pmap_pdpt = pt_from_getter(&mut get_page);
    pml4t[paging::pml4t_index(PHYS_LADDR_OFFSET)] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pmap_pdpt.as_ptr() as u64);

    for phys_gibi in 0..((total_phys_size + paging::PDPE_MAPPED_SIZE - 1) / paging::PDPE_MAPPED_SIZE) { // round up
        pmap_pdpt[phys_gibi as usize] = PTE::PRESENT | PTE::WRITE | PTE::HUGE_PAGE | PTE::from_paddr(phys_gibi * paging::PDPE_MAPPED_SIZE);
    }

    // map the UEFI GOP frame buffer into fixed-offset space too
    // it is identity mapped outside of physical address space - per testing
    pmap_pdpt[paging::pdpt_index(payload.frame_buffer_ptr as u64 + PHYS_LADDR_OFFSET)] = 
        PTE::PRESENT | PTE::WRITE | PTE::HUGE_PAGE | PTE::from_paddr(payload.frame_buffer_ptr as u64);
    // check if a second page is needed (shouldn't be the case, the framebuffer is usually - per testing - gibibyte-aligned)
    let fb_size = payload.frame_buffer_info.stride() * payload.frame_buffer_info.resolution().1 * crate::out::framebuffer::PIXEL_WIDTH;
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
        uefi_pml4t[RECURSIVE_INDEX as usize] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(uefi_cr3.get_paddr());
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

        let phys_base = unsafe { *(paging::recur_to_pte(phdr.vaddr(), RECURSIVE_INDEX) as *mut PTE) }.get_paddr();

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
            map_pages_when_ident(
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
        let stack_virt_base = KERNEL_STACK_BOTTOM - KERNEL_STACK_PAGE_COUNT * paging::PTE_MAPPED_SIZE;
        map_pages_when_ident(
            &mut stack_virt_base.clone(),
            &mut (*(paging::recur_to_pte(stack_virt_base, RECURSIVE_INDEX) as *const PTE)).get_paddr(),
            &mut KERNEL_STACK_PAGE_COUNT.clone(), 
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
            payload.mmap.as_mut_ptr().cast::<u8>().wrapping_add(PHYS_LADDR_OFFSET as usize).cast(), 
            core::ptr::metadata(payload.mmap))
    };
    payload.bin = unsafe {
        slice::from_raw_parts(
            payload.bin.as_ptr().wrapping_add(PHYS_LADDR_OFFSET as usize), 
            core::ptr::metadata(payload.bin))
    };
    payload.frame_buffer_ptr = payload.frame_buffer_ptr.wrapping_add(PHYS_LADDR_OFFSET as usize);

    
    // fix up UEFI system table references and runtime mappings
    payload.mmap.iter_mut().for_each(|desc| desc.virt_start = desc.phys_start + PHYS_LADDR_OFFSET);

    
    payload
}

pub fn alloc_setup() {
    // choose and map memory span for kernel heap
    // initialize global allocator
    // profit
}





pub fn segmentation_setup() {
    // todo: consider doing after alloc and setting up properly, rather than 2 stage?
    // todo: finish tss/fs/gs/other setup


    // Segmentation is mostly disabled in long, 64-bit mode. However some elements are still used:
    //  - The attributes of a code segment
    //  - The FS and GS registers and associated data segments
    //  - The TS register and associated TSS
    //
    // For now, the GDT set up by the UEFI is taken over and overwritten, and a basic layout is issued.

    // nab the uefi gdt for now
    let uefi_gdt = segmentation::sgdt();
    

    // ensure the size is sufficient for the setup process
    if uefi_gdt.len() < 2 {
        todo!();
    }


    uefi_gdt.iter_mut().for_each(|entry| *entry = 0);

    uefi_gdt[0] = 0;
    uefi_gdt[1] = 
        ( CodeSegmentDescriptor::PRESENT
        | CodeSegmentDescriptor::CONFORMING
        | CodeSegmentDescriptor::EXECUTABLE
        | CodeSegmentDescriptor::TYPE
        | CodeSegmentDescriptor::LONG_MODE
        | CodeSegmentDescriptor::DPL_RING0).bits();

    // todo!

    unsafe {
        // load in the GDT just to make sure
        segmentation::lgdt(uefi_gdt);

        // reset CS register so that the new GDT entry is used
        segmentation::cs_write(SegmentSelector::new_gdt(amd64::PriviledgeLevel::Ring0, 1));
    }
}




   /*  // the kernel is linked as follows:
    //   higher half kernel using code-model 'kernel' (see Sys V ABI):
    //    - lower bound address: 0xffffffff80000000 or 0o177777_777_776_000_000_0000
    //    - upper bound address: 0xffffffffff000000 or 0o177777_777_777_770_000_0000
    // thus only PML4E 511, and thereunder, PDPEs 510 and 511 are used

    // create upper kernel mapping pages
    let pdpt_kn_data = pt_from_getter(&mut get_page);
    pml4t[511] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pdpt_kn_data.as_ptr() as u64);
    let pdt_510_kn_data = pt_from_getter(&mut get_page);
    pdpt_kn_data[510] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pdt_510_kn_data.as_ptr() as u64);
    let pdt_511_kn_data = pt_from_getter(&mut get_page);
    pdpt_kn_data[511] = PTE::PRESENT | PTE::WRITE | PTE::from_paddr(pdt_511_kn_data.as_ptr() as u64); */
