use core::{marker::PhantomData, fmt::Debug, panic, mem::{MaybeUninit, size_of}};

use super::{segmentation::{DescriptorTableOp, SegmentSelector}, PrivLvl};


// ERROR CODES

// Error code docs are taken from https://www.amd.com/system/files/TechDocs/24593.pdf
bitflags::bitflags! {
    /// Selector error code flags.
    pub struct SelErrCode: u64 {
        /// EXT: If this bit is set to 1, the exception source is external to the processor. If cleared to 0,
        /// the exception source is internal to the processor.
        const EXTERNAL = 1 << 0;
        /// IDT: If this bit is set to 1, the error-code selector-index field references a gate descriptor
        /// located in the interrupt-descriptor table (IDT). If cleared to 0, the selector-index field references a
        /// descriptor in either the global-descriptor table (GDT) or local-descriptor table (LDT), as indicated
        /// by the TI bit.
        const IDT = 1 << 1;
        /// TI: If this bit is set to 1, the error-code selector-index field references a descriptor in the
        /// LDT. If cleared to 0, the selector-index field references a descriptor in the GDT. The TI bit is
        /// relevant only when the IDT bit is cleared to 0.
        const LDT = 1 << 2;
        /// Selector: The selector-index field specifies the index into either the GDT, LDT,
        /// or IDT, as specified by the IDT and TI bits.
        const INDEX_MASK = 0b11111111_11111000;
    }

    /// Page Fault error code flags.
    pub struct PfErrCode: u64 {
        /// P: If this bit is cleared to 0, the page fault was caused by a not-present page. If this bit is set
        /// to 1, the page fault was caused by a page-protection violation.
        const P = 1 << 0;
        /// R/W: If this bit is cleared to 0, the access that caused the page fault is a memory read. If this
        /// bit is set to 1, the memory access that caused the page fault was a write. This bit does not
        /// necessarily indicate the cause of the page fault was a read or write violation.
        const RW = 1 << 1;
        /// U/S: If this bit is cleared to 0, an access in supervisor mode (CPL=0, 1, or 2) caused the
        /// page fault. If this bit is set to 1, an access in user mode (CPL=3) caused the page fault. This bit does
        /// not necessarily indicate the cause of the page fault was a privilege violation.
        const US = 1 << 2;
        /// RSV: If this bit is set to 1, the page fault is a result of the processor reading a 1 from a
        /// reserved field within a page-translation-table entry. This type of page fault occurs only when
        /// CR4.PSE=1 or CR4.PAE=1. If this bit is cleared to 0, the page fault was not caused by the
        /// processor reading a 1 from a reserved field.
        const RSV = 1 << 3;
        /// I/D: If this bit is set to 1, it indicates that the access that caused the page fault was an
        /// instruction fetch. Otherwise, this bit is cleared to 0. This bit is only defined if no-execute feature is
        /// enabled (EFER.NXE=1 && CR4.PAE=1).
        const ID = 1 << 4;
        /// PK: If this bit is set to 1, it indicates that a data access to a user-mode address caused a
        /// protection key violation. This fault only occurs if memory protection keys are enabled
        /// (CR4.PKE=1).
        const PK = 1 << 5;
        /// SS: If this bit is set to 1, the page fault was caused by a shadow stack access. This bit is only
        /// set when the shadow stack feature is enabled (CR4.CET=1).
        const SS = 1 << 6;
        /// RMP: If this bit is set to 1, the page fault is a result of the processor encountering an RMP
        /// violation. This type of page fault only occurs when SYSCFG[SecureNestedPagingEn]=1. If this
        /// bit is cleared to 0, the page fault was not caused by an RMP violation. See section 15.36.10 for
        /// additional information.
        const RMP = 1 << 31;
    }
}

