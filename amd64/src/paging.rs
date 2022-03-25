
/// 4 KiB
pub const PAGE_TABLE_SIZE: u64   = 0x1000;
/// 4 KiB
pub const PTE_MAPPED_SIZE: u64   = 0x1000;
/// 2 MiB
pub const PDE_MAPPED_SIZE: u64   = 0x200000;
/// 1 GiB
pub const PDPE_MAPPED_SIZE: u64  = 0x40000000;
/// 512 GiB
pub const PML4E_MAPPED_SIZE: u64 = 0x8000000000;

pub const PT_LADDR_INDEX_MASK: u64    = 0o000000_000_000_000_777_0000;
pub const PDT_LADDR_INDEX_MASK: u64   = 0o000000_000_000_777_000_0000;
pub const PDPT_LADDR_INDEX_MASK: u64  = 0o000000_000_777_000_000_0000;
pub const PML4T_LADDR_INDEX_MASK: u64 = 0o000000_777_000_000_000_0000;

pub const CANONICAL_LOWER_HALF: u64   = 0o000000_377_777_777_777_7777; // 0x0000_7FFF_FFFF_FFFF;
pub const CANONICAL_HIGHER_HALF: u64  = 0o177777_400_000_000_000_0000;// 0xFFFF_8000_0000_0000;

/// Extract and align the index of a Page Table for a given linear address.
#[inline]
pub const fn pt_index(laddr: u64) -> usize {
    ((laddr & PT_LADDR_INDEX_MASK) >> PT_LADDR_INDEX_MASK.trailing_zeros()) as usize
}
/// Extract and align the index of a Page Directory Table for a given linear address.
#[inline]
pub const fn pdt_index(laddr: u64) -> usize {
    ((laddr & PDT_LADDR_INDEX_MASK) >> PDT_LADDR_INDEX_MASK.trailing_zeros()) as usize
}
/// Extract and align the index of a Page Directory Pointer Table for a given linear address.
#[inline]
pub const fn pdpt_index(laddr: u64) -> usize {
    ((laddr & PDPT_LADDR_INDEX_MASK) >> PDPT_LADDR_INDEX_MASK.trailing_zeros()) as usize
}
/// Extract and align the index of a Page Map Level 4 Table for a given linear address.
#[inline]
pub const fn pml4t_index(laddr: u64) -> usize {
    ((laddr & PML4T_LADDR_INDEX_MASK) >> PML4T_LADDR_INDEX_MASK.trailing_zeros()) as usize
}


bitflags::bitflags! {
    /// Page Table Entry flags. Generic over all long mode table types, see individual flag/mask docs for situational details.
    pub struct PTE: u64 {
        /// P: When set, determines that the physical page base specified is loaded in physical memory.
        /// When clear, the rest of the entry becomes available for software use.
        const PRESENT = 1 << 0;

        /// R/W: When set, allows write and read permissions, else readonly. Does not cascade.
        const WRITE = 1 << 1;
        /// U/S: When set, allows user (CPL3) access, else access is supervisor only (CPL 0,1,2). Does not cascade.
        const USERLAND = 1 << 2;
        /// PWT: When set, a writethrough policy is employed instead of writeback for the physical page/page-translation table.
        const PAGE_WRITE_THROUGH = 1 << 3;
        /// PCD: When set, caching is disabled for the physical page/page-translation table.
        const PAGE_CACHE_DISABLE = 1 << 4;

        /// A: When set, the CPU has accessed the physical page/page-translation table.
        const ACCESSED = 1 << 5;
        /// D: When a leaf table, and set, indicates the CPU has written to the physical page/page-translation table.
        /// 
        /// Ignored for branch tables.
        const DIRTY = 1 << 6;


        /// PS: When not a Page Table (level 1) entry, when set, indicates that this maps a large page directly, 
        /// else references an address translation page table.
        const HUGE_PAGE = 1 << 7;
        /// PAT: When a Page Table (level 1) entry, determines the high-order bit of a 3-bit index into the PAT register.
        /// 
        /// Not supported by all processors.
        const PAT = 1 << 7;
        
        /// When set, and `CR4::PGE` is set (else is reserved), determines that that the TLB entry for a global page is not invalidated 
        /// when CR3 is loaded either explicitly by a MOV CRn instruction or implicitly during a task switch.
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
        /// Alignment is determined by page table level, and the rest of the bits are inferred to be zero:
        /// * Leaf PTE: 4KiB mapped page alignment, 12 bits inferred to be zero.
        /// * Leaf PDE (`PTE::HUGE_PAGE`): 2MiB mapped page alignment, 21 bits inferred to be zero.
        /// * Leaf PDPE (`PTE::HUGE_PAGE`): 1GiB mapped page alignment, 30 bits inferred to be zero.
        /// 
        /// If page is a branch, i.e. `Self::PAT_PAGE_SIZE` is clear and this is not a PTE,
        /// defines the phyical address of a page table. Alignment is 4KiB.
        /// 
        /// The 52-bit address size limit is architecture defined for AMD64, 
        /// in long mode (`CR4::PAE` is set), but may be less depending on implementation.
        const BASE_MASK           = 0o000017_777_777_777_777_0000;

        /// Bits available for use.
        const AVAILABLE_MASK_1    = 0o003760_000_000_000_000_0000;

        /// When `CR4::PKE` is set, and table is a leaf, determines the protection key used for the mapped page.
        /// Available when `CR4::PKE` is clear, or when this table is not a leaf.
        const PROTECTION_KEY_MASK = 0o074000_000_000_000_000_0000;

        /// When set, and `EFER::NXE` is set (else is reserved), determines that instruction 
        /// fetches are not allowed to occur within the directly/indirectly mapped page/s.
        const NO_EXECUTE = 1 << 63;
    }
}

