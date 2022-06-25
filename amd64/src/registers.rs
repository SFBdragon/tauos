//! Interaction and access to some common x86-64 registers.

use core::arch::asm;

pub const APIC_BASE_MSR: u64 = 0x0000001B;
pub const EFER_MSR: u64 =      0xC0000080;
pub const MPERF_MSR: u64 =     0xC00000E7;
pub const APERF_MSR: u64 =     0xC00000E8;


bitflags::bitflags! {
    #[repr(transparent)]
    pub struct RFLAGS: u64 {
        /// Carry Flag
        const CF = 1 << 0;
        /// Parity Flag
        const PF = 1 << 2;
        /// Adjust Flag
        const AF = 1 << 4;
        /// Zero Flag
        const ZF = 1 << 6;
        /// Sign flag
        const SF = 1 << 7;
        /// Trap Flag
        const TF = 1 << 8;
        /// Interrupt Enable Flag
        const IF = 1 << 9;
        /// Direction Flag
        const DF = 1 << 10;
        /// Overflow Flag
        const OF = 1 << 11;

        /// I/O Priviledge Flag mask
        const IOPL_MASK = 0b11 << 12;

        /// Nested Task Flag
        const NT = 1 << 14;

        /// Resume Flag
        const RF = 1 << 16;
        /// Virtual-8086 mode Flag
        const VM = 1 << 17;
        /// Alignment Check Flag
        const AC = 1 << 18;
        /// Virtual Interrupt Flag
        const VIF = 1 << 19;
        /// Virtual Interrupt Pending
        const VIP = 1 << 20;
        /// CPUID available
        const ID = 1 << 21;
    }


    /// Control Register 0 (CR0) flags
    pub struct CR0: u64 {
        /// Protected Mode Enable: When set, CPU is in protected mode.
        const PE = 1 << 0;
        /// Monitor Co-Processor: Controls interaction of WAIT/FWAIT 
        /// instructions with TS flag in CR0.
        const MP = 1 << 1;
        /// Emulation: When set, no x87 floating-point unit present, else 
        /// when clear, x87 FPU present.
        const EM = 1 << 2;
        /// Task Switched: Allows saving x87 task context upon a task switch 
        /// only after x87 instruction used.
        const TS = 1 << 3;
        /// Extension Type: On the 386, it allowed to specify whether the 
        /// external math coprocessor was an 80287 or 80387
        const ET = 1 << 4;
        /// Numeric Error: When set, enables internal x87 floating point error 
        /// reporting, else when clear, enables PC style x87 error detection.
        const NE = 1 << 5;

        /// Write Protect: When set, enables read-only protection for pages 
        /// for priviledge level zero.
        const WP = 1 << 16;
        /// Alignment Mask: Performs alignment checks if: AM set, EFLAGS.AC 
        /// flag set, and privilege level is three.
        const AM = 1 << 18;
        /// Not write-through: Globally enables/disables write-through caching.
        const NW = 1 << 29;
        /// Cache disable: Globally enables/disables the memory cache.
        const CD = 1 << 30;
        /// Paging: When set, paging is enabled.
        const PG = 1 << 31;
    }

    /// Control Register 4 (CR4) flags
    pub struct CR4: u64 {
        /// Virtual 8086 Mode Extensions: When set, enables support for the 
        /// virtual interrupt flag (VIF) in virtual-8086 mode.
        const VME = 1 << 0;	
        /// Protected-mode Virtual Interrupts: When set, enables support for 
        /// the virtual interrupt flag (VIF) in protected mode.
        const PVI = 1 << 1;	
        /// Time Stamp Disable: When set, RDTSC instruction can only be executed 
        /// when in ring 0, otherwise RDTSC can be used at any privilege level.
        const TSD = 1 << 2;	
        /// Debugging Extensions: When set, enables debug register based breaks 
        /// on I/O space access.
        const DE = 1 << 3;
        /// Page Size Extension: When set, page size is increased to 4 MiB. 
        /// Ignored in long mode or when PAE is set.
        const PSE = 1 << 4;
        /// Physical Address Extension: When set, changes page table layout to 
        /// translate 32-bit virtual addresses into extended 36-bit physical 
        /// addresses.
        const PAE = 1 << 5;
        /// Machine Check Exception: When set, enables machine check interrupts 
        /// to occur.
        const MCE = 1 << 6;
        /// Page Global Enabled: When set, address translations may be shared 
        /// between address spaces.
        const PGE = 1 << 7;
        /// Performance-Monitoring Counter enable: When set, RDPMC can be 
        /// executed at any privilege level, else RDPMC can only be used in 
        /// ring 0.
        const PCE = 1 << 8;
        /// Operating system support for FXSAVE and FXRSTOR instructions:
        /// When set, enables Streaming SIMD Extensions (SSE) instructions 
        /// and fast FPU save & restore.
        const OSFXSR = 1 << 9;
        /// Operating System Support for Unmasked SIMD Floating-Point 
        /// Exceptions: When set, enables unmasked SSE exceptions.
        const OSXMMEXCPT = 1 << 10;
        /// User-Mode Instruction Prevention: When set, the SGDT, SIDT, 
        /// SLDT, SMSW and STR instructions cannot be executed if CPL > 0.
        const UMIP = 1 << 11;
        /// 57-Bit Linear Addresses: When set, enables 5-Level Paging. 
        /// Available on certain Intel chips only.
        const LA57 = 1 << 12;
        /// Virtual Machine Extensions Enable
        const WMXE = 1 << 13;
        /// Safer Mode Extensions Enable
        const SMXE = 1 << 14;

        /// Enables the instructions RDFSBASE, RDGSBASE, WRFSBASE, and WRGSBASE.
        const FSGSBASE = 1 << 16;
        /// PCID Enable: When set, enables process-context identifiers (PCIDs).
        const PCIDE = 1 << 17;
        /// XSAVE and Processor Extended States Enable
        const OSXSAVE = 1 << 18;

        /// Supervisor Mode Execution Protection Enable: When set, execution 
        /// of code in a higher ring generates a fault.
        const SMEP = 1 << 20;
        /// Supervisor Mode Access Prevention Enable: When set, access of data 
        /// in a higher ring generates a fault.
        const SMAP = 1 << 21;
        /// Protection Key Enable
        const PKE = 1 << 22;
        /// Control-flow Enforcement Technology
        const CET = 1 << 23;
        /// Enable Protection Keys for Supervisor-Mode Pages
        /// When set, each supervisor-mode linear address is associated with 
        /// a protection key when 4-level or 5-level paging is in use.
        const PKS = 1 << 24;
    }

    /// Extended Feature Enable Register (EFER) flags
    pub struct EFER: u64 {
        /// System Call Extentions
        const SCE = 1 << 0;
        /// Long Mode Enable
        const LME = 1 << 8;
        /// Long Mode Active
        const LMA = 1 << 10;
        /// No-Execute Enable
        const NXE = 1 << 11;
        /// Secure Virtual Machine Enable
        const SVME  = 1 << 12;
        /// Long Mode Segment Limit Enable
        const LMSLE  = 1 << 13;
        /// Fast FXSAVE/FXRSTOR
        const FFXSR = 1 << 14;
        /// Translation Cache Extension
        const TCE = 1 << 15;
    }
}

