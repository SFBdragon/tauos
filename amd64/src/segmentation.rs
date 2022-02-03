//! Module containing segmentation related instructions, structures, interface, etc.

use core::{arch::asm, mem::{size_of, MaybeUninit}};

use super::{PriviledgeLevel, interrupts::Ssdt};



/// IA32_KERNEL_GS_BASE MSR number
pub const KERNEL_GS_BASE: u32 = 0xC0000102;



#[repr(transparent)]
#[derive(Clone, Copy)]
pub struct SegmentSelector(pub u16);

impl SegmentSelector {
    /// Requested Privilege Level mask
    pub const RPL_MASK: u16 = 0b11;
    /// Table index (selector): not set = GDT, set = LDT
    pub const TABLE_SELECTOR_BIT: u16 = 0b100;

    /// Descriptor Table index mask
    pub const INDEX_MASK: u16 = 0b11111111_11111000;

    pub fn new_gdt(rpl: PriviledgeLevel, index: u16) -> Self {
        SegmentSelector((rpl as u16) & Self::RPL_MASK | index << Self::INDEX_MASK.trailing_zeros()) 
    }
    pub fn new_ldt(rpl: PriviledgeLevel, index: u16) -> Self {
        SegmentSelector((rpl as u16) & Self::RPL_MASK | index << Self::INDEX_MASK.trailing_zeros() | Self::TABLE_SELECTOR_BIT) 
    }

    #[inline]
    pub fn get_rpl(&self) -> PriviledgeLevel {
        PriviledgeLevel::from_bits((self.0 & Self::RPL_MASK) as u8)
    }
    #[inline]
    pub fn set_rpl(&mut self, rpl: u8) {
        self.0 = (self.0 & !Self::RPL_MASK) | (rpl as u16);
    }

    #[inline]
    pub fn get_index(&self) -> u16 {
        self.0 >> Self::INDEX_MASK.trailing_zeros()
    }
    #[inline]
    pub fn set_index(&mut self, index: u16) {
        self.0 = self.0 & (Self::RPL_MASK | Self::TABLE_SELECTOR_BIT) | index << Self::INDEX_MASK.trailing_zeros();
    }

    /// Returns whether the selector indexes the Global Descriptor Table (`false`) or Local Descriptor Table (`true`).
    #[inline]
    pub fn get_ti(&self) -> bool {
        self.0 & Self::TABLE_SELECTOR_BIT == Self::TABLE_SELECTOR_BIT
    }
    /// Sets whether the selector indexes the Global Descriptor Table (`false`) or Local Descriptor Table (`true`).
    #[inline]
    pub fn set_ti(&mut self, ti: bool) {
        if ti {
            self.0 |= Self::TABLE_SELECTOR_BIT;
        } else {
            self.0 &= !Self::TABLE_SELECTOR_BIT;
        }
    }
}
impl core::fmt::Debug for SegmentSelector {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("SegmentSelector")
            .field("rpl", &self.get_rpl())
            .field("ti", &self.get_ti())
            .field("index", &self.get_index())
            .finish()
    }
}


pub enum SegmentDescriptor {
    /// Code & Data descriptors
    UserSegment(u64),
    /// System Descriptors - `(lo, hi)`
    SystemSegment((u64, u64)),
}

