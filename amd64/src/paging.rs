
pub const PT_IDX_MASK: isize   = 0o000000_000_000_000_777_0000;
pub const PD_IDX_MASK: isize   = 0o000000_000_000_777_000_0000;
pub const PDPT_IDX_MASK: isize = 0o000000_000_777_000_000_0000;
pub const PML4_IDX_MASK: isize = 0o000000_777_000_000_000_0000;

/// The address below which linear addresses in the subset of 
/// the 64-bit address space scheme are canonical.
pub const LOWER_HALF: isize  = 0o000000_400_000_000_000_0000;
/// The address at and above which linear addresses in the 48-bit subset of 
/// the 64-bit address space are canonical.
pub const HIGHER_HALF: isize = -LOWER_HALF;


/// 4 KiB: Page Table entry mapped size.
pub const PTE_SIZE: usize   = 0x1000;
/// 2 MiB: Page Directory entry mapped size.
pub const PDE_SIZE: usize   = 0x200000;
/// 1 GiB: Page Directory Pointer Table entry mapped size.
pub const PDPTE_SIZE: usize = 0x40000000;
/// 512 GiB: Page Map Level 4 entry mapped size.
pub const PML4E_SIZE: usize = 0x8000000000;

/// Sizes of long-mode pages in bytes.
#[repr(usize)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum PageSize {
    PTE4KiB   = PTE_SIZE,
    PDE2MiB   = PDE_SIZE,
    PDPTE1GiB = PDPTE_SIZE,
}


pub const PT_LEVEL: usize = 1;
pub const PD_LEVEL: usize = 2;
pub const PDPT_LEVEL: usize = 3;
pub const PML4_LEVEL: usize = 4;

bitflags::bitflags! {
    /// Page Table Entry flags. 
    /// Generic over all long mode page tables, see flag documentation for details.
    pub struct PTE: usize {
        /// P: When set, determines that the physical page base specified is 
        /// loaded in physical memory. When clear, the rest of the entry becomes 
        /// available for software use.
        const PRESENT = 1 << 0;

        /// R/W: When set, allows write and read permissions, else readonly. 
        /// Does not cascade.
        const WRITE = 1 << 1;
        /// U/S: When set, allows user (CPL3) access, else access is supervisor 
        /// only (CPL 0,1,2). Does not cascade.
        const USERLAND = 1 << 2;
        /// PWT: When set, a writethrough policy is employed instead of writeback 
        /// for the physical page/page-translation table.
        const PAGE_WRITE_THROUGH = 1 << 3;
        /// PCD: When set, caching is disabled for the physical 
        /// page/page-translation table.
        const PAGE_CACHE_DISABLE = 1 << 4;

        /// A: When set, the CPU has accessed the physical 
        /// page/page-translation table.
        const ACCESSED = 1 << 5;
        /// D: When a leaf table, and set, indicates the CPU has written to 
        /// the physical page/page-translation table.
        /// 
        /// Ignored for branch tables.
        const DIRTY = 1 << 6;


        /// PS: When not a Page Table (level 1) entry, when set, indicates that 
        /// this maps a large page directly, else references an address 
        /// translation page table.
        const HUGE_PAGE = 1 << 7;
        /// PAT: When a Page Table (level 1) entry, determines the high-order 
        /// bit of a 3-bit index into the PAT register.
        /// 
        /// Not supported by all processors.
        const PAT = 1 << 7;
        
        /// When set, and `CR4::PGE` is set (else is reserved), determines that 
        /// that the TLB entry for a global page is not invalidated when CR3 is 
        /// loaded either explicitly by a MOV CRn instruction or implicitly 
        /// during a task switch.
        const GLOBAL = 1 << 8;

        /// Bits available for use.
        const AVAILABLE_MASK_0 = 0o7000;

        
        /// When not a Page Table (level 1) entry, and `PTE::HUGE_PAGE` is set,
        /// determines the high-order bit of a 3-bit index into the PAT register.
        /// Not supported by all processors.
        const PAT_PS = 1 << 12;

        /// If page table is a leaf, i.e. `PTE::HUGE_PAGE` is set or this is a PTE,
        /// defines the physical address of the mapped page.
        /// 
        /// Alignment is determined by page table level, and the rest of the 
        /// bits are inferred to be zero:
        /// * Leaf PTE: 4KiB mapped page alignment, 12 bits inferred to be zero.
        /// * Leaf PDE (`PTE::HUGE_PAGE`): 2MiB mapped page alignment, 21 bits 
        /// inferred to be zero.
        /// * Leaf PDPE (`PTE::HUGE_PAGE`): 1GiB mapped page alignment, 30 bits 
        /// inferred to be zero.
        /// 
        /// If page is a branch, i.e. `Self::PAT_PAGE_SIZE` is clear and this is 
        /// not a PTE, defines the phyical address of a page table. Alignment is 4KiB.
        /// 
        /// The 52-bit address size limit is architecture defined for AMD64, 
        /// in long mode (`CR4::PAE` is set), but may be less depending on implementation.
        const BASE_MASK           = 0o000017_777_777_777_777_0000;

        /// Bits available for use.
        const AVAILABLE_MASK_1    = 0o003760_000_000_000_000_0000;

        /// When `CR4::PKE` is set, and table is a leaf, determines the protection 
        /// key used for the mapped page.
        /// Available when `CR4::PKE` is clear, or when this table is not a leaf.
        const PROTECTION_KEY_MASK = 0o074000_000_000_000_000_0000;

        /// When set, and `EFER::NXE` is set (else is reserved), determines that 
        /// instruction fetches are not allowed to occur within the 
        /// directly/indirectly mapped page/s.
        const NO_EXECUTE = 1 << 63;
    }
}

