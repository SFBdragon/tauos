
// map a 4kb, 2mb, 1gb page
//   map 
// map ranges of those pages
// 

use core::{slice, ptr::NonNull};

use amd64::paging::{PTE, self};





pub struct Frame {
    // base: u64,
    
}


pub fn invlpg_all() {
    unsafe {
        amd64::registers::CR3::write(amd64::registers::CR3::read())
    }
}

pub fn invlpg(laddr: u64) {
    unsafe {
        core::arch::asm!(
            "invlpg {}",
            in(reg) laddr,
            options(nomem, nostack, preserves_flags)
        );
    }
}



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
pub unsafe fn map_pages_identity<F>(virt_base: u64, phys_base: u64, page_count: u64,
branch_entry: PTE, leaf_entry: PTE, page_getter: &mut F)
where F: FnMut() -> u64 {
    let mut temp_vb = virt_base;
    let mut temp_pb = phys_base;
    let mut temp_pc = page_count;

    let pml4 = core::slice::from_raw_parts_mut(
        amd64::registers::CR3::read().get_paddr() as *mut _,
        512
    );

    // SAFETY: caller guaranteed
    map_pages_identity_inner(
        &mut temp_vb,
        &mut temp_pb, 
        &mut temp_pc, 
        branch_entry, 
        leaf_entry, 
        4, 
        pml4, 
        page_getter
    );
}