impl SegmentDescriptor {
    /// Tries to find a slot to insert the descriptor, and if successful inserts it
    /// and returns the index at which the descriptor was inserted, else returns `Err(())`.
    pub fn try_insert_into_gdt(self, gdt: &mut [u64]) -> Result<usize, ()> {
        match self {
            Self::UserSegment(seg) => {
                let mut index = 1;

                while index < gdt.len() {
                    let descriptor = unsafe { CodeSegmentDescriptor::from_bits_unchecked(gdt[index]) };

                    if !descriptor.contains(CodeSegmentDescriptor::PRESENT) {
                        gdt[index] = seg; // unused segment, use it
                        return Ok(index)
                    } else if !descriptor.contains(CodeSegmentDescriptor::TYPE) {
                        index += 2; // system segment, skip "next" descriptor
                    } else {
                        index += 1; // user segment, check next
                    }
                }
            },
            Self::SystemSegment((seg_lo, seg_hi)) => {
                let mut index = 1;
                let mut prev_avl = false;

                while index < gdt.len() {
                    let descriptor = unsafe { CodeSegmentDescriptor::from_bits_unchecked(gdt[index]) };

                    if !descriptor.contains(CodeSegmentDescriptor::PRESENT) {
                        if prev_avl { // 2 unused segments; use them
                            gdt[index - 1] = seg_lo;
                            gdt[index - 0] = seg_hi;
                            return Ok(index - 1);
                        } else {
                            prev_avl = true; // unused segment; mark it
                        }
                    } else if !descriptor.contains(CodeSegmentDescriptor::TYPE) {
                        prev_avl = false;
                        index += 2; // system segment, skip "next" descriptor
                    } else {
                        prev_avl = false;
                        index += 1; // user segment, check next
                    }
                }
            },
        }
        Err(())
    }
}


bitflags::bitflags! {
    /// Code segment descriptor.
    /// 
    /// Limit, base, and various flags are ignored in non-compatibility long mode.
    pub struct CodeSegmentDescriptor: u64 {
        /// Conforming flag:
        /// * set: code can be executed from any priviledge of a higher ring than described
        /// * clear: code can only be executed from the described ring
        const CONFORMING = 1 << 42;

        /// Should be set. If set, descriptor describes a code segment.
        const EXECUTABLE = 1 << 43;
        /// Should be set. If set, descriptor describes a code or data segment, else
        /// descriptor describes a system segment (e.g. a Task State Segment).
        const TYPE = 1 << 44;

        const DPL_MASK = 0b11 << 45;
        const DPL_RING0 = 0b00 << 45;
        const DPL_RING1 = 0b01 << 45;
        const DPL_RING2 = 0b10 << 45;
        const DPL_RING3 = 0b11 << 45;

        /// Must be set for all valid descriptors.
        const PRESENT = 1 << 47;

        /// If set, descriptor defines a long mode code segment, and [`SIZE`][Self::SIZE] should be clear.
        const LONG_MODE = 1 << 53;
        /// If set, descriptor defines a 32-bit protected mode segment
        /// else descriptor defines a 16-bit protected mode segment.
        /// 
        /// Should be clear if `Self::LONG_MODE` is set.
        const SIZE = 1 << 54;
    }

    /// Data segment descriptor.
    /// 
    /// Limit, base, and various flags are ignored in non-compatibility long mode.
    pub struct DataSegmentDescriptor: u64 {

        /// Should be clear. If clear, descriptor describes a data segment.
        const EXECUTABLE = 1 << 43;
        /// Should be set. If set, descriptor describes a code or data segment, else
        /// descriptor describes a system segment (e.g. a Task State Segment).
        const TYPE = 1 << 44;

        /// Must be set for all valid descriptors.
        const PRESENT = 1 << 47;
    }
}

impl Default for CodeSegmentDescriptor {
    /// Sets `CONFORMING`, `EXECUTABLE`, `TYPE`, `PRESENT`, `PRIVILEDGE_RING0`, and `LONG_MODE`.
    fn default() -> Self {
        Self { 
            bits: (CodeSegmentDescriptor::CONFORMING
                | CodeSegmentDescriptor::EXECUTABLE
                | CodeSegmentDescriptor::TYPE
                | CodeSegmentDescriptor::PRESENT
                | CodeSegmentDescriptor::DPL_RING0
                | CodeSegmentDescriptor::LONG_MODE
            ).bits
        }
    }
}
impl Default for DataSegmentDescriptor {
    /// Sets `TYPE` and `PRESENT`.
    fn default() -> Self {
        Self { 
            bits: (DataSegmentDescriptor::TYPE
                | DataSegmentDescriptor::PRESENT
            ).bits
        }
    }
}


