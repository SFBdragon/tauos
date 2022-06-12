//! Memory management module.

pub mod talloc;

use core::{marker::PhantomData, ptr};

use amd64::{
    paging::{self, PTE, Pat, PatType},
    registers::{CR0, CR3}
};
use spin::Mutex;
use talloc::Talloc;

use crate::utils;

/* /// The index to recurse through the PML4T onto itself.
pub const RCRSV_IDX: usize = 0o400;
/// The index to map a PML4 entry onto a different PML4.
pub const GUEST_IDX: usize = 0o401; */
/// The index to map physical memory at an offset.
pub const OFFSET_IDX: usize = 0o400;
/// The offset of identity-mapped physical memory.
pub const PHYS_LADDR_OFFSET: isize = -0o400_000_000_000_0000;

#[macro_export]
macro_rules! from_phys_addr {
    ($paddr:expr, $t:ty) => {
        ($paddr as isize + crate::memm::PHYS_LADDR_OFFSET) as *mut $t 
    };
}
#[macro_export]
macro_rules! to_phys_addr {
    ($laddr:expr) => {
        ($laddr as isize - crate::memm::PHYS_LADDR_OFFSET) as usize
    };
}


/* BOOTBOOT requires kernel to be mapped between:
    0xffffffffC0000000 -> 0xffffffffffffffff (-1GiB -> -1)
Kernel code model requires symbols to be:
    0xffffffff80000000 -> 0xffffffffff000000 (-2GiB -> -16MiB)

It is chosen that the kernel be mapped from 0xffffffffC0000000 (-256MiB),
plus a 4KiB page, in practice. This is in order to both have more than 
sufficient space (128MiB away from BOOTBOOT mapped data) and yet remain 
within the topmost 1 GiB huge page (along with its stacks below it). */

/// Kernel lower bound mapped virtual address.
pub const KRNL_BOOT_BASE: usize = 0usize.wrapping_sub(paging::PDPTE_SIZE);


/// Acme of the topmost kernel stack (the bootstrap CPU).
pub const KRNL_STACK_ACME: usize = 0usize.wrapping_sub(paging::PDPTE_SIZE);
/// Size of each kernel process stack, excluding seperation page.
pub const KRNL_STACK_SIZE: usize = 4 * 1024 * 1024 - paging::PTE_SIZE;


/// Default PAT used. The table is as follows:
/// * \[0\] None            - Write-back
/// * \[1\] PWT             - Write-through
/// * \[2\] PCD             - Uncacheable-minus
/// * \[3\] PCD | PWT       - Uncacheable
/// * \[4\] PAT             - Write-combining
/// * \[5\] PAT | PWT       - Write-protect
/// * \[6\] PAT | PCD       - Reserved
/// * \[7\] PAT | PCD | PWT - Reserved
/// 
/// PAT types are defined as per the AMD64 Programmer's Manual.
pub const KRNL_DEFAULT_PAT: Pat = Pat {
    std_types: [
        PatType::WriteBack,
        PatType::WriteThrough,
        PatType::UncacheableMinus,
        PatType::Uncacheable,
    ],
    pat_types: [
        PatType::WriteCombining,
        PatType::WriteProtect,
        PatType::UncacheableMinus, // reserved
        PatType::UncacheableMinus, // reserved
    ],
};
/// Get the PTE flags (PAT, PAT_PS, PWT, PCD) for the given `PatType` when
/// `KRNL_DEFAULT_PAT` is the active PAT.
pub const fn pat_type_to_pte(pat_type: PatType, is_hpage: bool) -> PTE {
    let idx = match pat_type {
        PatType::Uncacheable => 3,
        PatType::WriteCombining => 4,
        PatType::WriteThrough => 1,
        PatType::WriteProtect => 5,
        PatType::WriteBack => 0,
        PatType::UncacheableMinus => 2,
    };
    PTE::from_pat(idx, is_hpage)
}



pub static MAPPER: Mutex<Mapper> = Mutex::new(unsafe { Mapper::new_invalid() });
fn mapper_oom_handler(_: &mut Talloc, _: core::alloc::Layout)
-> Result<(), core::alloc::AllocError> {
    Err(core::alloc::AllocError)
}