/// See documentation for `mapping::map_pages_identity`, and use it 
/// instead where possible.
/// 
/// `table` does not have to be active. `level` would be `4` for a PML4. 
/// 
/// Note that contrary to the above function's behaviour, `laddr`, `paddr`
/// and `page_count` are internally modified, their state on return is
/// implementation-defined. CR0::WP is also not modified.
/// 
/// # Safety:
/// As well as `mapping::map_pages_identity`'s safety requirements, `table`
/// and `level` need to be valid and complementary.
pub unsafe fn map_pages_identity_inner<F>(laddr: &mut u64, paddr: &mut u64, 
page_count: &mut u64, branch_entry: PTE, leaf_entry: PTE, level: usize, 
table: &mut [PTE], page_getter: &mut F)
where F: FnMut() -> u64 {
    // loop across the entries
    while *page_count > 0 {
        let table_index = paging::table_index(*laddr, level);
        let page_size = paging::page_size(level);

        // if manipulating a page table, always create a mapping, or
        // try to use a huge page entry, else navigate down the tree
        if level == 0 || *page_count >= page_size && level < 4 {
            table[table_index] = PTE::from_paddr(*paddr) | leaf_entry;

            if level != 0 {
                table[table_index] |= PTE::HUGE_PAGE;
            }
            
            *page_count -= page_size / paging::PTE_MAPPED_SIZE;
            *laddr += page_size;
            *paddr += page_size;
        } else {
            // allocate new page table if none exists
            if !table[table_index].contains(PTE::PRESENT) 
            || table[table_index].contains(PTE::HUGE_PAGE) {
                // SAFETY: guaranteed by caller
                let page_table = core::slice::from_raw_parts_mut(
                    page_getter() as *mut PTE, 
                    512
                );
                page_table.fill(PTE::empty());
                
                table[table_index] = PTE::from_paddr(page_table.as_ptr() as u64) | branch_entry;
            }
            
            let lower_table = slice::from_raw_parts_mut(
                table[table_index].get_paddr() as *mut PTE, 
                512
            );

            // navigate down the page table tree
            map_pages_identity_inner(
                laddr,
                paddr,
                page_count,
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



macro_rules! page_map_inner {
    ($rcr_fn:expr, $nxt_rcr_fn:expr, $pml4e_idx:expr,
    $laddr:expr, $page_getter:expr, $branch_entry:expr, $hpage:block) => {
        let entry = guest_pml4(
            $rcr_fn($laddr, super::RECURSIVE_IDX),
            $pml4e_idx
        ) as *mut PTE;

        { $hpage }

        if !(*entry).contains(PTE::PRESENT) {
            *entry = PTE::from_paddr($page_getter()) | $branch_entry;
            NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(paging::table_of_entry(
                    $nxt_rcr_fn($laddr, super::RECURSIVE_IDX)
                ) as *mut PTE),
                512
            ).as_uninit_slice_mut().fill(core::mem::MaybeUninit::new(PTE::empty()));
        }
    };
}


// TODO FIXME ADDRESS ALIGNEMENT + HUGE PAGES

/// Maps the memory of base `paddr` and size `page_count * 4KiB`, to `laddr` 
/// linear address and subsequent addresses according to the size. Pages use flags 
/// `branch_entry` for non-PTEs (PDEs, PDPEs, etc.), and `leaf_entry` for PTEs, 
/// HPDEs, etc. `get_page` should return the physical base of available pages to 
/// be used to store page tables. 
/// 
/// # Safety:
/// * A recursive PML4 entry must be installed at `memm::RECURSIVE_IDX`.
/// * The index `pml4e_idx` should either be recursive or the entry should physical 
/// address another PML4 with a recursive index at `memm::RECURSIVE_IDX`.
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * `EFER::NXE` must be set if the specified `PTE`s use the NX flag.
/// * `page_getter` should return sufficient valid pages for necessary page tables.
/// * The specified `PTE`s must be valid.
pub unsafe fn map_pages_recursv<F>(mut laddr: u64, mut paddr: u64, mut page_count: u64, 
branch_entry: PTE, leaf_entry: PTE, page_getter: &mut F, pml4e_idx: u64)
where F: FnMut() -> u64 {
    use paging::*;

    while page_count > 0 {
        page_map_inner!(recur_to_pml4e, recur_to_pdpte, 
            pml4e_idx, laddr, page_getter, branch_entry, {});

        while page_count > 0 {
            page_map_inner!(recur_to_pdpte, recur_to_pde, 
                pml4e_idx, laddr, page_getter, branch_entry, {});

            while page_count > 0 {
                page_map_inner!(recur_to_pde, recur_to_pte, 
                    pml4e_idx, laddr, page_getter, branch_entry, {
                    if PDE_MAPPED_SIZE > page_count && laddr & PDE_MAPPED_SIZE - 1 == 0 {
                        let pde = guest_pml4(
                            recur_to_pde(laddr, super::RECURSIVE_IDX), 
                            pml4e_idx
                        ) as *mut PTE;
                        *pde = PTE::from_paddr(paddr) | PTE::HUGE_PAGE | leaf_entry;

                        page_count -= 512;
                        laddr += PDE_MAPPED_SIZE;
                        paddr += PDE_MAPPED_SIZE;

                        continue;
                    }
                });
        
                while page_count > 0 {
                    let pte = guest_pml4(
                        recur_to_pte(laddr, super::RECURSIVE_IDX), 
                        pml4e_idx
                    ) as *mut PTE;
                    *pte = PTE::from_paddr(paddr) | leaf_entry;

                    page_count -= 1;
                    laddr += PTE_MAPPED_SIZE;
                    paddr += PTE_MAPPED_SIZE;

                    if laddr & PDE_MAPPED_SIZE - 1 == 0 { break; }
                }
                if laddr & PDPTE_MAPPED_SIZE - 1 == 0 { break; }
            }
            if laddr & PML4E_MAPPED_SIZE - 1 == 0 { break; }
        }
    }
}

pub unsafe fn unmap_pages_recursv(mut laddr: u64, mut page_count: u64, pml4e_idx: u64) {
    while page_count > 0 && laddr & paging::PDE_MAPPED_SIZE - 1 != 0 {
        let entry_ptr = paging::recur_to_pte(laddr, super::RECURSIVE_IDX);
        *(paging::guest_pml4(entry_ptr, pml4e_idx) as *mut _) = PTE::empty();
        laddr += paging::PTE_MAPPED_SIZE;
        page_count -= 1;
    }

    while page_count > 512 {
        let entry_ptr = paging::recur_to_pde(laddr, super::RECURSIVE_IDX);
        *(paging::guest_pml4(entry_ptr, pml4e_idx) as *mut _) = PTE::empty();
        laddr += paging::PDE_MAPPED_SIZE;
        page_count -= 512;
    }
    
    while page_count > 0 {
        let entry_ptr = paging::recur_to_pte(laddr, super::RECURSIVE_IDX);
        *(paging::guest_pml4(entry_ptr, pml4e_idx) as *mut _) = PTE::empty();
        laddr += paging::PTE_MAPPED_SIZE;
        page_count -= 1;
    }
}

pub unsafe fn invlpgs_recursv(mut laddr: u64, mut page_count: u64) {
    while page_count > 0 && laddr & paging::PDE_MAPPED_SIZE - 1 != 0 {
        invlpg(laddr);
        laddr += paging::PTE_MAPPED_SIZE;
        page_count -= 1;
    }

    while page_count > 512 {
        invlpg(laddr);
        laddr += paging::PDE_MAPPED_SIZE;
        page_count -= 512;
    }
    
    while page_count > 0 {
        invlpg(laddr);
        laddr += paging::PTE_MAPPED_SIZE;
        page_count -= 1;
    }
}

/* #[derive(Debug)] // todo fixme
pub struct Mapping {
    base_laddr: u64,
    acme_laddr: u64,
}
impl Mapping {
    pub unsafe fn new(base_laddr: u64, page_count: u64) -> Self {
        Mapping { base_laddr, page_count }
    }
    fn iter_entries() -> core::slice::It {
        todo!()
    }
}

/// Immutable mapping iterator.
/// 
/// This struct is created by the `iter` method on `Mapping`s.
#[derive(Debug)]
pub struct Iter<'a> {
    mapping_ref: &'a Mapping,
    base_laddr: u64,
    acme_laddr: u64,
    page_count: u64,
}
impl<'a> Iter<'a> {
    fn new(mapping: &'a Mapping) -> Self {
        Iter { 
            mapping_ref: mapping,
            base_laddr: mapping.base_laddr, 
            acme_laddr: mapping.base_laddr + mapping.page_count * paging::PTE_MAPPED_SIZE, 
            page_count: mapping.page_count,
        }
    }
}
impl<'a> Iterator for Iter<'a> {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        if page_count > 0 {
            if page_count < 512 || self.base_laddr & paging::PDE_MAPPED_SIZE - 1 != 0 {

            } else {

            }
        } else {
            None
        }
    }
} */

