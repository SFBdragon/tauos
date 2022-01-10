//! Module for memory management-related code of the OS.

pub mod talloc;

use amd64::paging::{self, PTE};
use core::slice;

/// Kernel code model lower bound address.
pub const KERNEL_CM_LOWER_BOUND: u64 = 0o177777_777_776_000_000_0000;
/// Kernel code model upper bound address.
pub const KERNEL_CM_UPPER_BOUND: u64 = 0o177777_777_777_770_000_0000;

/// The offset to displace physical addresses into linear address space.
pub const PHYS_LADDR_OFFSET: u64 = paging::CANONICAL_HIGHER_HALF + paging::PML4E_MAPPED_SIZE;
/// The index to recurr through the PML4T onto itself.
pub const RECURSIVE_INDEX: u64 = 0o400;

pub const KERNEL_STACK_BOTTOM: u64 = KERNEL_CM_LOWER_BOUND - paging::PTE_MAPPED_SIZE;
pub const KERNEL_STACK_PAGE_COUNT: u64 = 128;




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
/// * `virt_base` should not be otherwise in use under the provided PML4T
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
                let page_table = core::slice::from_raw_parts_mut(get_page() as *mut PTE, 512);
                page_table.fill(PTE::empty());
                
                table[table_index] = PTE::from_paddr(page_table.as_ptr() as u64) | branch_entry;
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