/// Maps `base` through `acme` to physical memory.
/// # Safety:
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * Physical addresses of the page tables must be offset-identity mapped.
/// * `table` must fully contain the virtual span of memory.
/// * `page_getter` should return sufficient valid pages for necessary physical pages
/// and page table pages with the size as specified (either 4KiB, 2MiB, or 1GiB).
/// * The specified `PTE`s must be valid and usable, and not contain an address.
pub unsafe fn map_offset<const LVL: usize, F>(mut base: *mut u8, acme: *mut u8,
branches: PTE, leaves: PTE, table: *mut [PTE], page_getter: &mut F)
where F: FnMut(usize) -> usize {
    use paging::{PML4_LVL, PDPT_LVL, PD_LVL, PT_LVL};

    if LVL < PT_LVL || LVL > PML4_LVL { panic!("INVALID PAGE TABLE LVL") }

    // loop across the entries
    while (base as isize) < (acme as isize) {
        let table_index = paging::table_index(base, LVL);
        let pte = table.get_unchecked_mut(table_index);
        let page_size = paging::page_size(LVL);
        let ps_aligned = base as usize & page_size - 1 == 0;
        let remaining = (acme as isize - base as isize) as usize + paging::PTE_SIZE - 1;

        /* crate::println!("{:p} {:#x?} {:p} {:p}", base, acme, table, PHYS_LADDR_OFFSET as *mut u8);
        crate::println!("{:?} {:p} {:#x?} {:?} {:#x?}", table_index, pte, page_size, ps_aligned, remaining); */

        if LVL == PT_LVL || remaining >= page_size && ps_aligned && LVL < 4 {
            // create leaf entry, mapping physical to virtual memory
            let mut entry = PTE::P | PTE::from_paddr(page_getter(page_size)) | leaves;
            if LVL != PT_LVL {
                // determine whether PAT/PS is set, configure accordingly
                if entry.contains(PTE::PAT) {
                    entry |= PTE::PAT_PS;
                } else {
                    entry |= PTE::PS;
                }
            }
            *pte = entry;
        } else {
            // create and navigate a branch
            // allocate new page table if none exists
            if !(*pte).contains(PTE::P) {
                let page = page_getter(paging::PTE_SIZE);
                // SAFETY: guaranteed by caller
                crate::from_phys_addr!(page, PTE).write_bytes(0, 512);
                *pte = PTE::P | PTE::from_paddr(page as usize) | branches;
            }
            
            let lower_table = core::ptr::slice_from_raw_parts_mut(
                crate::from_phys_addr!((*pte).get_paddr(), PTE), 
                512
            );

            // navigate down the page table tree
            // FIXME: Use `{LVL - 1}` when const generics have better support?
            match LVL {
                PML4_LVL => map_offset::<PDPT_LVL, F>(base, acme,
                    branches, leaves, lower_table, page_getter),
                PDPT_LVL => map_offset::<PD_LVL, F>(base, acme, 
                    branches, leaves, lower_table, page_getter),
                PD_LVL => map_offset::<PT_LVL, F>(base, acme, 
                    branches, leaves, lower_table, page_getter),
                // SAFETY: this possiblity is checked for 
                _ => core::hint::unreachable_unchecked(),
            }
        }
        base = base.wrapping_add(page_size);

        if table_index == 511 { break; }
    }
}

