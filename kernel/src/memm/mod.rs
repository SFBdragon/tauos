//! Memory management module.

pub mod talloc;
pub mod mapping;

use core::mem;

use amd64::paging::{self, PTE};
use talloc::Talloc;

/// The index to recurse through the PML4T onto itself.
pub const RCRSV_IDX: usize = 0o400;
/// The index to map a PML4 entry onto a different PML4.
pub const GUEST_IDX: usize = 0o401;
/// The index to map physical memory at an offset.
pub const OFFST_IDX: usize = 0o402;
/// The offset of identity-mapped physical memory.
pub const PHYS_LADDR_OFFSET: isize = 0o177777_402_000_000_000_0000usize as isize;


/* BOOTBOOT requires kernel to be mapped between:
    0xffffffffC0000000 -> 0xffffffffffffffff (-1GiB -> -1)
Kernel code model requires symbols to be:
    0xffffffff80000000 -> 0xffffffffff000000 (-2GiB -> -16MiB)

It is chosen that the kernel be mapped from 0xffffffffC0000000 (-256MiB),
plus a 4KiB page, in practice. This is in order to both have more than 
sufficient space (128MiB away from BOOTBOOT mapped data) and yet remain 
within the topmost 1 GiB huge page (along with its stacks below it). */

/// Kernel lower bound mapped virtual address.
pub const KRNL_BOOT_BASE: usize = 0xffffffffC0000000 + paging::PTE_SIZE;

/* On the other hand, without guarantees as to the structure of BOOTBOOT's
page tables, the top GiB is not used for mapping. todo? */

/// Acme of the topmost kernel stack (the bootstrap CPU).
pub const KRNL_STACK_ACME: usize = 0usize.wrapping_sub(paging::PDPTE_SIZE);
/// Size of each kernel process stack, excluding seperation page.
pub const KRNL_STACK_SIZE: usize = 4 * 1024 * 1024 - paging::PTE_SIZE;



macro_rules! handle_alloc_err {
    ($res:expr) => {
        $res.expect("Insufficient physical memory exception!")
    };
}
macro_rules! page_getter {
    ($pmm:expr) => {
        || handle_alloc_err!($pmm.pmem_alloc.alloc(paging::PTE_SIZE))
            .wrapping_sub(PHYS_LADDR_OFFSET as usize) as usize
    };
}

/// todo:
/// - coordinate page table hierarchies
/// - handle mapping
/// - allocate physical memory
pub struct PhysMemMan {
    pub krnl_pml4: *mut [PTE],
    pub mem_size: usize,
    pub pmem_alloc: Talloc,
}

unsafe impl Send for PhysMemMan {}
unsafe impl Sync for PhysMemMan {}