#[repr(C, align(8))]
#[derive(Clone, Copy)]
pub struct SystemSegmentDescriptor {
    limit_lo: u16,
    base_lo: u16,
    base_mid_0: u8,
    /// Low nibble: System segment descriptor type
    /// 
    /// High nibble:
    /// * bit 4 - clear
    /// * bits [5:6] - DPL
    /// * bit 7 - present 
    flags: u8,
    /// Low nibble: limit_hi
    /// 
    /// Bit 7: limit Granularity flag. Set for 4KiB (page granularity), clear for byte granularity.
    g_limit_hi: u8,
    base_mid_1: u8,
    base_hi: u32,
    reserved: u32,
}
impl SystemSegmentDescriptor {
    const FLAG_PRESENT: u8 = 0b1000_0000;
    const DPL_MASK: u8 = 0b0110_0000;
    const SSDT_MASK: u8 = 0b0000_1111;
    const GRANULARITY: u8 = 0b1000_0000;
    const LIMIT_MASK: u8 = 0b0000_1111;

    pub fn new(base_laddr: u64, limit: u32, ssdt: Ssdt, priviledge: PriviledgeLevel, page_granularity_limit: bool) -> Self {
        SystemSegmentDescriptor {
            limit_lo: limit as u16,
            base_lo: base_laddr as u16,
            base_mid_0: (base_laddr >> 16) as u8,
            flags: ssdt as u8 | (priviledge as u8) << 5 | 0b1000_0000,
            g_limit_hi: ((limit >> 16) & 0b111) as u8 | (page_granularity_limit as u8) << 7,
            base_mid_1: (base_laddr >> 24) as u8,
            base_hi: (base_laddr >> 32) as u32,
            reserved: 0,
        }
    }

    pub fn into_u64(&self) -> (u64, u64) {
        // Safety: SystemDescriptorTable is repr(align(8))
        // This is more easily, verifiably safe than shifting all values by hand
        let ptr = self as *const _ as *const u64;
        unsafe {
            (*ptr, *ptr.offset(1))
        }
    }

    #[inline]
    pub fn get_base(&self) -> u64 {
        self.base_lo as u64 | (self.base_mid_0 as u64) << 16 | (self.base_mid_1 as u64) << 24 | (self.base_hi as u64) << 32
    }
    #[inline]
    pub fn set_base(&mut self, base_laddr: u64) {
        self.base_lo = base_laddr as u16;
        self.base_mid_0 = (base_laddr >> 16) as u8;
        self.base_mid_1 = (base_laddr >> 24) as u8;
        self.base_hi = (base_laddr >> 32) as u32;
    }
    #[inline]
    pub fn get_limit(&self) -> u32 {
        self.limit_lo as u32 | ((self.g_limit_hi & Self::LIMIT_MASK) as u32) << 16
    }
    #[inline]
    pub fn set_limit(&mut self, limit: u32) {
        self.limit_lo = limit as u16;
        self.g_limit_hi = self.g_limit_hi & !Self::LIMIT_MASK | (limit >> 16) as u8;
    }

    #[inline]
    pub fn get_ssdt(&self) -> Ssdt {
        Ssdt::from_bits(self.flags & Self::SSDT_MASK)
    }
    /// # Arguments
    /// * `ssdt`: `ssdt` must be either `Ssdt::InterruptGate` or `Ssdt::TrapGate`.
    #[inline]
    pub fn set_ssdt(&mut self, ssdt: Ssdt) {
        match ssdt {
            Ssdt::InterruptGate => (),
            Ssdt::TrapGate => (),
            _ => panic!("Invalid system-segment descriptor type for a gate descriptor: {:?}. Expected Interrupt or Trap", ssdt),
        }
        self.flags = self.flags & !Self::SSDT_MASK | ssdt as u8;
    } 