impl PTE {
    /// # Panics
    /// Panics if paddr is not page-aligned or is too large for AMD64 architecture.
    #[inline]
    pub const fn from_paddr(paddr: usize) -> PTE {
        assert!(paddr & !PTE::BASE_MASK.bits == 0, 
            "addr is not page-aligned or is too large for AMD64 architecture");

        unsafe {
            PTE::from_bits_unchecked(paddr)
        }
    }

    #[inline]
    pub const fn get_paddr(&self) -> usize {
        self.bits & PTE::BASE_MASK.bits
    }
}


// GENERAL PAGE TABLE UTILS

/// Return the size of the virtual memory that a given page table entry spans, 
/// where a PDPT entry is `level` 3, a PDT is entry `level` 2, and so on.
#[inline]
pub const fn page_size(lvl: usize) -> usize {
    (lvl - 1) * 0o1000 * 0o10000
}

/// Extract the index into the given level of page table, where the index into 
/// the PML4T is `level` 4, the index into the PDPT is `level` 3, and so on.
#[inline]
pub fn table_index<T>(laddr: *mut T, lvl: usize) -> usize {
    ((laddr as isize >> lvl * 9 + 3) & 0o777) as usize
}

/// The returned linear address will address into a guest page table hierarchy.
/// 
/// Note that `laddr` is expected to be recursive to some degree.
#[inline]
pub fn set_pml4_idx<T>(laddr: *mut T, guest_idx: usize) -> *mut T {
    (laddr as isize
    & !PML4_IDX_MASK
    | ((guest_idx as isize)
        << PML4_IDX_MASK.trailing_zeros()
        & PML4_IDX_MASK
    )) as *mut _
}


// RECURSIVE PAGE TABLE UTILS

/// Returns the linear address of the Page Table entry `laddr` is translated by.
#[inline]
pub fn recur_to_pte<T>(laddr: *mut T, rcrsv_idx: usize) -> *mut PTE {
    // The rust compiler, given a const rcrsv_idx, compiles recursive 
    // calls to this function into about 4 instructions.

    // Shift the linear address down such that the address indexes the page 
    // tables after the pml4 recursion.
    (laddr as isize >> 9 
    // Mask out the sign extention, PML4 index, and lower 3 bits
    & !(HIGHER_HALF | PML4_IDX_MASK | 7) 
    // OR in the sign extended recursive entry index 
    | ((rcrsv_idx << 55) as isize >> 16)) as *mut _
}
/// Returns the linear address of the Page Directory entry `laddr` is translated by.
#[inline]
pub fn recur_to_pde<T>(laddr: *mut T, rcrsv_idx: usize) -> *mut PTE {
    recur_to_pte(recur_to_pte(laddr, rcrsv_idx), rcrsv_idx)
}
/// Returns the linear address of the PDPT entry `laddr` is translated by.
#[inline]
pub fn recur_to_pdpte<T>(laddr: *mut T, rcrsv_idx: usize) -> *mut PTE {
    recur_to_pde(recur_to_pte(laddr, rcrsv_idx), rcrsv_idx)
}
/// Returns the linear address of the PML4 entry `laddr` is translated by.
#[inline]
pub fn recur_to_pml4e<T>(laddr: *mut T, rcrsv_idx: usize) -> *mut PTE {
    recur_to_pdpte(recur_to_pte(laddr, rcrsv_idx), rcrsv_idx)
}

/// Returns the page table containing the given entry.
#[inline]
pub fn table_of_entry(laddr: *mut PTE) -> *mut [PTE] {
    core::ptr::slice_from_raw_parts_mut(
        <*mut PTE>::from_bits(laddr.to_bits() & !0o7777), 
        512
    )
}

