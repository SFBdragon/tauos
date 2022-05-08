/// Maps the memory of base `paddr` and size `page_count * 4KiB`, to `laddr` 
/// linear address and subsequent addresses according to the size. Pages use flags 
/// `branch_entry` for non-PTEs (PDEs, PDPEs, etc.), and `leaf_entry` for PTEs, 
/// HPDEs, etc. `get_page` should  return the base of available pages to be used to 
/// store page tables. 
/// 
/// # Safety:
/// * Physical addresses of the page tables must be identity mapped.
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * `EFER::NXE` must be set if the specified `PTE`s use the NX flag.
/// * `page_getter` should return sufficient valid pages for necessary page tables.
/// * The specified `PTE`s must be valid.
pub unsafe fn map_pages_identity<F>(laddr: *mut u8, paddr: usize, 
count: usize, branch_entry: PTE, leaf_entry: PTE, level: usize, 
table: *mut [PTE], page_getter: &mut F)
where F: FnMut() -> usize {
    let mut offset = 0;

    // loop across the entries
    while offset / paging::PTE_MAPPED_SIZE < count {
        let table_index = paging::table_index(laddr, level);
        let pte = table.get_unchecked_mut(table_index);
        let page_size = paging::page_size(level);

        // if manipulating a page table, always create a mapping, or
        // try to use a huge page entry, else navigate down the tree
        let left_over = count * paging::PTE_MAPPED_SIZE - offset;
        if level == 0 || left_over >= page_size && level < 4 {
            *pte = PTE::from_paddr(paddr + offset) | leaf_entry;

            if level != 0 {
                *pte |= PTE::HUGE_PAGE;
            }
            
            offset += page_size;
        } else {
            // allocate new page table if none exists
            if !(*pte).contains(PTE::PRESENT) {
                // SAFETY: guaranteed by caller
                let page = page_getter() as *mut PTE;
                page.write_bytes(0, 512);
                
                *pte = PTE::from_paddr(page as usize) | branch_entry;
            }
            
            let lower_table = core::ptr::slice_from_raw_parts_mut(
                (*pte).get_paddr() as *mut PTE, 
                512
            );

            // navigate down the page table tree
            map_pages_identity(
                laddr,
                paddr,
                count,
                branch_entry,
                leaf_entry,
                level - 1,
                lower_table,
                page_getter
            );
        }

        if table_index == 511 {
            break;
        }
    }
}


#[inline]
pub fn invlpg_all() {
    amd64::registers::CR3::reload();
}
#[inline]
pub fn invlpg(laddr: u64) {
    unsafe {
        core::arch::asm!(
            "invlpg {}",
            in(reg) laddr,
            options(nomem, nostack, preserves_flags)
        );
    }
}