    #[inline]
    pub fn get_dpl(&self) -> PriviledgeLevel {
        PriviledgeLevel::from_bits((self.flags & Self::DPL_MASK) >> Self::DPL_MASK.trailing_zeros())
    }
    #[inline]
    pub fn set_dpl(&mut self, dpl: PriviledgeLevel) {
        self.flags = self.flags & !Self::DPL_MASK | dpl as u8;
    }

    #[inline]
    pub fn is_present(&self) -> bool {
       self.flags & Self::FLAG_PRESENT == Self::FLAG_PRESENT
    }
    #[inline]
    pub fn set_present(&mut self, is_present: bool) {
        if is_present {
            self.flags |= Self::FLAG_PRESENT;
        } else {
            self.flags &= !Self::FLAG_PRESENT;
        }
    }

    #[inline]
    pub fn get_page_granularity(&self) -> bool {
       self.g_limit_hi & Self::GRANULARITY == Self::GRANULARITY
    }
    #[inline]
    pub fn set_page_granularity(&mut self, page_granularity: bool) {
        if page_granularity {
            self.g_limit_hi |= Self::GRANULARITY;
        } else {
            self.g_limit_hi &= !Self::GRANULARITY;
        }
    }
}
impl core::fmt::Debug for SystemSegmentDescriptor {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("SystemSegmentDescriptor")
            .field("base linear address", &self.get_base())
            .field("limit", &self.get_limit())
            .field("limit granularity", &self.get_page_granularity())
            .field("present", &self.is_present())
            .field("ssdt", &self.get_ssdt())
            .field("dpl", &self.get_dpl())
            .finish()
    }
}
impl PartialEq for SystemSegmentDescriptor {
    fn eq(&self, other: &Self) -> bool {
        self.limit_lo == other.limit_lo
        && self.base_lo == other.base_lo
        && self.base_mid_0 == other.base_mid_0
        && self.flags == other.flags
        && self.g_limit_hi == other.g_limit_hi
        && self.base_mid_1 == other.base_mid_1
        && self.base_hi == other.base_hi
    }
}
impl Eq for SystemSegmentDescriptor { }


#[repr(C, packed)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct TaskStateSegment {
    pub reserved_0: u32,
    pub rsp_table: [u64; 3],
    pub reserved_1: u64,
    pub ist_table: [u64; 7],
    pub reserved_2: u64,
    pub reserved_3: u16,
    pub iobp: u16,
}



#[repr(C, packed)]
pub(crate) struct DescriptorTableOp {
    pub limit: u16,
    pub base: u64,
}

/// Load Global Descriptor Table (write to GDTR). 
/// 
/// *Does not refresh segment registers.*
/// # Safety
/// 
/// Caller must ensure that:
/// * `gdt` points to the base of a valid GDT in memory 
/// * setting GDTR using `gdt` won't cause memory safety violations
/// * `gdt` remains in memory at least as long as it is loaded in the GDTR
pub unsafe fn lgdt(gdt: &mut [u64]) {
    lgdt_raw((gdt.len() * size_of::<u64>() - 1) as u16, gdt.as_mut_ptr());
}
/// Load Global Descriptor Table (write to GDTR). 
/// 
/// *Does not refresh segment registers.*
/// # Arguments
/// * `limit`: the size of the table in bytes minus 1
/// * `base`: the linear (paged) address of the table
/// # Safety
/// 
/// Caller must ensure that:
/// * `gdt` points to the base of a valid GDT in memory 
/// * setting GDTR using `gdt` won't cause memory safety violations
/// * `gdt` remains in memory at least as long as it is loaded in the GDTR
pub unsafe fn lgdt_raw(limit: u16, base: *const u64) {
    let dto = DescriptorTableOp { limit, base: base as u64 };
    asm!("lgdt [{}]", in(reg) &dto, options(readonly, nostack, preserves_flags));
}