/// Maps `base` through `acme` to the physical address of base `paddr`.
/// # Safety:
/// * Any existing mappings within the span of virtual addresses will be remapped.
/// * Physical addresses of the page tables must be offset-identity mapped.
/// * `table` must fully contain the virtual span of memory.
/// * `page_getter` should return sufficient valid page table pages as necessary.
/// * The specified `PTE`s must be valid and usable, and not contain an address.
pub unsafe fn map_offset_at<const LVL: usize, F>(mut base: *mut u8, acme: *mut u8,
mut paddr: usize, branches: PTE, leaves: PTE, table: *mut [PTE], page_getter: &mut F)
where F: FnMut() -> usize {
    use paging::{PML4_LVL, PDPT_LVL, PD_LVL, PT_LVL};

    assert!(LVL < PT_LVL || LVL > PML4_LVL);

    // loop across the entries
    while (base as isize) < (acme as isize) {
        let table_index = paging::table_index(base, LVL);
        let pte = table.get_unchecked_mut(table_index);
        let page_size = paging::page_size(LVL);
        let ps_aligned = (base as usize | paddr) & page_size - 1 == 0;
        let remaining = (acme as isize - base as isize) as usize + paging::PTE_SIZE - 1;

        if LVL == PT_LVL || remaining >= page_size && ps_aligned && LVL < 4 {
            // create leaf entry, mapping physical to virtual memory
            let mut entry = PTE::P | PTE::from_paddr(paddr) | leaves;
            if LVL != PT_LVL {
                // determine whether PAT/PS is set, configure accordingly
                if entry.contains(PTE::PAT) {
                    entry |= PTE::PAT_PS;
                } else {
                    entry |= PTE::PS;
                }
            }
            *pte = entry;
        } else {
            // create and navigate a branch
            // allocate new page table if none exists
            if !(*pte).contains(PTE::P) {
                let page = page_getter();
                // SAFETY: guaranteed by caller
                crate::from_phys_addr!(page, PTE).write_bytes(0, 512);
                *pte = PTE::P | PTE::from_paddr(page) | branches;
            }
            
            let lower_table = core::ptr::slice_from_raw_parts_mut(
                crate::from_phys_addr!((*pte).get_paddr(), PTE), 
                512
            );

            // navigate down the page table tree
            // FIXME: Use `{LVL - 1}` when const generics have better support.
            match LVL {
                PML4_LVL => map_offset_at::<PDPT_LVL, F>(base, acme, paddr, 
                    branches, leaves, lower_table, page_getter),
                PDPT_LVL => map_offset_at::<PD_LVL, F>(base, acme, paddr, 
                    branches, leaves, lower_table, page_getter),
                PD_LVL => map_offset_at::<PT_LVL, F>(base, acme, paddr, 
                    branches, leaves, lower_table, page_getter),
                // SAFETY: this possiblity is checked for 
                _ => core::hint::unreachable_unchecked(),
            }
        }
        base = base.wrapping_add(page_size);
        paddr += page_size;

        if table_index == 511 { break; }
    }
}

/// Returns the page table entry that translates `laddr` at `lvl`.
/// 
/// Use `paging::table_of_entry` on the result to get the corresponding table.
/// ### Safety:
/// * Physical addresses of the page tables must be offset-identity mapped.
/// * `pml4` must map laddr to the given `lvl` (i.e. a full mapping is not required).
pub unsafe fn get_entry_offset(laddr: *mut u8, lvl: usize, pml4: *mut [PTE]) -> *mut PTE {
    let mut entry_ptr = pml4.as_mut_ptr();
    let mut lvl_idx = 4;
    while lvl_idx > lvl {
        let pte = *entry_ptr.wrapping_add(paging::table_index(entry_ptr, lvl_idx));
        crate::println!("pte {:?}", pte);
        entry_ptr = from_phys_addr!(pte.get_paddr(), PTE);
        lvl_idx -= 1;
    }
    entry_ptr.wrapping_add(paging::table_index(laddr, lvl_idx))
}




/// todo:
/// - coordinate page table hierarchies
/// - handle mapping
/// - allocate physical memory
pub struct Mapper {
    pub krnl_pml4: usize,
    //pub mem_size: usize,
    pub talloc: Talloc,
}

impl Mapper {
    const unsafe fn new_invalid() -> Self {
        Self {
            krnl_pml4: 0,
            /*  mem_size: 0, */
            talloc: Talloc::new_invalid(paging::PTE_SIZE, mapper_oom_handler)
        }
    }

