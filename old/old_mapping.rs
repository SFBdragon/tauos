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







//! Core mapping utilities.

use core::marker::PhantomData;
use amd64::paging::{PTE, self, PageSize};

macro_rules! map_rcrsv_inner {
    ($base:expr, $acme:expr, $page_getter:expr, $branch_entry:expr,
    $inner:block, $rcr_fn:expr, $nxt_rcr_fn:expr, $mapd_size:expr, $pml4e_idx:expr) => {
        while ($base as isize) < ($acme as isize) {
            let entry = paging::set_pml4_idx(
                $rcr_fn($base, super::RCRSV_IDX),
                $pml4e_idx
            );

            if !(*entry).contains(PTE::P) || (*entry).contains(PTE::PS) {
                *entry = PTE::from_paddr($page_getter()) | PTE::P | $branch_entry;
                paging::table_of_entry($nxt_rcr_fn($base, super::RCRSV_IDX))
                    .as_mut_ptr().write_bytes(0, 512);
            }

            $inner
            
            if $base.to_bits() + $mapd_size.wrapping_sub(1) == 0 {
                break;
            }
        }
    };
}

/// ### Safety:
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * A recursive PML4 entry must be installed at `memm::RCRSV_IDX`.
/// * The index `pml4e_idx`'s PTE of the active PML4 should address a PML4'.
/// * The specified `PTE`s must be valid.
/// * `EFER::NXE` must be set if the specified PTEs use the NX flag.
/// * `page_getter` should return sufficient valid pages for necessary page tables.
pub unsafe fn map_rcrsv_4kib<F>(mut base: *mut u8, acme: *mut u8, mut paddr: usize,
branch_entry: PTE, leaf_entry: PTE, page_getter: &mut F, pml4e_idx: usize)
where F: FnMut() -> usize {
    use paging::*;

    assert!((base.to_bits() | acme.to_bits() | paddr) & PTE_SIZE-1 == 0);
    
    map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
        map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
            map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
                while (base as isize) < (acme as isize) {
                    *set_pml4_idx(recur_to_pte(base, super::RCRSV_IDX), pml4e_idx) 
                        = PTE::from_paddr(paddr) | PTE::P | leaf_entry;
                    paddr += PTE_SIZE;
                    base = base.wrapping_add(PTE_SIZE);
                    if base.to_bits() & PDE_SIZE-1 == 0 {
                        break;
                    }
                }
            }, recur_to_pde, recur_to_pte, PDPTE_SIZE, pml4e_idx);
        }, recur_to_pdpte, recur_to_pde, PML4E_SIZE, pml4e_idx);
    }, recur_to_pml4e, recur_to_pdpte, 0usize, pml4e_idx);
}
/// ### Safety:
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * A recursive PML4 entry must be installed at `memm::RCRSV_IDX`.
/// * The index `pml4e_idx`'s PTE of the active PML4 should address a PML4'.
/// * The specified `PTE`s must be valid.
/// * `EFER::NXE` must be set if the specified PTEs use the NX flag.
/// * `page_getter` should return sufficient valid pages for necessary page tables.
pub unsafe fn map_rcrsv_2mib<F>(mut base: *mut u8, acme: *mut u8, mut paddr: usize,
branch_entry: PTE, leaf_entry: PTE, page_getter: &mut F, pml4e_idx: usize)
where F: FnMut() -> usize {
    use paging::*;

    assert!((base.to_bits() | acme.to_bits() | paddr) & PDE_SIZE-1 == 0);
    
    map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
        map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
            while (base as isize) < (acme as isize) {
                *set_pml4_idx(recur_to_pde(base, super::RCRSV_IDX), pml4e_idx) 
                    = PTE::from_paddr(paddr) | PTE::P | PTE::PS | leaf_entry;
                paddr += PDE_SIZE;
                base = base.wrapping_add(PDE_SIZE);
                if base.to_bits() & PDE_SIZE-1 == 0 {
                    break;
                }
            }
        }, recur_to_pdpte, recur_to_pde, PML4E_SIZE, pml4e_idx);
    }, recur_to_pml4e, recur_to_pdpte, 0usize, pml4e_idx);
}
/// ### Safety:
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * A recursive PML4 entry must be installed at `memm::RCRSV_IDX`.
/// * The index `pml4e_idx`'s PTE of the active PML4 should address a PML4'.
/// * The specified `PTE`s must be valid.
/// * `EFER::NXE` must be set if the specified PTEs use the NX flag.
/// * `page_getter` should return sufficient valid pages for necessary page tables.
pub unsafe fn map_rcrsv_1gib<F>(mut base: *mut u8, acme: *mut u8, mut paddr: usize,
branch_entry: PTE, leaf_entry: PTE, page_getter: &mut F, pml4e_idx: usize)
where F: FnMut() -> usize {
    use paging::*;

    assert!((base.to_bits() | acme.to_bits() | paddr) & PDPTE_SIZE-1 == 0);
    
    map_rcrsv_inner!(base, acme, page_getter, branch_entry, {
        while (base as isize) < (acme as isize) {
            *set_pml4_idx(recur_to_pde(base, super::RCRSV_IDX), pml4e_idx) 
                = PTE::from_paddr(paddr) | PTE::P | PTE::PS | leaf_entry;
            paddr += PDPTE_SIZE;
            base = base.wrapping_add(PDPTE_SIZE);
            if base.to_bits() & PDPTE_SIZE-1 == 0 {
                break;
            }
        }
    }, recur_to_pml4e, recur_to_pdpte, 0usize, pml4e_idx);
}

/// Description of a contiguous, mapped region of virtual memory.
#[derive(Debug)]
pub struct Mapping {
    base: *mut u8,
    acme: *mut u8,
    page_size: PageSize,
}
impl Mapping {
    pub unsafe fn new(base: *mut u8, acme: *mut u8, page_size: PageSize) -> Self {
        Mapping { base, acme, page_size }
    }
    /// Get an iterator over addresses mapped by this mapping. 
    /// ### Safety:
    /// Note that while this function is safe, the returned pointers are not 
    /// necessarily valid to dereference. This is the case, for instance,
    /// when the mapping is not active.
    pub fn iter_pages<'a>(&'a self) -> IterMut<'a> {
        IterMut::new(self)
    }
}

/// Immutable mapping iterator.
/// 
/// This struct is created by the `iter` method on `Mapping`s.
#[derive(Debug)]
pub struct IterMut<'a> {
    ptr: *mut u8,
    acme: *mut u8,
    page_size: PageSize,
    _phantom: PhantomData<&'a Mapping>
}
impl<'a> IterMut<'a> {
    fn new(mapping: &'a Mapping) -> Self {
        Self { 
            ptr: mapping.base,
            acme: mapping.acme,
            page_size: mapping.page_size,
            _phantom: PhantomData,
        }
    }
}
impl<'a> Iterator for IterMut<'a> {
    type Item = *mut u8;

    /// Yields the next mapped page's address and size in the mapped span.
    fn next(&mut self) -> Option<Self::Item> {
        if (self.ptr as isize) < (self.acme as isize) {
            let ret = self.ptr;
            self.ptr = self.ptr.wrapping_add(self.page_size as usize);
            Some(ret)
        } else {
            None
        }
    }
}