#[macro_export]
macro_rules! disable_wp {
    { $b:block } => {
        let cr0 = amd64::registers::CR0::read();
        (cr0 & !amd64::registers::CR0::WP).write();

        { $b }

        cr0.write();
    };
}

impl RFLAGS {
    pub fn from_iopl(pl: crate::PrivLvl) -> Self {
        unsafe {
            Self::from_bits_unchecked(
                (pl as u64) << RFLAGS::IOPL_MASK.bits.trailing_zeros()
            )
        }
    }

    pub fn read() -> Self {
        let rflags: u64;
        unsafe {
            asm!("pushfq", "pop {}", out(reg) rflags, options(preserves_flags));
            Self::from_bits_unchecked(rflags)
        }
    }

    /// # Safety:
    /// Make absolutely sure you know what you're doing.
    /// For instance, do not set DF during Rust code execution.
    pub unsafe fn write(self) {
        asm!("push {}", "popfq", in(reg) self.bits, options(readonly));
    }

    
    pub fn get_iopl(self) -> crate::PrivLvl {
        crate::PrivLvl::from_bits((
            (self.bits & RFLAGS::IOPL_MASK.bits)
            >> RFLAGS::IOPL_MASK.bits.trailing_zeros()
        ) as u8)
    }
}
impl CR0 {
    pub fn read() -> Self {
        let cr0: u64;
        unsafe {
            asm!("mov {}, cr0", out(reg) cr0, options(nomem, nostack, preserves_flags));
            Self::from_bits_unchecked(cr0)
        }
    }

    /// # Safety:
    /// Caller must gurantee that the new system behaviour as a consequence of setting 
    /// CR0 will not violate memory safety, or otherwise cause erroneous behaviour.
    pub unsafe fn write(self) {
        asm!("mov cr0, {}", in(reg) self.bits, options(nomem, nostack, preserves_flags));
    }
}
impl CR4 {
    pub fn read() -> Self {
        let cr4: u64;
        unsafe {
            asm!("mov {}, cr4", out(reg) cr4, options(nomem, nostack, preserves_flags));
            Self::from_bits_unchecked(cr4)
        }
    }

    /// # Safety:
    /// Caller must gurantee that the new system behaviour as a consequence of setting 
    /// CR4 will not violate memory safety, or otherwise cause erroneous behaviour.
    pub unsafe fn write(cr4: CR4) {
        asm!("mov cr4, {}", in(reg) cr4.bits, options(nomem, nostack, preserves_flags));
    }
}