    // todo: document Mapper functions properly
    /// Takes control of paging, sets up offset-identity paging, sets up `MAPPER`, etc.
    /// 
    /// Returns: new pml4 paddr
    /// 
    /// Safety: ident map
    pub unsafe fn setup<F: Iterator<Item = (usize, usize)> + Clone>(mmap: &F) -> usize {
        use amd64::paging::{PTE_SIZE, PDPTE_SIZE};

        // The goal here is to get the physical memory manager working as quickly
        // as possible, mapping only the bare minimum. Mapping hereafter shall
        // instead make use of the PhysMemMan structure to do so in a clear and
        // reversable way.
        // Assumes identity mapping. Guaranteed by caller.

        // disable write-protection in case the existing tables are protected
        CR0::write(CR0::read() & !CR0::WP);

        // determine mem size
        //let mem_size_free = mmap.clone().fold(0, |acc, (_, size)| acc + size);

        // find a large block of memory and highest physical addresses
        let hi_phys_addr = mmap.clone().last().map(|e| e.0 + e.1).unwrap();
        let lgst_blk = mmap.clone().max_by_key(|e| e.1).unwrap();
        // available page getter - the biggest block should be large enough
        let mut page_getter_offset = lgst_blk.0 + PTE_SIZE-1 & !(PTE_SIZE-1);
        let mut page_getter = || {
            let o = page_getter_offset;
            page_getter_offset += paging::PTE_SIZE;
            lgst_blk.0 + o
        };
        
        // ----- Initialise new mappings ----- //

        // create new PML4 and last PDPT
        let pml4 = ptr::slice_from_raw_parts_mut(
            page_getter() as *mut PTE, 
            512
        );
        pml4.as_mut_ptr().write_bytes(0, 512);

        let last_pdpt_paddr = page_getter();
        let last_pdpt = ptr::slice_from_raw_parts_mut(
            last_pdpt_paddr as *mut PTE, 
            512
        );
        last_pdpt.as_mut_ptr().write_bytes(0, 512);
        let last_pml4_entry = PTE::P | PTE::RW | PTE::from_paddr(last_pdpt_paddr);
        *pml4.get_unchecked_mut(511) = last_pml4_entry;

        // grab the active PML4
        let old_pml4 = ptr::slice_from_raw_parts_mut(
            CR3::read().paddr as *mut PTE, 
            512
        );

        // ----- Handle existing mappings ----- //
        if true { // if BOOTBOOT
            // BOOTBOOT does not provide any information regarding the mappings
            // it makes, although they will always be made above -1GiB.
            // Accordingly, these mappings are preserved for now as-is.

            let last_old_pd = (*((*old_pml4
                // read 511th entry
                .get_unchecked_mut(511))
                // read pdpt addr
                .get_paddr() as *mut PTE)
                // get 511th entry
                .add(511))
                // read pd addr
                .get_paddr();
            
            let last_pdpt_entry = PTE::P | PTE::RW | PTE::from_paddr(last_old_pd);
            *last_pdpt.get_unchecked_mut(511) = last_pdpt_entry;
        }


        // ----- Map physical memory at the offset, up to 512GiB ----- //
        let offset_pdpt_paddr = page_getter();
        let offset_pdpt_entry = PTE::P | PTE::RW | PTE::from_paddr(offset_pdpt_paddr);
        *pml4.get_unchecked_mut(OFFSET_IDX) = offset_pdpt_entry;
        let offset_map_table = core::ptr::slice_from_raw_parts_mut(
            offset_pdpt_paddr as *mut PTE,
            512,
        );
        for i in 0..512 {
            if i < (hi_phys_addr + PDPTE_SIZE-1) / PDPTE_SIZE {
                let entry = PTE::P | PTE::RW | PTE::PS | PTE::from_paddr(i*PDPTE_SIZE);
                *offset_map_table.get_unchecked_mut(i) = entry;
            } else {
                *offset_map_table.get_unchecked_mut(i) = PTE::empty();
            }
        }

        // ----- Set new PML4 as active ----- //
        CR3::set_nflags(pml4.as_mut_ptr() as usize);

        // Done modifying page tables for now;
        // Set WP to ensure against bugs and whatnot
        CR0::write(CR0::read() | CR0::WP);

        // ----- Setup physical memory allocator ----- //

        let free_mem = ptr::slice_from_raw_parts_mut(
            from_phys_addr!(lgst_blk.0 + page_getter_offset, u8),
            lgst_blk.1 - page_getter_offset
        );
        let mut talloc = talloc::Talloc::new(
            from_phys_addr!(PTE_SIZE, u8) as isize,
            hi_phys_addr,
            PTE_SIZE,
            free_mem,
            mapper_oom_handler,
        );

        for (base, size) in mmap.clone() {
            if base == lgst_blk.0 { continue; }
            talloc.release(ptr::slice_from_raw_parts_mut(from_phys_addr!(base, u8), size));
        }

        // set MAPPER
        *MAPPER.lock() = Self { krnl_pml4: CR3::read().paddr, talloc };

        // return the pml4 paddr
        CR3::read().paddr
    }