/// Control Protection error codes.
#[repr(u32)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CtrlProtErrCode {
    /// 1 NEAR-RET A RET (near) instruction encountered a return address mismatch.
    Near = 1,
    /// 2 FAR-RET/IRET A RET (far) or IRET instruction encountered a return address mismatch.
    FarRetIRet = 2,
    /// An RSTORSSP instruction encountered an invalid shadow stack restore token.
    RstorSsp = 3,
    /// A SETSSBSY instruction encountered an invalid supervisor shadow stack token. 
    SetSsBsy = 4,
}


// GATES

const GATE_FLAG_PRESENT: u8 = 0b1000_0000;
const GATE_DPL_MASK: u8 = 0b0110_0000;
const GATE_SSDT_MASK: u8 = 0b0000_1111;

/// System-Segment Descriptor Type. 
/// 
/// Long mode specific.
#[repr(u8)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Ssdt {
    Ldt           = 0b0010,
    AvlTss        = 0b1001,
    BusyTss       = 0b1011,
    CallGate      = 0b1100,
    InterruptGate = 0b1110,
    TrapGate      = 0b1111,
}

impl Ssdt {
    pub fn from_bits(from: u8) -> Self {
        match from {
            0b0010 => Ssdt::Ldt,
            0b1001 => Ssdt::AvlTss,
            0b1011 => Ssdt::BusyTss,
            0b1100 => Ssdt::CallGate,
            0b1110 => Ssdt::InterruptGate,
            0b1111 => Ssdt::TrapGate,
            _ => panic!("Invalid x86 system-segment descriptor type"),
        }
    }
}

/// An interrupt gate or trap gate descriptor entry of the Interrupt Descriptor Table.
#[repr(C)]
#[derive(Clone, Copy)]
pub struct IntTrapGate<F> {
    /// Partial interrupt service routine function pointer address
    isr_ptr_lo: u16,
    /// Segment selector to a code segment
    pub selector: u16,
    /// Low three bits are the Interrupt Stack Table (IST) index, that when not zero, are used 
    /// to index into a portion of a long mode TSS where the IST resides, and execute the handler
    /// on that stack instead. This can be useful for handling errors that have corrupted the stack.
    /// 
    /// When zero, legacy stack-switching mechanism is used.
    ist: u8,
    /// Low nibble:
    /// * `Ssdt::InterruptGate` - 64-bit interrupt gate
    /// * `Ssdt::TrapGate` - 64-bit trap gate
    /// 
    /// High nibble:
    /// * bit 4 - clear
    /// * bit 5:6 - DPL
    /// * bit 7 - present 
    flags: u8,
    /// Partial interrupt service routine function pointer address
    isr_ptr_mid: u16,
    /// Partial interrupt service routine function pointer address
    isr_ptr_hi: u32,
    reserved: u32,
    phantom: PhantomData<F>,
}
impl<F> IntTrapGate<F> {
    /// # Arguments
    /// * `ssdt`: `ssdt` must be either `Ssdt::InterruptGate` or `Ssdt::TrapGate`.
    pub fn missing(ssdt: Ssdt) -> Self {
        match ssdt {
            Ssdt::InterruptGate => (),
            Ssdt::TrapGate => (),
            _ => panic!("Invalid system-segment descriptor type for a gate descriptor: {:?}. Expected Interrupt or Trap", ssdt),
        }

        IntTrapGate {
            isr_ptr_lo: 0,
            selector: 0,
            ist: 0,
            flags: ssdt as u8,
            isr_ptr_mid: 0,
            isr_ptr_hi: 0,
            reserved: 0,
            phantom: PhantomData,
        }
    }