impl PhysMemMan {
    pub unsafe fn setup<F>(active_pml4: *mut [PTE], mmap: &F) -> Self 
    where F: Iterator<Item = (usize, usize)> + Clone {
        use amd64::{registers::CR3, paging::{PTE_SIZE, PDPTE_SIZE}};
        use crate::utils::llist::LlistNode;

        // The goal here is to get the physical memory manager working as quickly
        // as possible, mapping only the bare minimum. Mapping hereafter shall
        // instead make use of the PhysMemMan structure to do so in a clear and
        // reversable way.

        assert!(active_pml4.as_mut_ptr().to_bits() == CR3::read().paddr);
        assert!(active_pml4.len() == 512);

        // set recursive entry
        let rcrsv_entry = PTE::PRESENT | PTE::from_paddr(CR3::read().paddr);
        *active_pml4.get_unchecked_mut(RCRSV_IDX) = rcrsv_entry;
        // wipe low mappings
        for i in 0..0o400 {
            *active_pml4.get_unchecked_mut(i) = PTE::empty();
        }

        // clear the TLB, there aren't likely to be many chached pages and 
        // ensuring the recursive entry isn't incorrectly cached is crucial
        CR3::reload();
        
        // determine memory size and find a large block of memory
        let last_mmap_entry = mmap.clone().last().unwrap();
        let mem_size = last_mmap_entry.0 + last_mmap_entry.1;
        let lgst_blk = mmap.clone().max_by_key(|e| e.1).unwrap();

        // free page-getter, the biggest block should be large enough
        let mut page_getter_offset = lgst_blk.0 + PTE_SIZE-1 & PTE_SIZE-1;
        let mut page_getter = || {
            let o = page_getter_offset;
            page_getter_offset += paging::PTE_SIZE;
            lgst_blk.0 + o
        };

        // map physical memory
        let offst_entry = PTE::PRESENT | PTE::from_paddr(page_getter());
        *active_pml4.get_unchecked_mut(OFFST_IDX) = offst_entry;
        let offst_table = paging::table_of_entry(paging::recur_to_pdpte(
            (OFFST_IDX << paging::PML4_IDX_MASK.trailing_zeros()) as *mut u8,
            RCRSV_IDX,
        ));
        for i in 0..((mem_size + PDPTE_SIZE-1 & PTE_SIZE-1) / PDPTE_SIZE) {
            *offst_table.get_unchecked_mut(i) = PTE::PRESENT | PTE::WRITE
                | PTE::HUGE_PAGE | PTE::from_paddr(i * PDPTE_SIZE);
        }

        // physical memory allocator
        let (llists_len, bitmap_len) = talloc::Talloc::slice_lengths(
            mem_size, 
            PTE_SIZE
        );
        let talloc_slices_ptr = page_getter();
        let slices_bytes = llists_len * mem::size_of::<LlistNode<()>>() + bitmap_len;
        for _ in 0..(slices_bytes / PTE_SIZE) {
            let _ = page_getter(); // waste enough pages to at least cover the slices
        }
        let llists = core::ptr::slice_from_raw_parts_mut(
            talloc_slices_ptr as *mut LlistNode<()>,
            llists_len
        );
        let bitmap = core::ptr::slice_from_raw_parts_mut(
            llists.as_mut_ptr().add(llists.len()) as *mut _,
            bitmap_len
        );
        let mut talloc = talloc::Talloc::new(
            0 as *mut u8,
            mem_size,
            PTE_SIZE,
            llists,
            bitmap,
        );
        for (mut base, size) in mmap.clone() {
            if base == lgst_blk.0 { base += page_getter_offset; }
            talloc.release(talloc.bound_available(base as *mut _, size));
        }

        Self {
            krnl_pml4: active_pml4,
            mem_size,
            pmem_alloc: talloc,
        }
    }

    pub fn map(&mut self, base: *mut u8, size: usize,
    branches: PTE, leaves: PTE, pml4e_idx: usize) -> mapping::Mapping {
        assert!(size != 0);

        // np2_size must be >= smallest_block i.e. PTE_SIZE as well as be a power of two
        let np2_size = (size + paging::PTE_SIZE-1 & !(paging::PTE_SIZE-1)).next_power_of_two();
        let laddr = handle_alloc_err!(unsafe { self.pmem_alloc.alloc(np2_size) });
        let paddr = laddr.wrapping_offset(-PHYS_LADDR_OFFSET) as usize;
        
        unsafe {
            if np2_size >= paging::PDPTE_SIZE {
                let base = ((base as usize) & !(paging::PDPTE_SIZE-1)) as *mut u8;
                let acme = base.add(size + paging::PDPTE_SIZE-1 & !(paging::PDPTE_SIZE-1));
                mapping::map_rcrsv_1gib(
                    base, 
                    acme,
                    paddr,
                    branches,
                    leaves,
                    &mut page_getter!(self),
                    pml4e_idx,
                );
                mapping::Mapping::new(base, acme, paging::PageSize::PDPTE1GiB)
            } else if np2_size >= paging::PDE_SIZE {
                let base = ((base as usize) & !(paging::PDE_SIZE-1)) as *mut u8;
                let acme = base.add(size + paging::PDE_SIZE-1 & !(paging::PDE_SIZE-1));
                mapping::map_rcrsv_2mib(
                    base, 
                    acme,
                    paddr,
                    branches,
                    leaves,
                    &mut page_getter!(self),
                    pml4e_idx,
                );
                mapping::Mapping::new(base, acme, paging::PageSize::PDE2MiB)
            } else {
                let base = ((base as usize) & !(paging::PTE_SIZE-1)) as *mut u8;
                let acme = base.add(size + paging::PTE_SIZE-1 & !(paging::PTE_SIZE-1));
                mapping::map_rcrsv_4kib(
                    base, 
                    acme,
                    paddr,
                    branches,
                    leaves,
                    &mut page_getter!(self),
                    pml4e_idx,
                );
                mapping::Mapping::new(base, acme, paging::PageSize::PTE4KiB)
            }
        }
    }

    // unmap
    // iter/change/+invlpg? conditional?
    // invlpg stuff

}