impl PTE {
    /// # Panics
    /// Panics if paddr is not page-aligned or is too large for AMD64 architecture.
    #[inline]
    pub const fn from_paddr(paddr: u64) -> PTE {
        assert!(paddr & !PTE::BASE_MASK.bits == 0, 
            "addr is not page-aligned or is too large for AMD64 architecture");

        unsafe {
            PTE::from_bits_unchecked(paddr)
        }
    }

    #[inline]
    pub const fn get_paddr(&self) -> u64 {
        self.bits & PTE::BASE_MASK.bits
    }
}


// RECURSIVE PAGE TABLE UTILS

/// The returned linear address will address the page table entry that defines the physical page
/// address base that the provided linear address page table indexes are tranlated into.
#[inline]
pub const fn recur_to_pte(laddr: u64, recursive_index: u64) -> u64 {
    // shift the linear address down such that the address indexes the page tables as expected after the pml4t recursion
    // mask out the sign extention, PML4T index, and lower 3 bits, OR in the recursive entry index (sign extended)
    // the rust compiler, given a const recursive_index, compiles recursive calls to this function into about 4 instructions
    laddr >> 9 & !(CANONICAL_HIGHER_HALF | PML4T_LADDR_INDEX_MASK | 7) | ((recursive_index << 55) as i64 >> 16) as u64
}

/// The returned linear address will address the page table entry that defines the page table base 
/// that would further translate the linear address.
#[inline]
pub const fn recur_to_pde(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(recur_to_pte(laddr, recursive_index), recursive_index)
}
/// The returned linear address will address the page table entry that defines the huge physical page
/// address base that the provided linear address page table indexes are tranlated into.
#[inline]
pub const fn recur_to_hpde(laddr: u64, recursive_index: u64) -> u64 {
    laddr >> 18 & !(CANONICAL_HIGHER_HALF | PML4T_LADDR_INDEX_MASK | PDPT_LADDR_INDEX_MASK | 7) 
        | ((recursive_index << 55) as i64 >> 16) as u64 | recursive_index << 30
}

/// The returned linear address will address the page table entry that defines the page directory 
/// table base that would further translate the linear address.
#[inline]
pub const fn recur_to_pdpe(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(
        recur_to_pte(
            recur_to_pte(laddr, 
            recursive_index), 
        recursive_index), 
    recursive_index)
}

/// The returned linear address will address the page table entry that defines the page directory 
/// table base that would further translate the linear address to a huge page directory page entry.
#[inline]
pub const fn recur_to_hpde_pdpe(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(
        recur_to_hpde(laddr, recursive_index), 
    recursive_index)
}
/// The returned linear address will address the page table entry that defines the huge physical page
/// address base that the provided linear address page table indexes are tranlated into.
#[inline]
pub const fn recur_to_hpdpe(laddr: u64, recursive_index: u64) -> u64 {
    laddr >> 27 & !(CANONICAL_HIGHER_HALF | PML4T_LADDR_INDEX_MASK | PDPT_LADDR_INDEX_MASK | PDT_LADDR_INDEX_MASK | 7) 
        | ((recursive_index << 55) as i64 >> 16) as u64 | recursive_index << 30 | recursive_index << 21
}

/// The returned linear address will address the page table entry that defines the page directory 
/// pointer table base that would further translate the linear address.
#[inline]
pub const fn recur_to_pml4e(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(
        recur_to_pte(
            recur_to_pte(
                recur_to_pte(laddr, recursive_index), 
            recursive_index), 
        recursive_index), 
    recursive_index)
}
/// The returned linear address will address the page table entry that defines the page directory 
/// pointer table base that would further translate the linear address to be then translated to a 
/// huge page directory page entry.
#[inline]
pub const fn recur_to_hpde_pml4e(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(
        recur_to_pte(
            recur_to_hpde(laddr, recursive_index), 
            recursive_index),
    recursive_index)
}
/// The returned linear address will address the page table entry that defines the page directory 
/// pointer table base that would further translate the linear address to a huge page directory
/// pointer page entry.
#[inline]
pub const fn recur_to_hpdpe_pml4e(laddr: u64, recursive_index: u64) -> u64 {
    recur_to_pte(
        recur_to_hpdpe(laddr, recursive_index), 
    recursive_index)
}