    /// # Arguments
    /// * `ssdt`: `ssdt` must be either `Ssdt::InterruptGate` or `Ssdt::TrapGate`.
    /// * `ist`: `ist` (Interrupt Stack Table index) must be less than 8.
    pub fn new(target_laddr: u64, selector: SegmentSelector, ist: u8, ssdt: Ssdt, priviledge: PrivLvl) -> Self {
        match ssdt {
            Ssdt::InterruptGate => (),
            Ssdt::TrapGate => (),
            _ => panic!("Invalid system-segment descriptor type for a gate descriptor: {:?}. Expected Interrupt or Trap", ssdt),
        }
        if ist > 7 {
            panic!("Interrupt Stack Table index (IST) must be between 0 and 7 inclusive, instead was {}.", ist);
        }

        IntTrapGate {
            isr_ptr_lo: target_laddr as u16,
            selector: selector.0,
            ist,
            flags: ssdt as u8 | (priviledge as u8) << GATE_DPL_MASK.trailing_zeros() | GATE_FLAG_PRESENT,
            isr_ptr_mid: (target_laddr >> 16) as u16,
            isr_ptr_hi: (target_laddr >> 32) as u32,
            reserved: 0,
            phantom: PhantomData,
        }
    }

    #[inline]
    pub fn get_target(&self) -> u64 {
        self.isr_ptr_lo as u64 | (self.isr_ptr_mid as u64) << 16 | (self.isr_ptr_hi as u64) << 32
    }
    #[inline]
    pub fn set_target(&mut self, target_laddr: u64) {
        self.isr_ptr_lo = target_laddr as u16;
        self.isr_ptr_mid = (target_laddr >> 16) as u16;
        self.isr_ptr_hi = (target_laddr >> 32) as u32;
    }
    
    #[inline]
    pub fn get_ist(&self) -> u8 {
        self.ist
    }
    /// # Arguments
    /// * `ist`: `ist` (Interrupt Stack Table index) must be less than 8.
    #[inline]
    pub fn set_ist(&mut self, ist: u8) {
        if ist > 7 {
            panic!("Interrupt Stack Table index (IST) must be between 0 and 7 inclusive, instead was {}.", ist);
        }
        self.ist = ist;
    } 

    #[inline]
    pub fn get_ssdt(&self) -> Ssdt {
        Ssdt::from_bits(self.flags & GATE_SSDT_MASK)
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
        self.flags = self.flags & !GATE_SSDT_MASK | ssdt as u8;
    } 

    #[inline]
    pub fn get_dpl(&self) -> PrivLvl {
        PrivLvl::from_bits((self.flags & GATE_DPL_MASK) >> GATE_DPL_MASK.trailing_zeros())
    }
    #[inline]
    pub fn set_dpl(&mut self, dpl: PrivLvl) {
        self.flags = self.flags & !GATE_DPL_MASK | dpl as u8;
    }

    #[inline]
    pub fn is_present(&self) -> bool {
       self.flags & GATE_FLAG_PRESENT == GATE_FLAG_PRESENT
    }
    #[inline]
    pub fn set_present(&mut self, is_present: bool) {
        if is_present {
            self.flags |= GATE_FLAG_PRESENT;
        } else {
            self.flags &= !GATE_FLAG_PRESENT;
        }
    }
}
impl<F> Debug for IntTrapGate<F> {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("GateDescriptor")
            .field("target linear address", &self.get_target())
            .field("selector", &self.selector)
            .field("present", &self.is_present())
            .field("ssdt", &self.get_ssdt())
            .field("dpl", &self.get_dpl())
            .field("ist", &self.ist)
            .finish()
    }
}
impl<F> PartialEq for IntTrapGate<F> {
    fn eq(&self, other: &Self) -> bool {
        self.isr_ptr_lo == other.isr_ptr_lo
        && self.selector == other.selector
        && self.ist == other.ist
        && self.flags == other.flags
        && self.isr_ptr_mid == other.isr_ptr_mid
        && self.isr_ptr_hi == other.isr_ptr_hi
    }
}
impl<F> Eq for IntTrapGate<F> { }

/// A call gate descriptor entry of the Interrupt Descriptor Table.
#[repr(C)]
#[derive(Clone, Copy)]
pub struct CallGate<F> {
    /// Partial interrupt service routine function pointer address
    isr_ptr_lo: u16,
    /// Segment selector to a code segment
    pub selector: u16,
    reserved_0: u8,
    /// Low nibble:
    /// * `Ssdt::CallGate` - 64-bit call gate
    /// 
    /// High nibble:
    /// * bit 4 - clear
    /// * bit 5:6 - DPL
    /// * bit 7 - present 
    flags: u8,
    /// Partial interrupt service routine function pointer address
    isr_ptr_mid: u16,
    /// Partial interrupt service routine function pointer address
    isr_ptr_hi: u32,
    reserved_1: u32,
    phantom: PhantomData<F>,
}