/// Store Global Descriptor Table (read from GDTR)
pub fn sgdt<'a>() -> &'a mut [u64] {
    let (limit, base) = sgdt_raw();
    unsafe {
        core::slice::from_raw_parts_mut(base as *mut u64, (limit as usize + 1) / core::mem::size_of::<u64>())
    }
}
/// Store Global Descriptor Table (read from GDTR)
/// # Returns
/// * 0: the size of the table in bytes minus 1
/// * 1: the linear (paged) address of the table
pub fn sgdt_raw() -> (u16, *mut u64) {
    let mut dto: MaybeUninit<DescriptorTableOp> = MaybeUninit::uninit();

    unsafe {
        asm!("sgdt [{}]", in(reg) &mut dto, options(nostack, preserves_flags));
    }

    let dto = unsafe { dto.assume_init() };
    (dto.limit, dto.base as *mut _)
}

pub fn cs_read() -> u16 {
    let cs: u16;
    unsafe {
        asm!("mov {:x}, cs", out(reg) cs, options(nomem, nostack, preserves_flags));
    }
    cs
}
/// # Safety:
/// Ensure selector is a valid and correctly priviledged code segment.
pub unsafe fn cs_write(selector: SegmentSelector) {
    asm!(
        "push {0}",            // push selector word
        "lea {1}, [rip + 2f]", // calcuate return instruction address
        "push {1}",            // push return intruction address
        "retfq",               // far call, switching segment and jumping to '2:'
        "2:",                  // label for far call address
        in(reg) selector.0 as u64,
        lateout(reg) _,
        options(preserves_flags)
    )
}
pub fn fs_read() -> u16 {
    let fs: u16;
    unsafe {
        asm!("mov {:x}, fs", out(reg) fs, options(nomem, nostack, preserves_flags));
    }
    fs
}
/// # Safety:
/// Ensure selector is a valid and correctly priviledged data segment.
pub unsafe fn fs_write(selector: SegmentSelector) {
    asm!("mov fs, {:x}", in(reg) selector.0, options(nostack, preserves_flags));
}
pub fn gs_read() -> u16 {
    let gs: u16;
    unsafe {
        asm!("mov {:x}, gs", out(reg) gs, options(nomem, nostack, preserves_flags));
    }
    gs
}
/// # Safety:
/// Ensure selector is a valid and correctly priviledged data segment.
pub unsafe fn gs_write(selector: SegmentSelector) {
    asm!("mov gs, {:x}", in(reg) selector.0, options(nostack, preserves_flags));
}

/// Read FS Base address
/// 
/// Ensure [FSGSBASE][super::registers::CR4::FSGSBASE] is set, else this will fault.
pub fn rdfsbase() -> u64 {
    let fsbase: u64;
    unsafe {
        asm!("rdfsbase {}", out(reg) fsbase, options(nomem, nostack, preserves_flags));
    }
    fsbase
}
/// Read FS Base address
/// 
/// Ensure [FSGSBASE][super::registers::CR4::FSGSBASE] is set, else this will fault.
pub unsafe fn wrfsbase(fsbase: u64) {
    asm!("wrfsbase {}", in(reg) fsbase, options(nomem, nostack, preserves_flags));
}
/// Read GS Base address
/// 
/// Ensure [FSGSBASE][super::registers::CR4::FSGSBASE] is set, else this will fault.
pub fn rdgsbase() -> u64 {
    let gsbase: u64;
    unsafe {
        asm!("rdgsbase {}", out(reg) gsbase, options(nomem, nostack, preserves_flags));
    }
    gsbase
}
/// Write GS Base address
/// 
/// Ensure [FSGSBASE][super::registers::CR4::FSGSBASE] is set, else this will fault.
pub unsafe fn wrgsbase(gsbase: u64) {
    asm!("wrgsbase {}", in(reg) gsbase, options(nomem, nostack, preserves_flags));
}
/// Swap the content of the GS register and the `KERNEL_GS_BASE` MSR
pub unsafe fn gsswap() {
    asm!("swapgs", options(nomem, nostack, preserves_flags));
}
