
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
    PTE4KiB    = PTE_SIZE,
    PDE2MiB    = PDE_SIZE,
    PDPTE1GiB  = PDPTE_SIZE,
}
impl PageSize {
    /// ### Safety:
    /// `size` must be `PTE_SIZE`, `PDE_SIZE`, or `PDPTE_SIZE`.
    pub const unsafe fn from_usize(size: usize) -> PageSize {
        core::mem::transmute(size)
    }
}


pub const PT_LVL: usize = 1;
pub const PD_LVL: usize = 2;
pub const PDPT_LVL: usize = 3;
pub const PML4_LVL: usize = 4;

bitflags::bitflags! {
    /// Page Table Entry flags. 
    /// Generic over all long mode page tables, see flag documentation for details.
    pub struct PTE: usize {
        /// Present: When set, determines that the physical page base specified
        /// is loaded in physical memory. When clear, the rest of the entry 
        /// becomes available for software use.
        const P = 1 << 0;

        /// Read/Write: When set, allows write and read permissions,
        /// else readonly. Does not cascade.
        const RW = 1 << 1;
        /// User/Supervisor: When set, allows user (CPL3) access, 
        /// else access is supervisor only (CPL 0,1,2). Does not cascade.
        const US = 1 << 2;
        /// Page write-through: When set, a writethrough policy is employed 
        /// instead of writeback for the physical page/page-translation table.
        const PWT = 1 << 3;
        /// Page Cache Disable: When set, caching is disabled for the physical 
        /// page/page-translation table.
        const PCD = 1 << 4;

        /// A: When set, the CPU has accessed the physical 
        /// page/page-translation table.
        const A = 1 << 5;
        /// D: When a leaf table, and set, indicates the CPU has written to 
        /// the physical page/page-translation table.
        /// 
        /// Ignored for branch tables.
        const D = 1 << 6;


        /// Page Size: When not a Page Table (level 1) entry, when set,
        /// indicates that this maps a large page directly, else references 
        /// an address translation page table.
        const PS = 1 << 7;
        /// When a Page Table (level 1) entry, determines the high-order 
        /// bit of a 3-bit index into the PAT register.
        const PAT = 1 << 7;
        
        /// Global: When set, and `CR4::PGE` is set (else is reserved),
        /// determines that that the TLB entry for a global page is not 
        /// invalidated when CR3 is loaded either explicitly by a MOV CRn 
        /// instruction or implicitly during a task switch.
        const G = 1 << 8;

        /// Bits available for use.
        const AVL_MASK_0 = 0o7000;

        
        /// When not a Page Table (level 1) entry, and `PTE::HUGE_PAGE` is set,
        /// determines the high-order bit of a 3-bit index into the PAT register.
        const PAT_PS = 1 << 12;

        /// Defines the physical address of the mapped page/next page table.
        /// 
        /// Alignment is determined by page table level, and the rest of the 
        /// bits are inferred to be zero:
        /// * Leaf PTE: 4KiB mapped page alignment, 12 bits inferred to be zero.
        /// * Leaf PDE (`Self::PS`): 2MiB mapped page alignment, 21 bits 
        /// inferred to be zero.
        /// * Leaf PDPE (`Self::PS`): 1GiB mapped page alignment, 30 bits 
        /// inferred to be zero.
        /// 
        /// The 52-bit address size limit is architecture defined for AMD64, 
        /// in long mode, but may be less depending on implementation.
        const BASE_MASK           = 0o000017_777_777_777_777_0000;

        /// Bits available for use.
        const AVL_MASK_1    = 0o003760_000_000_000_000_0000;

        /// When `CR4::PKE` is set, and table is a leaf, determines the protection 
        /// key used for the mapped page.
        /// Available when `CR4::PKE` is clear, or when this table is not a leaf.
        const PKM = 0o074000_000_000_000_000_0000;

        /// When set, and `EFER::NXE` is set (else is reserved), determines that 
        /// instruction fetches are not allowed to occur within the 
        /// directly/indirectly mapped page/s.
        const NX = 1 << 63;
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
    pub const fn from_pat(pat_idx: u8, is_hpage: bool) -> PTE {
        let mut pte = PTE::empty();

        if pat_idx & 1 << 0 != 0 {
            pte = pte.union(PTE::PWT);
        }
        if pat_idx & 1 << 1 != 0 {
            pte = pte.union(PTE::PCD);
        }
        if pat_idx & 1 << 2 != 0 {
            if is_hpage {
                pte = pte.union(PTE::PAT_PS);
            } else {
                pte = pte.union(PTE::PAT);
            }
        }

        pte
    }

    #[inline]
    pub const fn get_paddr(&self) -> usize {
        self.bits & PTE::BASE_MASK.bits
    }
}


// PAT

#[repr(u8)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum PatType {
    /// All accesses are uncacheable. Write combining is not allowed.
    /// Speculative accesses are not allowed.
    Uncacheable = 0,
    /// All accesses are uncacheable. Write combining is allowed.
    /// Speculative reads are allowed.
    WriteCombining = 1,
    /// Reads allocate cache lines on a cache miss, but only to the shared state.
    /// Cache lines are not allocated on a write miss. Write hits update the cache
    /// and main memory.
    WriteThrough = 4,
    /// Reads allocate cache lines on a cache miss, but only to the shared state.
    /// All writes update main memory. Cache lines are not allocated on a write miss.
    /// Write hits invalidate the cache line and update main memory.
    WriteProtect = 5,
    /// Reads allocate cache lines on a cache miss, and can allocate to either the
    /// shared or exclusive state. Writes allocate to the modified state on a cache miss.
    WriteBack = 6,
    /// All accesses are uncacheable. Write combining is not allowed. Speculative
    /// accesses are not allowed. Can be overridden by an MTRR with the WC type.
    UncacheableMinus = 7,
}
impl PatType {
    pub fn from_bits(code: u8) -> Self {
        match code {
            0 => PatType::Uncacheable,
            1 => PatType::WriteCombining,
            4 => PatType::WriteThrough,
            5 => PatType::WriteProtect,
            6 => PatType::WriteBack,
            7 => PatType::UncacheableMinus,
            _ => panic!("Invalid PAT type.")
        }
    }