impl<F> CallGate<F> {
    pub fn missing() -> Self {
        CallGate {
            isr_ptr_lo: 0,
            selector: 0,
            reserved_0: 0,
            flags: Ssdt::CallGate as u8,
            isr_ptr_mid: 0,
            isr_ptr_hi: 0,
            reserved_1: 0,
            phantom: PhantomData,
        }
    }

    pub fn new(target_laddr: u64, selector: SegmentSelector, priviledge: PrivLvl) -> Self {
        CallGate {
            isr_ptr_lo: target_laddr as u16,
            selector: selector.0,
            reserved_0: 0,
            flags: Ssdt::CallGate as u8 | (priviledge as u8) << GATE_DPL_MASK.trailing_zeros() | GATE_FLAG_PRESENT,
            isr_ptr_mid: (target_laddr >> 16) as u16,
            isr_ptr_hi: (target_laddr >> 32) as u32,
            reserved_1: 0,
            phantom: PhantomData,
        }
    }

    #[inline]
    pub fn get_target(&self) -> u64 {
        self.isr_ptr_lo as u64 | (self.isr_ptr_mid as u64) << 16 | (self.isr_ptr_hi as u64) << 32
    }
    #[inline]
    pub fn set_target(&mut self, target_laddr: u64) {
        self.isr_ptr_lo = target_laddr as u16;
        self.isr_ptr_mid = (target_laddr >> 16) as u16;
        self.isr_ptr_hi = (target_laddr >> 32) as u32;
    } 

    #[inline]
    pub fn get_dpl(&self) -> PrivLvl {
        PrivLvl::from_bits((self.flags & GATE_DPL_MASK) >> GATE_DPL_MASK.trailing_zeros())
    }
    #[inline]
    pub fn set_dpl(&mut self, dpl: PrivLvl) {
        self.flags = self.flags & !GATE_DPL_MASK | dpl as u8;
    }

    #[inline]
    pub fn is_present(&self) -> bool {
       self.flags & GATE_FLAG_PRESENT == GATE_FLAG_PRESENT
    }
    #[inline]
    pub fn set_present(&mut self, is_present: bool) {
        if is_present {
            self.flags |= GATE_FLAG_PRESENT;
        } else {
            self.flags &= !GATE_FLAG_PRESENT;
        }
    }
}
impl<F> Debug for CallGate<F> {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("GateDescriptor")
            .field("target linear address", &self.get_target())
            .field("selector", &self.selector)
            .field("present", &self.is_present())
            .field("dpl", &self.get_dpl())
            .finish()
    }
}
impl<F> PartialEq for CallGate<F> {
    fn eq(&self, other: &Self) -> bool {
        self.isr_ptr_lo == other.isr_ptr_lo
        && self.selector == other.selector
        && self.flags == other.flags
        && self.isr_ptr_mid == other.isr_ptr_mid
        && self.isr_ptr_hi == other.isr_ptr_hi
    }
}
impl<F> Eq for CallGate<F> { }


// IDT

#[repr(C, align(16))]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct InterruptStackFrame {
    pub ss: u64,
    pub rsp: u64,
    pub rflags: u64,
    pub cs: u64,
    pub rip: u64,
}

pub type Handler = extern "x86-interrupt" fn(InterruptStackFrame);
pub type HandlerWithErrCode = extern "x86-interrupt" fn(InterruptStackFrame, u64);
pub type DivergingHandlerWithErrCode = extern "x86-interrupt" fn(InterruptStackFrame, u64) -> !;