    /// ### Safety:
    /// Size must be nonzero.
    unsafe fn alloc_phys(&mut self, size: usize) -> usize {
        to_phys_addr!(
            self.talloc.alloc(core::alloc::Layout::from_size_align_unchecked(size, size))
                // todo: handle more gracefully?
                .expect("Out of physical memory exception!")
                .as_ptr()
        )
    }

    /// Maps base through acme to avaialable physical memory.
    /// ### Safety:
    /// * Any existing mappings within the span of virtual addresses will be remapped.
    /// * The specified PTEs must be valid and usable, and not contain an address.
    pub unsafe fn map(&mut self, base: *mut u8, size: usize,
    branches: PTE, leaves: PTE, pml4: *mut [PTE]) -> Mapping {
        assert!(size != 0);

        let base = ((base as usize) & !(paging::PTE_SIZE-1)) as *mut u8;
        let acme = base.wrapping_add(size + paging::PTE_SIZE-1 & !(paging::PTE_SIZE-1));

        //crate::println!("{:p} {:#x} {:p}", base, size, pml4);
        
        map_offset::<4, _>(
            base, acme,
            branches, leaves,
            pml4,
            &mut |size: usize| self.alloc_phys(size)
        );

        Mapping { base, acme, pml4 }
    }

    // todo:
    // invlpg stuff
    // unmap/configure convenience funcs?
}



/// Description of a contiguous, mapped region of virtual memory.
#[derive(Debug)]
pub struct Mapping {
    base: *mut u8,
    acme: *mut u8,
    pml4: *mut [PTE],
}
impl Mapping {
    pub unsafe fn new(base: *mut u8, acme: *mut u8, pml4: *mut [PTE]) -> Self {
        Mapping { base, acme, pml4 }
    }
    /// Get an iterator over addresses mapped by this mapping. 
    /// 
    /// Yeilds `(address, page table level)` in increasing order.
    /// ### Safety:
    /// * Physical addresses of the page tables must be offset-identity mapped.
    /// * Returned `address`es are not safe to dereference if the same pml4
    /// is not active.
    pub fn iter_pages<'a>(&'a self) -> IterMut<'a> {
        IterMut::new(self)
    }

    /// Get an iterator over the addresses mapped by this mapping.
    /// 
    /// Yeilds `(address, page table level, mapping entry)` in increasing order.
    /// ### Safety:
    /// * Physical addresses of the page tables must be offset-identity mapped.
    /// * Returned `address`es are not safe to dereference if the same pml4
    /// is not active.
    pub fn iter_entries<'a>(&'a self)
    -> impl 'a + Iterator<Item = (*mut u8, usize, *mut PTE)> {
        IterMut::new(self).map(|(laddr, lvl)| (
            laddr,
            lvl,
            unsafe { get_entry_offset(laddr, lvl, self.pml4) }
        ))
    }
}

/// Immutable mapping iterator.
/// 
/// This struct is created by `iter` method on `Mapping`s.
#[derive(Debug)]
pub struct IterMut<'a> {
    ptr: *mut u8,
    acme: *mut u8,
    _phantom: PhantomData<&'a Mapping>
}
impl<'a> IterMut<'a> {
    fn new(mapping: &'a Mapping) -> Self {
        Self { 
            ptr: mapping.base,
            acme: mapping.acme,
            _phantom: PhantomData,
        }
    }
}
impl<'a> Iterator for IterMut<'a> {
    type Item = (*mut u8, usize);

    /// Yields the next mapped page's address and size in the mapped span.
    fn next(&mut self) -> Option<Self::Item> {
        let ptr = self.ptr;
        if (ptr as isize) < (self.acme as isize) {
            // calculate the appropriate entry size level
            // from both the remaining size and align
            let remaining = unsafe { utils::fast_non0_log2(
                ((self.acme as isize) - (ptr as isize)) as usize
            ) };
            let align = ptr.to_bits().leading_zeros() as usize;

            // use the smallest of the two levels to determine page size
            let lvl = (core::cmp::min(remaining, align) - 3) / 9;
            let page_size = paging::page_size(lvl);
            
            self.ptr = ptr.wrapping_add(page_size);
            Some((ptr, lvl))
        } else {
            None
        }
    }
}