    pub fn to_bits(self) -> u8 {
        self as u8
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Pat {
    /// PAT types used where the PAT bit is **clear**.
    pub std_types: [PatType; 4],
    /// PAT types used where the PAT bit is **set**.
    pub pat_types: [PatType; 4],
}
impl Default for Pat {
    /// Returns the reset value for the register.
    /// 
    /// `pat_types` are a clone of `std_types`.
    fn default() -> Self {
        // index = {PAT, PCD, PWT} bits
        Self {
            std_types: [
                PatType::WriteBack,
                PatType::WriteThrough,
                PatType::UncacheableMinus,
                PatType::Uncacheable,
            ],
            pat_types: [
                PatType::WriteBack,
                PatType::WriteThrough,
                PatType::UncacheableMinus,
                PatType::Uncacheable,
            ]
        }
    }
}
impl Pat {
    pub const PAT_MSR: u64 = 0x00000277;

    /// Read the data in the PAT MSR.
    pub fn read() -> Self {
        let pat_msr = crate::registers::rdmsr(Self::PAT_MSR);

        Pat {
            std_types: [
                PatType::from_bits((pat_msr >> 00) as u8),
                PatType::from_bits((pat_msr >> 08) as u8),
                PatType::from_bits((pat_msr >> 16) as u8),
                PatType::from_bits((pat_msr >> 24) as u8),
            ],
            pat_types: [
                PatType::from_bits((pat_msr >> 32) as u8),
                PatType::from_bits((pat_msr >> 40) as u8),
                PatType::from_bits((pat_msr >> 48) as u8),
                PatType::from_bits((pat_msr >> 56) as u8),
            ]
        }
    }

    /// Write the data to the PAT MSR.
    /// ### Safety:
    /// Caller must guarantee that the new PAT will not cause memory unsafety.
    pub unsafe fn write(self) {
        let mut pat = 0;

        pat |= (self.std_types[0].to_bits() as u64) << 00;
        pat |= (self.std_types[1].to_bits() as u64) << 08;
        pat |= (self.std_types[2].to_bits() as u64) << 16;
        pat |= (self.std_types[3].to_bits() as u64) << 24;
        pat |= (self.pat_types[0].to_bits() as u64) << 32;
        pat |= (self.pat_types[1].to_bits() as u64) << 40;
        pat |= (self.pat_types[2].to_bits() as u64) << 48;
        pat |= (self.pat_types[3].to_bits() as u64) << 56;

        crate::registers::wrmsr(Self::PAT_MSR, pat);
    }
}




// GENERAL PAGE TABLE UTILS


/// Return the size of the virtual memory that a given page table entry spans, 
/// where a PDPT entry is `level` 3, a PDT is entry `level` 2, and so on.
pub const fn page_size(lvl: usize) -> usize {
    0o10 << lvl * 9
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