/// Interrupt Descriptor Table (IDT)
/// 
/// Contains Gate Descriptors that define interrupt handling.
/// 
/// Program restart flavours: Faults return to the executed instruction, traps to the following instruction, 
/// aborts might diverge. This is denoted with the suffix `_fault`, `_trap`, `_abort`, or none where 'it's complicated'.
#[repr(C, packed)]
pub struct InterruptDesciptorTable {

    /// 0 Divide-by-Zero-Error #DE DIV, IDIV, AAM instructions
    pub div_by_zero_fault: IntTrapGate<Handler>,

    /// 1 Debug #DB Instruction accesses and data accesses
    /// 
    /// #DB information is returned in the debug-status register, DR6.
    pub debug: IntTrapGate<Handler>,

    /// 2 Non-Maskable-Interrupt #NMI External NMI signal
    pub non_maskable_interrupt: IntTrapGate<Handler>,

    /// 3 Breakpoint #BP INT3 instruction
    pub break_point_trap: IntTrapGate<Handler>,

    /// 4 Overflow #OF INTO instruction
    pub overflow_trap: IntTrapGate<Handler>,

    /// 5 Bound-Range #BR BOUND instruction
    pub bound_range_fault: IntTrapGate<Handler>,

    /// 6 Invalid-Opcode #UD Invalid instructions
    pub invalid_opcode_fault: IntTrapGate<Handler>,

    /// 7 Device-Not-Available #NM x87 instructions
    pub device_not_available_fault: IntTrapGate<Handler>,

    /// 8 Double-Fault #DF Exception during the handling of another exception or interrupt [async]
    /// 
    /// Error code: zero.
    pub double_fault_abort: IntTrapGate<DivergingHandlerWithErrCode>,

    /// 9 Coprocessor-Segment-Overrun — Unsupported (Reserved)
    pub reserved_0: u128,

    /// 10 Invalid-TSS #TS Task-state segment access and task switch
    /// 
    /// Error code: a segment selector index.
    pub invalid_tss_fault: IntTrapGate<HandlerWithErrCode>,

    /// 11 Segment-Not-Present #NP Segment register loads
    /// 
    /// Error code: the messing segment index.
    pub segment_not_present_fault: IntTrapGate<HandlerWithErrCode>,

    /// 12 Stack #SS SS register loads and stack references
    /// 
    /// Error code: zero or stack segment selector index.
    pub stack_fault: IntTrapGate<HandlerWithErrCode>,

    /// 13 General-Protection #GP Memory accesses and protection checks
    /// 
    /// Error code: selector index or zero.
    pub general_protection_fault: IntTrapGate<HandlerWithErrCode>,

    /// 14 Page-Fault #PF Memory accesses when paging enabled
    /// 
    /// Error code: `PageFaultErrCodeFlags`
    /// 
    /// The faulting linear address is stored in CR2.
    pub page_fault: IntTrapGate<HandlerWithErrCode>,

    /// 15 Reserved —
    pub reserved_1: u128,

    /// 16 x87 Floating-Point Exception Pending #MF x87 floating-point instructions [async]
    /// 
    /// Unused in 64-bit long mode.
    /// 
    /// Exception information is provided by the x87 status-word register.
    pub x87_fp_fault: IntTrapGate<Handler>,

    /// 17 Alignment-Check #AC Misaligned memory accesses
    /// 
    /// Error code: zero.
    pub alignment_check_fault: IntTrapGate<HandlerWithErrCode>,

    /// 18 Machine-Check #MC Model specific [async]
    /// 
    /// Program restart: If the RIPV flag (RIP valid) is set in the MCG_Status MSR, the saved 
    /// CS and rIP point to the instruction at which the interrupted process thread can be restarted. 
    /// If RIPV is clear, there is no reliable way to restart the program.
    /// 
    /// Error information is provided by model-specific registers (MSRs) defined by the machine-check architecture.
    pub machine_check_abort: IntTrapGate<Handler>,

    /// 19 SIMD Floating-Point #XF SSE floating-point instructions
    /// 
    /// Exception information is provided by the SSE floating-point MXCSR register.
    pub simd_fp_fault: IntTrapGate<Handler>,
    