/// Control Register 2 (CR2) contains the Page Fault Linear Address (PFLA) when a page fault occurs.
pub fn cr2_read() -> *const u8 {
    let cr2: *const u8;
    unsafe {
        asm!("mov {}, cr2", out(reg) cr2, options(nomem, nostack, preserves_flags));
    }
    cr2
}

bitflags::bitflags! {
    pub struct CR3Flags: usize {
        /// PML4 Page Write Through.
        const PWT = 1 << 3;
        /// PML4 Page Cache-Disable.
        const PCD = 1 << 4;
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CR3Data {
    /// Page Write Through (PWT) and Page Cache-Disable (PCD) flags.
    Flags(CR3Flags),
    /// 12-bit Process Context Identifier.
    PCID(usize),
}
/// Control Register 3 (CR3) contains the Page Map Level 4 (PML4) 
/// physical address when paging is enabled. As well as either the PCID, 
/// or PML4 Page Write-Through (PWT) and Page Cache-Disable (PCD) flags.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CR3 {
    pub data: CR3Data,
    pub paddr: usize,
}

impl CR3 {
    const PCID_MASK: usize = 0o777;

    /// Sets CR3 given the given physical address, no PCID, and no flags set.
    /// ### Safety:
    /// See `CR3::write`.
    pub unsafe fn set_nflags(pml4_paddr: usize) {
        CR3 { data: CR3Data::Flags(CR3Flags::empty()), paddr: pml4_paddr }.write()
    }

    /// Reads the CR3.
    pub fn read() -> Self {
        let paddr_mask = crate::paging::PTE::BASE_MASK.bits();
        let pcide = CR4::read().contains(CR4::PCIDE);

        let cr3: usize;
        unsafe {
            asm!(
                "mov {}, cr3",
                out(reg) cr3, 
                options(nomem, nostack, preserves_flags)
            );
        }
        
        Self {
            data: match pcide {
                true => CR3Data::PCID(cr3 & Self::PCID_MASK),
                false => unsafe { CR3Data::Flags( 
                    CR3Flags::from_bits_unchecked(cr3 & !paddr_mask)
                ) }
            },
            paddr: cr3 & paddr_mask,
        }
    }

    /// Writes to the CR3 register and configures `CR4::PCIDE`.
    /// # Safety:
    /// Caller must gurantee that the new system behaviour as a consequence after 
    /// setting CR3 will not violate memory safety, or otherwise cause erroneous/
    /// undefined behaviour.
    pub unsafe fn write(self) {
        let cr4 = CR4::read();
        let pcid_enabled = cr4.contains(CR4::PCIDE);

        let cr3;
        match self.data {
            CR3Data::PCID(pcid) => {
                cr3 = self.paddr | pcid & Self::PCID_MASK;
                if !pcid_enabled {
                    // enable PCIDE
                    CR4::write(cr4 | CR4::PCIDE);
                }
            },
            CR3Data::Flags(flags) => {
                cr3 = self.paddr | flags.bits();
                if pcid_enabled {
                    // clear PCID, else #GP occurs on disable
                    core::arch::asm!(
                        "mov rax, cr3",
                        "and rax, {}", // clear PCID [0:11]
                        "mov cr3, rax",
                        in(reg) (!Self::PCID_MASK),
                        options(nomem, nostack, preserves_flags)
                    );
                    CR4::write(cr4 & !CR4::PCIDE);
                }
            }
        }
        
        asm!(
            "mov cr3, {}",
            in(reg) cr3,
            options(nostack, preserves_flags)
        );
    }

    /// Reload the CR3, wiping the local TLB cache.
    pub fn reload() {
        unsafe {
            core::arch::asm!(
                "mov rax, cr3",
                "mov cr3, rax",
                options(nomem, nostack, preserves_flags)
            );
        }
    }

    /// Return a linear address to the PML4.
    /// ### Safety:
    /// This function assumes identity-offset mapping.
    #[inline]
    pub unsafe fn get_laddr_offset(&self, offset: isize) -> *mut [crate::paging::PTE] {
        core::ptr::slice_from_raw_parts_mut(
            (self.paddr as isize + offset) as *mut _, 
            512
        )
    }
}



pub fn rdmsr(msr: u64) -> u64 {
    let (high, low): (u64, u64);
    unsafe {
        asm!(
            "rdmsr",
            in("ecx") msr,
            out("eax") low, 
            out("edx") high,
            options(nomem, nostack, preserves_flags),
        );
    }
    (high as u64) << 32 | low as u64
}
pub fn wrmsr(msr: u64, data: u64) {
    let (high, low): (u64, u64) = ((data >> 32) as u64, data as u64);
    unsafe {
        asm!(
            "wrmsr",
            in("ecx") msr,
            in("eax") low, 
            in("edx") high,
            options(nostack, preserves_flags),
        );
    }
}