    /// 20 Reserved —
    pub reserved_2: u128,

    /// 21 Control-Protection Exception #CP RET/IRET or other control transfer
    /// 
    /// Error code: `ControlProtectionErrCode`.
    pub control_protection_fault: IntTrapGate<HandlerWithErrCode>,

    /// 22–27 Reserved —
    pub reserved_3: [u128; 6],
    
    /// 28 Hypervisor Injection Exception #HV Event injection
    pub hypervisor_injection: IntTrapGate<HandlerWithErrCode>,
    /// 29 VMM Communication Exception #VC Virtualization event
    pub vmm_communication_fault: IntTrapGate<HandlerWithErrCode>,
    /// 30 Security Exception #SX Security-sensitive event in host
    pub security: IntTrapGate<HandlerWithErrCode>,

    /// 31 Reserved —
    pub reserved_4: u128,

    /// 32-255 Available
    pub interrupts: [IntTrapGate<Handler>; 224],
}


// TODO: NMI handler - check if between a sti and a hlt, and inc IP if so

/// Disable Interrupts
pub fn cli() {
    unsafe {
        core::arch::asm!("cli", options(nostack, nomem, preserves_flags));
    }
}
/// Enable Interrupts
pub fn sti() {
    unsafe {
        core::arch::asm!("sti", options(nostack, nomem, preserves_flags));
    }
}
/// Enable Interrupts and Halt
/// 
/// Useful for preventing race conditions between interrupts and a hlt.
pub fn sti_hlt() {
    unsafe {
        core::arch::asm!("sti; hlt", options(nostack, nomem, preserves_flags)); 
    }
}

/// Load Interrupt Descriptor Table into IDTR
/// # Safety:
/// Caller must ensure loading this IDT is safe.
pub unsafe fn lidt(idt: *const InterruptDesciptorTable) {
    lidt_raw(size_of::<InterruptDesciptorTable>() as u16 - 1, idt)
}
/// Load Interrupt Descriptor Table into IDTR
/// # Arguments
/// * `limit`: the size of the table in bytes minus 1
/// * `base`: the linear (paged) address of the table
/// 
/// # Safety
/// Caller must ensure that:
/// * `base` points to the base of an IDT in memory
/// * `limit` is accurate
/// * loading this IDT is safe
pub unsafe fn lidt_raw(limit: u16, base: *const InterruptDesciptorTable) {
    let dto = DescriptorTableOp { limit, base: base as u64 };
    core::arch::asm!("lidt [{}]", in(reg) &dto, options(readonly, nostack, preserves_flags));
}

/// Store Interrupt Descriptor Table (read from IDTR)
pub fn sidt<'a>() -> &'a mut InterruptDesciptorTable {
    let (_, base) = sidt_raw();
    unsafe {
        base.as_mut().unwrap()
    }
}
/// Store Interrupt Descriptor Table (read from IDTR)
/// # Returns
/// * 0: the size of the table in bytes minus 1
/// * 1: the linear (paged) address of the table
pub fn sidt_raw() -> (u16, *mut InterruptDesciptorTable) {
    let mut dto: MaybeUninit<DescriptorTableOp> = MaybeUninit::uninit();

    unsafe {
        core::arch::asm!("sidt [{}]", in(reg) &mut dto, options(nostack, preserves_flags));
    }

    let dto = unsafe { dto.assume_init() };
    (dto.limit, dto.base as *mut _)
}

/// Load Task Register
pub unsafe fn ltr(selector: SegmentSelector) {
    core::arch::asm!("ltr {:x}", in(reg) selector.0, options(nomem, nostack, preserves_flags));
}
/// Store Task Register
pub fn str() -> SegmentSelector {
    let selector: u16;
    unsafe {
        core::arch::asm!("ltr {:x}", out(reg) selector, options(nomem, nostack, preserves_flags));
    }
    SegmentSelector(selector)
}
