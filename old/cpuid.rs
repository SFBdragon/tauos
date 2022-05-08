use core::{
    arch::x86_64::{__cpuid, __cpuid_count},
    num::{
        NonZeroU8,
        NonZeroU32
    },
    fmt::Debug
};


pub static CPUID: spin::Lazy<CpuId> = spin::Lazy::new(|| CpuId::read());

#[derive(Clone, Copy, PartialEq, Eq)]
pub struct CpuId {
    pub max_std_func: u32,
    pub max_ext_func: u32,
    pub vendor_string: [u8; 12],
    
    pub feature_info: Option<FeatureInfo>,
    pub monitor_info: Option<MonitorInfo>,
    pub frequency_info: Option<FrequencyInfo>,
    pub struct_ext_feat_info: Option<StructExtFeatInfo>,
    pub topology_info: Option<TopologyInfo>,
    
    pub ext_feature_info: Option<ExtFeatureInfo>,
    pub processor_name: Option<ProcesssorName>,
    pub l1_tlb_cache_info: Option<L1TlbCacheInfo>,
    pub l2_tlb_l3_cache_info: Option<L2TlbL3CacheInfo>,
    pub power_ras_info: Option<PowerInfo>,
    pub capacity_info: Option<CapacityInfo>,
    pub svm_info: Option<SvmInfo>,
    pub tlb_1gb_cache_info: Option<Tlb1GbCacheInfo>,
    pub instr_opt_info: Option<InstrOptsInfo>,
    pub ibs_info: Option<IbsInfo>,
}

impl CpuId {
    pub fn read() -> Self {
        // Safety: CPUID is supported by all AMD64 processors.
        let std_f0 = unsafe { __cpuid(0) };
        // Safety: eax should give a value < 0x8000_0000 if unsupported
        let ext_f0_eax = unsafe { __cpuid(0x8000_0000).eax };

        Self {
            max_std_func: std_f0.eax,
            max_ext_func: ext_f0_eax,
            // Safety: AMD64 CPUs are little endian
            vendor_string: unsafe {
                core::mem::transmute([
                    std_f0.ebx,
                    std_f0.ecx,
                    std_f0.edx
                ])
            },

            feature_info: FeatureInfo::read(),
            monitor_info: MonitorInfo::read(),
            frequency_info: FrequencyInfo::read(),
            struct_ext_feat_info: StructExtFeatInfo::read(),
            topology_info: TopologyInfo::read(),
            
            ext_feature_info: ExtFeatureInfo::read(),
            processor_name: ProcesssorName::read(),
            l1_tlb_cache_info: L1TlbCacheInfo::read(),
            l2_tlb_l3_cache_info: L2TlbL3CacheInfo::read(),
            power_ras_info: PowerInfo::read(),
            capacity_info: CapacityInfo::read(),
            svm_info: SvmInfo::read(),
            tlb_1gb_cache_info: Tlb1GbCacheInfo::read(),
            instr_opt_info: InstrOptsInfo::read(),
            ibs_info: IbsInfo::read(),
        }
    }

    pub fn vendor_as_str(&self) -> &str {
        core::str::from_utf8(&self.vendor_string).unwrap_or("Invalid wendor string.")
    }
}
impl Debug for CpuId {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("CpuId")
            .field("max_std_func", &self.max_std_func)
            .field("max_ext_func", &self.max_ext_func)
            .field("vendor_string", &self.vendor_as_str())
            .field("feature_info", &self.feature_info)
            .field("monitor_info", &self.monitor_info)
            .field("frequency_info", &self.frequency_info)
            .field("struct_ext_feat_info", &self.struct_ext_feat_info)
            .field("topology_info", &self.topology_info)
            .field("ext_feature_info", &self.ext_feature_info)
            .field("processor_name", &self.processor_name)
            .field("l1_tlb_cache_info", &self.l1_tlb_cache_info)
            .field("l2_tlb_l3_cache_info", &self.l2_tlb_l3_cache_info)
            .field("power_ras_info", &self.power_ras_info)
            .field("capacity_info", &self.capacity_info)
            .field("svm_info", &self.svm_info)
            .field("tlb_1gb_cache_info", &self.tlb_1gb_cache_info)
            .field("instr_opt_info", &self.instr_opt_info)
            .field("ibs_info", &self.ibs_info)
            .finish()
    }
}


/// Performs the CPUID instruction, returning the contents of
/// `(eax, ebx, ecx, edx)` thereafter respectively.
/// 
/// Note that some of the returned values may be undefined or
/// reserved, refer to relevent specification for details.
/// 
/// Returns `None` where the CPU explicitly does not support the function. 
/// Determination thereof is done through  comparing the output in EAX after 
/// flooring to a multiple of 0x4000_0000 to `in_eax`. 
pub fn cpuid(in_eax: u32, in_ecx: u32) -> Option<(u32, u32, u32, u32)> {
    // Masks to:
    // 0x0         (standard),
    // 0x4000_0000 (hypervisor),
    // 0x8000_0000 (extended),
    // 0xC000_0000 (reserved)
    if in_eax > unsafe { __cpuid(in_eax & 0xC000_0000) }.eax {
        None
    } else {
        // Safety: confirmed that this CPU supports the in_eax function
        let result = unsafe { __cpuid_count(in_eax, in_ecx) };
        Some((result.eax, result.ebx, result.ecx, result.edx))
    }
}

/// Extract out the processor `(family, model, stepping)` from CPUID formatting into seperate fields.
#[inline]
pub fn extract_family_model_stepping(eax: u32) -> (u8, u8, u8) {
    let family_lo = (eax >> 8) as u8 & 0xf;
    let model_lo = (eax >> 4) as u8 & 0xf;
    (
        // ExtFamily is reserved if family_lo != 0xf
        if family_lo == 0xf { family_lo + (eax >> 20) as u8 } else { family_lo },
        // ExtModel is reserved if family_lo != 0xf
        if family_lo == 0xf { model_lo | (eax >> 16 - 4) as u8 & 0xf0 } else { model_lo },
        (eax >> 0) as u8 & 0xf,
    )
}

bitflags::bitflags! {
    /// CPUID Function 1 - ECX return value: Miscellaneous Feature Identifiers.
    pub struct StdFn1ECX: u32 {
        /// SSE3 instruction support.
        const SSE3 = 1 << 0;
        /// PCLMULQDQ instruction support.
        const PCLMULQDQ = 1 << 1;
        /// MONITOR/MWAIT instruction support.
        const MONITOR = 1 << 3;
        /// Supplemental SSE3 instruction support.
        const SSSE3 = 1 << 9;
        /// FMA instruction support. 
        const FMA = 1 << 12;
        /// CMPXCHG16B instruction support. 
        const CMPXCHG16B = 1 << 13;
        /// SSE4.1 instruction support.
        const SSE41 = 1 << 19;
        /// SSE4.2 instruction support.
        const SSE42 = 1 << 20;
        /// x2Apic support.
        const X2APIC = 1 << 21;
        /// MOVBE instruction support.
        const MOVBE = 1 << 22;
        /// POPCNT instruction support.
        const POPCNT = 1 << 23;
        /// AES instruction support.
        const AES = 1 << 25;
        /// XSAVE (and related) hardware instruction support.
        const XSAVE = 1 << 26;
        /// XSAVE (and related) instructions are enabled.
        const OSXSAVE = 1 << 27;
        /// AVX instruction support.
        const AVX = 1 << 28;
        /// Half-precision convert instruction support. 
        const F16C = 1 << 29;
        /// RDRAND instruction support.
        const RDRAND = 1 << 30;
        /// Hypervisor/Guest status (always zero on physical CPUs).
        const HYPERVISOR = 1 << 31;
    }

    /// CPUID Function 1 - EDX return value: Miscellaneous Feature Identifiers.
    pub struct StdFn1EDX: u32 {
        /// x87 floating point unit on-chip.
        const FPU          = 1 << 0;
        /// Virtual-mode enhancements. CR4.VME, CR4.PVI, software interrupt indirection,
        /// expansion of the TSS with the software, indirection bitmap, EFLAGS.VIF, EFLAGS.VIP.
        const VME          = 1 << 1;
        /// Debugging extensions.
        const DE           = 1 << 2;
        /// Page-size extensions.
        const PSE          = 1 << 3;
        /// Time stamp counter. RDTSC and RDTSCP instruction support.
        const TSC          = 1 << 4;
        /// Model-specific registers. RDMSR and WRMSR instruction support.
        const MSR          = 1 << 5;
        /// Physical-address extensions.
        const PAE          = 1 << 6;
        /// Machine check exception.
        const MCE          = 1 << 7;
        /// CMPXCHG8B instruction support.
        const CMPXCHG8B    = 1 << 8;
        /// Avanced programmable interrupt controller. Indicates APIC exists and is enabled.
        const APIC         = 1 << 9;
        /// SYSENTER and SYSEXIT instruction support.
        const SYSENTEREXIT = 1 << 11;
        /// Memory-type range registers. 
        const MTRR         = 1 << 12;
        /// Page global extension. 
        const PGE          = 1 << 13;
        /// Machine check architecture.
        const MCA          = 1 << 14;
        /// Conditional move instruction support. 
        const CMOV         = 1 << 15;
        /// Page attribute table. 
        const PAT          = 1 << 16;
        /// Page-size extensions. The PDE[20:13] supplies physical address [39:32]. 
        const PSE36        = 1 << 17;
        /// CLFLUSH instruction support.
        const CFLSH        = 1 << 19;
        /// MMX instructions.
        const MMX          = 1 << 23;
        /// FXSAVE and FXRSTOR instruction support.
        const FXSR         = 1 << 24;
        /// SSE instruction support.
        const SSE          = 1 << 25;
        /// SSE2 instruction support.
        const SSE2         = 1 << 26;
        /// Hyper-threading technology. Indicates either that there is more than one
        /// thread per core or more than one core per compute unit.
        const HTT          = 1 << 28;
    }
}
/// Processor and Processor Feature Identifiers. Return data of CPUID function 1.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FeatureInfo {
    /// Processor family.
    pub family: u8,
    /// Processor model.
    pub model: u8,
    /// Processor revision.
    pub stepping: u8,

    /// 8-bit brand ID, can be used in conjuction with CPUID Fn8000_0001_EBX[BrandId] 
    /// to generate the processor name string.
    pub brand_id_8bit: u8,
    /// Specifies the size of a cache line in quadwords flushed by the CLFLUSH instruction. 
    pub clflush_size: u8,
    /// Indicated number of logical processors per package if `edx_misc_features[HTT]` is set, else is `None`.
    pub logical_processor_count: Option<u8>,
    /// Initial local APIC physical ID. The 8-bit value assigned to the local APIC physical ID register at power-up.
    /// Some of the bits of LocalApicId represent the core within a processor and other bits represent the processor ID.
    pub local_apic_id: u8,

    /// Miscellaneous Feature Identifiers returned in ECX.
    pub ecx_misc_features: StdFn1ECX,
    /// Miscellaneous Feature Identifiers returned in EDX.
    pub edx_misc_features: StdFn1EDX,
}
impl FeatureInfo {
    /// Performs CPUID function 1 and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, edx) = cpuid(1, 0)?;
        let (family, model, stepping) = extract_family_model_stepping(eax);
        let ecx_mfi = StdFn1ECX::from_bits_truncate(ecx);
        let edx_mfi = StdFn1EDX::from_bits_truncate(edx);

        Some(
            Self {
                family,
                model,
                stepping,

                brand_id_8bit:           (ebx >>  0) as u8,
                clflush_size:            (ebx >>  8) as u8,
                logical_processor_count: if edx_mfi.contains(StdFn1EDX::HTT) { Some((ebx >> 16) as u8) } else { None },
                local_apic_id:           (ebx >> 24) as u8,

                ecx_misc_features: ecx_mfi,
                edx_misc_features: edx_mfi,
            }
        )
    }
}

/// MONITOR/MWAIT Features. Return data of CPUID function 5.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct MonitorInfo {
    ///  Smallest monitor-line size in bytes.
    mon_line_size_min: u16,
    ///  Largest monitor-line size in bytes.
    mon_line_size_max: u16,
    /// Interrupt break-event. Indicates MWAIT can use ECX bit 0 to allow interrupts to 
    /// cause an exit from the monitor event pending state, even if `EFLAGS::IF` is not set. 
    interrupt_break_event: bool,
    /// Indicates whether enumeration of MONITOR/MWAIT extensions is supported.
    extentions_enumerable: bool,
}
impl MonitorInfo {
    /// Performs CPUID function 5, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, _) = cpuid(5, 0)?;

        Some(
            Self {
                mon_line_size_min: eax as u16,
                mon_line_size_max: ebx as u16,
                extentions_enumerable: ecx & 1 << 0 != 0,
                interrupt_break_event: ecx & 1 << 1 != 0,
            }
        )
    }
}

/// Local APIC timer timebase and the effective frequency interface for the processor.
/// Return data of CPUID function 6.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FrequencyInfo {
    /// If set, indicated that the timebase for the local APIC timer is not affected by processor p-state.
    arat: bool,
    /// Effective frequency interface support. If set, indicates presence of MSR E7 (MPERF) and MSR E8 (APERF).
    effective_frequency: bool,
}
impl FrequencyInfo {
    /// Performs CPUID function 6, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        // Safety: caller guaranteed
        let (eax, _, ecx, _) = cpuid(6, 0)?;

        Some(
            Self {
                arat: eax & 1 << 2 != 0,
                effective_frequency: ecx & 1 << 0 != 0,
            } 
        )
    }
}

bitflags::bitflags! {
    /// CPUID Function 7, Subfunction 0 - EBX return value: Structured Extended Feature Identifiers.
    pub struct CpuIdFn7Sfn0EBX: u32 {
        /// FS and GS base read/write instruction support.
        const FSGSBASE = 1 << 0;
        /// Bit manipulation group 1 instruction support.
        const BMI1 = 1 << 3;
        /// AVX2 instruction subset support.
        const AVX2 = 1 << 5;
        /// Supervisor mode execution prevention.
        const SMEP = 1 << 7;
        /// Bit manipulation group 2 instruction support.
        const BMI2 = 1 << 8;
        /// INVPCID instruction support. 
        const INVPCID = 1 << 10;
        /// RDSEED instruction support.
        const RDSEED = 1 << 18;
        /// ADCX and ADOX instruction support.
        const ADX = 1 << 19;
        /// Supervisor mode access prevention.
        const SMAP = 1 << 20;
        /// RDPID instruction and TSC_AUX MSR support.
        const RDPID = 1 << 22;
        /// CLFLUSHOPT instruction support.
        const CLFLUSHOPT = 1 << 23;
        /// CLWB instruction support.
        const CLWB = 1 << 24;
        /// Secure Hash Algorithm instruction extension.
        const SHA = 1 << 29;
    }

    /// CPUID Function 7, Subfunction 0 - ECX return value: Structured Extended Feature Identifiers.
    pub struct CpuIdFn7Sfn0ECX: u32 {
        /// User mode instruction prevention support.
        const UMPI = 1 << 2;
        /// Memory Protection Keys supported. 
        const PKU = 1 << 3;
        /// Memory Protection Keys and use of the RDPKRU/WRPKRU instructions by setting CR4::PKE is enabled. 
        const OSPKE = 1 << 4;
        /// Shadow Stacks supported.
        const CET_SS = 1 << 7;
        /// Support for VAES 256-bit instructions.
        const VAES = 1 << 9;
        /// Support for VPCLMULQDQ 256-bit instruction.
        const VPCMULQDQ = 1 << 10;
    }
}
/// Structured Extended Feature Identifiers. Return data of CPUID function 7.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct StructExtFeatInfo {
    // sub function zero:
    /// The number of subfunctions of CPUID function 7 supported.
    pub max_sub_func: u32,
    /// Structured Extended Feature Identifiers returned in EBX for subfunction zero.
    pub ebx_sefi_features: CpuIdFn7Sfn0EBX,
    /// Structured Extended Feature Identifiers returned in ECX for subfunction zero.
    pub ecx_sefi_features: CpuIdFn7Sfn0ECX,
}
impl StructExtFeatInfo {
    /// Performs CPUID function 7, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        // Safety: caller guaranteed
        let (eax, ebx, ecx, _) = cpuid(7, 0)?;

        Some(
            Self {
                max_sub_func: eax,
                ebx_sefi_features: CpuIdFn7Sfn0EBX::from_bits_truncate(ebx),
                ecx_sefi_features: CpuIdFn7Sfn0ECX::from_bits_truncate(ecx),
            }
        )
    }
}

/// Extended Topology Enumeration. Return data of CPUID function B.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct TopologyInfo {
    // Thread level topology, subfunction 0.
    pub thread_level: Option<ThreadTopologyInfo>,
    // Core level topology, subfunction 1.
    pub core_level: Option<CoreTopologyInfo>,
}
/// Thread Level Topology Information. Return data of CPUID function B, subfunction 0.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ThreadTopologyInfo {
    /// 32-bit Extended APIC_ID.
    pub x2_apic_id: u32,

    /// Number of bits to shift x2APIC_ID right to get to the topology ID of the next level.
    pub thread_mask_width: u8,
    /// Number of threads in a core.
    pub threads_per_core: u16,
}
/// Core Level Topology Information. Return data of CPUID function B, subfunction 1.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CoreTopologyInfo {
    /// 32-bit Extended APIC_ID.
    pub x2_apic_id: u32,

    /// Number of bits to shift x2APIC_ID right to get to the topology ID of the next level.
    pub core_mask_width: u8,
    /// Number of logical cores in socket.
    pub logical_core_count: u16,
}
impl TopologyInfo {
    /// Performs CPUID function B and returns the rendered data.
    /// ## Safety:
    /// The largest supported standard CPUID function must be `>= 0xB`.
    pub fn read() -> Option<Self> {
        // Safety: caller guaranteed, unsupported subfunctions yield zeroes
        let (eax_0, ebx_0, ecx_0, edx_0) = cpuid(0xB, 0)?;
        let (eax_1, ebx_1, ecx_1, edx_1) = cpuid(0xB, 1)?;

        Some(
            Self {
                thread_level: if ecx_0 & 0xff == 0 | 1 << 8 {
                    Some(ThreadTopologyInfo {
                        x2_apic_id: edx_0,
                        thread_mask_width: eax_0 as u8,
                        threads_per_core: ebx_0 as u16,
                    })
                } else {
                    None
                },
                core_level: if ecx_1 & 0xff == 1 | 2 << 8 {
                    Some(CoreTopologyInfo {
                        x2_apic_id: edx_1,
                        core_mask_width: eax_1 as u8,
                        logical_core_count: ebx_1 as u16,
                    })
                } else {
                    None
                }
            }
        )
    }
}

/// Processor Extended State Enumeration. Return data of CPUID function D.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ExtStateInfo {
    
}
impl ExtStateInfo {
    /// Performs CPUID function 0xD, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        return None;

        todo!();
    }
}


bitflags::bitflags! {
    /// CPUID Extended Function 0x8000_0001 - ECX return value: Miscellaneous Feature Identifiers.
    pub struct ExtFn1ECX: u32 {
        /// LAHF and SAHF instruction support in 64-bit mode.
        const LAHFSAHF       = 1 << 0;
        /// Core multi-processing legacy mode.
        const CMPLEGACY      = 1 << 1;
        /// Secure virtual machine. 
        const SVM            = 1 << 2;
        /// Extended APIC space. This bit indicates the presence of extended APIC register space starting at
        /// offset 400h from the “APIC Base Address Register,” as specified in the BKDG. 
        const EXTAPIC        = 1 << 3;
        /// LOCK MOV CR0 means MOV CR8.
        const ALTMOVCR8      = 1 << 4;
        /// Advanced bit manipulation. LZCNT instruction support.
        const ABM            = 1 << 5;
        /// EXTRQ, INSERTQ, MOVNTSS, and MOVNTSD instruction support.
        const SSE4A          = 1 << 6;
        /// Misaligned SSE mode. 
        const MISALIGNSSE    = 1 << 7;
        /// PREFETCH and PREFETCHW instruction support.
        const _3DNOWPREFETCH = 1 << 8;
        /// OS visible workaround support. 
        const OSVW           = 1 << 9;
        /// Instruction based sampling.
        const IBS            = 1 << 10;
        /// Extended operation support.
        const XOP            = 1 << 11;
        /// SKINIT and STGI are supported. 
        const SKINIT         = 1 << 12;
        /// Watchdog timer support.
        const WDT            = 1 << 13;
        /// Lightweight profiling support.
        const LWP            = 1 << 14;
        /// Four-operand FMA instruction support.
        const FMA4           = 1 << 16;
        /// Translation Cache Extension support.
        const TCE            = 1 << 17;
        /// Trailing bit manipulation instruction support. 
        const TBM            = 1 << 21;
        /// Topology extensions support.
        const TOPEXT         = 1 << 22;
        /// Processor performance counter extensions support.
        const PERFCTR_CORE   = 1 << 23;
        /// NB performance counter extensions support.
        const PERFCTR_NB     = 1 << 24;
        /// Data access breakpoint extension.
        const DBX            = 1 << 26;
        /// Performance time-stamp counter support. 
        const PERFTSC        = 1 << 27;
        /// L3 performance counter extension support.
        const PERFCTR_LLC    = 1 << 28;
        /// MWAITX and MONITORX instruction support. 
        const MONITORX       = 1 << 29;
        /// Breakpoint Addressing masking extended to bit 31.
        const ADDR_MASK_EXT  = 1 << 30;
    }

    /// CPUID Extended Function 0x8000_0001 - EDX return value: Miscellaneous Feature Identifiers.
    pub struct ExtFn1EDX: u32 {
        /// x87 floating point unit on-chip.
        const FPU          = 1 << 0;
        /// Virtual-mode enhancements. CR4.VME, CR4.PVI, software interrupt indirection,
        /// expansion of the TSS with the software, indirection bitmap, EFLAGS.VIF, EFLAGS.VIP.
        const VME          = 1 << 1;
        /// Debugging extensions.
        const DE           = 1 << 2;
        /// Page-size extensions.
        const PSE          = 1 << 3;
        /// Time stamp counter. RDTSC and RDTSCP instruction support.
        const TSC          = 1 << 4;
        /// Model-specific registers. RDMSR and WRMSR instruction support.
        const MSR          = 1 << 5;
        /// Physical-address extensions.
        const PAE          = 1 << 6;
        /// Machine check exception.
        const MCE          = 1 << 7;
        /// CMPXCHG8B instruction support.
        const CMPXCHG8B    = 1 << 8;
        /// Avanced programmable interrupt controller. Indicates APIC exists and is enabled.
        const APIC         = 1 << 9;
        /// SYSCALL and SYSENTER instruction support.
        const SYSCALLRET   = 1 << 11;
        /// Memory-type range registers. 
        const MTRR         = 1 << 12;
        /// Page global extension. 
        const PGE          = 1 << 13;
        /// Machine check architecture.
        const MCA          = 1 << 14;
        /// Conditional move instruction support. 
        const CMOV         = 1 << 15;
        /// Page attribute table. 
        const PAT          = 1 << 16;
        /// Page-size extensions. The PDE[20:13] supplies physical address [39:32]. 
        const PSE36        = 1 << 17;
        /// No-execute page protection.
        const NX           = 1 << 20;
        /// AMD extensions to MMX instructions.
        const MMXEXT       = 1 << 22;
        /// MMX instructions.
        const MMX          = 1 << 23;
        /// FXSAVE and FXRSTOR instruction support.
        const FXSR         = 1 << 24;
        /// FXSAVE and FXRSTOR instruction optimizations.
        const FFXSR = 1 << 25;
        /// 1-GB large page support.
        const HPDPE = 1 << 26;
        /// RDTSCP instruction support.
        const RDTSCP = 1 << 27;
        /// Long mode support.
        const LM = 1 << 28;
        /// AMD extensions to 3DNow! instructions.
        const _3DNOWEXT = 1 << 30;
        /// 3DNow! instruction support.
        const _3DNOW = 1 << 31;
    }
}
/// Extended Processor and Processor Feature Identifiers. Return data of CPUID function 0x8000_0001.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ExtFeatureInfo {
    /// Processor family.
    pub family: u8,
    /// Processor model.
    pub model: u8,
    /// Processor revision.
    pub stepping: u8,

    /// Extended processor brand ID used in conjuction with that of CPUID Standard Function 0x1.
    pub brand_id: u16,
    pub pkg_type: Option<u8>,

    /// Miscellaneous feature identifiers returned in ECX.
    pub ecx_misc_features: ExtFn1ECX,
    /// Miscellaneous feature identifiers returned in EDX.
    pub edx_misc_features: ExtFn1EDX,
}
impl ExtFeatureInfo {
    /// Performs CPUID function 0x8000_0001, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, edx) = cpuid(0x8000_0001, 0)?;
        let (family, model, stepping) = extract_family_model_stepping(eax);

        Some(
            Self {
                family,
                model,
                stepping,
    
                brand_id: ebx as u16,
                pkg_type: if family > 0x10 { Some((ebx >> 28) as u8) } else { None },
    
                ecx_misc_features: ExtFn1ECX::from_bits_truncate(ecx),
                edx_misc_features: ExtFn1EDX::from_bits_truncate(edx),
            }
        )
    }

    /// Tests if the feature flag(s) in the ECX returns of CPUID Extended Function 0x8000_0001 is set.
    /// Returns false if Function 0x8000_0001 is not supported.
    pub fn test_ecx_flags(flags: ExtFn1ECX) -> bool {
        if let Some((_, _, ecx, _)) = cpuid(0x8000_0001, 0) {
            ExtFn1ECX::from_bits_truncate(ecx).contains(flags)
        } else {
            false
        }
    }
    /// Tests if the feature flag(s) in the EDX returns of CPUID Extended Function 0x8000_0001 is set.
    /// Returns false if Function 0x8000_0001 is not supported.
    pub fn test_edx_flags(flags: ExtFn1EDX) -> bool {
        if let Some((_, _, _, edx)) = cpuid(0x8000_0001, 0) {
            ExtFn1EDX::from_bits_truncate(edx).contains(flags)
        } else {
            false
        }
    }
}

/// Extended Processor Name Null-Terminated String. Return data of CPUID function 0x8000_000{2,3,4}.
#[derive(Clone, Copy, PartialEq, Eq)]
pub struct ProcesssorName([u8; 48]);
impl ProcesssorName {
    /// Performs CPUID function 0x8000_000{2,3,4}, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax_2, ebx_2, ecx_2, edx_2) = cpuid(0x8000_0002, 0)?;
        let (eax_3, ebx_3, ecx_3, edx_3) = cpuid(0x8000_0003, 0)?;
        let (eax_4, ebx_4, ecx_4, edx_4) = cpuid(0x8000_0004, 0)?;

        Some(
            Self(
                unsafe { // Safety: all AMD64 CPUs are little endian?
                    core::mem::transmute([
                        eax_2, ebx_2, ecx_2, edx_2,
                        eax_3, ebx_3, ecx_3, edx_3,
                        eax_4, ebx_4, ecx_4, edx_4,
                    ])
                }
            )
        )
    }

    /// Return the length of the name string before the null-terminator.
    pub fn len(&self) -> usize {
        let mut i = 0;
        for b in self.0 {
            if b == 0 {
                return i;
            } else {
                i += 1;
            }
        }
        return i;
    }

    /// Return the processor name as a Rust string.
    pub fn as_str(&self) -> &str {
        core::str::from_utf8(&self.0[0..self.len()]).unwrap_or("Invalid processor name string.").trim()
    }
}
impl Debug for ProcesssorName {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_tuple("ProcesssorName").field(&self.as_str()).finish()
    }
}

/// Cache associativity type of the L1 and TLB data and instruction caches.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CacheAssociativityL1 {
    Reserved,
    DirectMapped,
    NWayAssoc(u8),
    FullyAssoc,
}
impl CacheAssociativityL1 {
    /// Convert from CPUID 8-bit representation.
    pub fn from_bits(bits: u8) -> Self {
        if bits == 0 {
            Self::Reserved
        } else if bits == 1 {
            Self::DirectMapped
        } else if bits == 0xff {
            Self::FullyAssoc
        } else {
            Self::NWayAssoc(bits)
        }
    }

    /// Convert to CPUID 8-bit representation.
    pub fn as_bits(self) -> u8 {
        match self {
            Self::Reserved => 0,
            Self::DirectMapped => 1,
            Self::NWayAssoc(n) => n,
            Self::FullyAssoc => 0xff,
        }
    }
}
/// L1 Cache and L1 TLB Information. Return data of CPUID function 0x8000_0005.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct L1TlbCacheInfo {
    /// Instruction TLB number of entries for 2MiB pages. Number of entries for 4MiB is half this value.
    pub inst_tlbl1_2mb_size: u8,
    /// Instruction TLB associativity for 2MiB and 4MiB pages.
    pub inst_tlbl1_2mb_asso: CacheAssociativityL1,
    /// Data TLB number of entries for 2MiB pages. Number of entries for 4MiB is half this value.
    pub data_tlbl1_2mb_size: u8,
    /// Data TLB associativity for 2MiB and 4MiB pages. 
    pub data_tlbl1_2mb_asso: CacheAssociativityL1,

    /// Instruction TLB number of entries for 4KiB pages.
    pub inst_tlbl1_4kb_size: u8,
    /// Instruction TLB associativity for 4KiB pages.
    pub inst_tlbl1_4kb_asso: CacheAssociativityL1,
    /// Data TLB number of entries for 4KiB pages.
    pub data_tlbl1_4kb_size: u8,
    /// Data TLB associativity for 4KiB pages. 
    pub data_tlbl1_4kb_asso: CacheAssociativityL1,

    /// L1 data cache line size in bytes.
    pub l1dc_line_size: u8,
    /// L1 data cache lines per tag.
    pub l1dc_lines_per_tag: u8,
    /// L1 data cache associativity.
    pub l1dc_asso: CacheAssociativityL1,
    /// L1 data cache size in KB
    pub l1dc_size: u8,

    /// L1 instruction cache line size in bytes.
    pub l1ic_line_size: u8,
    /// L1 instruction cache lines per tag.
    pub l1ic_lines_per_tag: u8,
    /// L1 instruction cache associativity.
    pub l1ic_asso: CacheAssociativityL1,
    /// L1 instruction cache size in KB
    pub l1ic_size: u8,
}
impl L1TlbCacheInfo {
    /// Performs CPUID function 0x8000_0005, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, edx) = cpuid(0x8000_0005, 0)?;

        Some(
            Self {
                inst_tlbl1_2mb_size: (eax >> 00) as u8,
                inst_tlbl1_2mb_asso: CacheAssociativityL1::from_bits((eax >> 08) as u8),
                data_tlbl1_2mb_size: (eax >> 16) as u8,
                data_tlbl1_2mb_asso: CacheAssociativityL1::from_bits((eax >> 24) as u8),
    
                inst_tlbl1_4kb_size: (ebx >> 00) as u8,
                inst_tlbl1_4kb_asso: CacheAssociativityL1::from_bits((ebx >> 08) as u8),
                data_tlbl1_4kb_size: (ebx >> 16) as u8,
                data_tlbl1_4kb_asso: CacheAssociativityL1::from_bits((ebx >> 24) as u8),
    
                l1dc_line_size:      (ecx >> 00) as u8,
                l1dc_lines_per_tag:  (ecx >> 08) as u8,
                l1dc_asso:           CacheAssociativityL1::from_bits((ecx >> 16) as u8),
                l1dc_size:           (ecx >> 24) as u8,
    
                l1ic_line_size:      (edx >> 00) as u8,
                l1ic_lines_per_tag:  (edx >> 08) as u8,
                l1ic_asso:           CacheAssociativityL1::from_bits((edx >> 16) as u8),
                l1ic_size:           (edx >> 24) as u8,
            }
        )
    }
}

/// Cache associativity of L2, L3, and TLB caches.
/// 
/// Note that a cache associativity variant exists that indicates all data should be ignored,
/// including associated fields and defer to the data provided by CPUID Extended Function 0x8000_001D.
/// This variant is represented as a `None` where this type is wrapped in an `Option`, usually
/// along with its associated fields. For this reason, associated methods of this type are wrapped
/// in the `Option` type, which can be conveniently mapped to and from if needed, while preserving
/// the variant.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CacheAssociativity {
    /// Cache is disabled.
    Disabled,
    /// Cache is direct mapped.
    DirectMapped,
    /// Cache is n-way associative.
    NWayAssociative(u8),
    /// Cache is fully associative.
    FullyAssociative,
}
impl CacheAssociativity {
    /// Convert from CPUID 4-bit representation.
    pub fn from_bits(bits: u8) -> Option<Self> {
        if bits == 0 {
            Some(Self::Disabled)
        } else if bits == 1 {
            Some(Self::DirectMapped)
        } else if bits == 0xf {
            Some(Self::FullyAssociative)
        } else if bits == 9 {
            None
        } else {
            let n = match bits {
                0x2 => 2,
                0x3 => 3,
                0x4 => 4,
                0x5 => 6,
                0x6 => 8,
                0x8 => 16,
                0xA => 32,
                0xB => 48,
                0xC => 64,
                0xD => 96,
                0xE => 128,
                _ => panic!("Invalid cache info associativity.")
            };
            Some(Self::NWayAssociative(n))
        }
    }

    /// Convert to CPUID 4-bit representation.
    pub fn as_bits(assoc: Option<Self>) -> u8 {
        match assoc {
            Some(assoc) => {
                match assoc {
                    Self::Disabled => 0,
                    Self::DirectMapped => 0x1,
                    Self::FullyAssociative => 0xf,
                    Self::NWayAssociative(n) => {
                        match n {
                            2   => 0x2,
                            3   => 0x3,
                            4   => 0x4,
                            6   => 0x5,
                            8   => 0x6,
                            16  => 0x8,
                            32  => 0xA,
                            48  => 0xB,
                            64  => 0xC,
                            96  => 0xD,
                            128 => 0xE,
                            _ => panic!("Invalid cache info n-way n variable."),
                        }
                    },
                }
            },
            None => 9,
        }
    }
}

/// L2, L3, and L2 TLB Cache Information. Return data of CPUID function 0x8000_0006.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct L2TlbL3CacheInfo {
    /// L2 instruction TLB number of entries for 2MiB pages (half of 4MiB entries) and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub inst_tlbl2_2mb_info: Option<(u16, CacheAssociativity)>,
    /// L2 data TLB number of entries for 2MiB pages (half of 4MiB entries) and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub data_tlbl2_2mb_info: Option<(u16, CacheAssociativity)>,

    /// L2 instruction TLB number of entries for 4KiB pages and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub inst_tlbl2_4kb_info: Option<(u16, CacheAssociativity)>,
    /// L2 data TLB number of entries for 4KiB pages and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub data_tlbl2_4kb_info: Option<(u16, CacheAssociativity)>,

    /// L2 cache information: `(cache line size, lines per tag, size in KiB, associativity)`.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub l2_info: Option<(u8, u8, u16, CacheAssociativity)>,
    /// L2 cache information: `(cache line size, lines per tag, size in 512KiB units, associativity)`.
    /// Cache size is a lower bound, the actual size may instead be up to 512KiB greater.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub l3_info: Option<(u8, u8, u16, CacheAssociativity)>,
}
impl L2TlbL3CacheInfo {
    /// Performs CPUID function 0x8000_0006, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, edx) = cpuid(0x8000_0006, 0)?;

        Some(
            Self {
                inst_tlbl2_2mb_info: CacheAssociativity::from_bits((eax >> 12) as u8 & 0xf)
                    .map(|c| ((eax >> 00) as u16 & 0xfff, c)),
                data_tlbl2_2mb_info: CacheAssociativity::from_bits((eax >> 28) as u8 & 0xf)
                    .map(|c| ((eax >> 16) as u16 & 0xfff, c)),
                
                inst_tlbl2_4kb_info: CacheAssociativity::from_bits((ebx >> 12) as u8 & 0xf)
                    .map(|c| ((ebx >> 00) as u16 & 0xfff, c)),
                data_tlbl2_4kb_info: CacheAssociativity::from_bits((ebx >> 28) as u8 & 0xf)
                    .map(|c| ((ebx >> 16) as u16 & 0xfff, c)),
    
                l2_info: CacheAssociativity::from_bits((ecx >> 12) as u8 & 0xf)
                    .map(|c| (ecx as u8, (ecx >> 8) as u8 & 0xf, (ecx >> 16) as u16, c)),
                l3_info: CacheAssociativity::from_bits((edx >> 12) as u8 & 0xf)
                    .map(|c| (edx as u8, (edx >> 8) as u8 & 0xf, (edx >> 18) as u16, c)),
            }
        )
    }
}

bitflags::bitflags! {
    pub struct ExtFn7EBX: u32 {
        /// MCA overflow recovery support. If set, indicates that MCA overflow conditions (MCi_STATUS[Overflow]=1) 
        /// are not fatal; software may safely ignore such conditions. If clear, MCA overflow conditions require 
        /// software to shut down the system. 
        const MCAOFRECOVER = 1 << 0;
        /// Software uncorrectable error containment and recovery capability.
        /// 
        /// The processor supports software containment of uncorrectable errors through
        /// context synchronizing data poisoning and deferred error interrupts
        const SUCCOR = 1 << 1;
        /// Hardware assert supported. Indicates support for MSRC001_10[DF:C0].
        const HWA = 1 << 2;
        /// If set, MCAX is supported; the MCAX MSR addresses are supported; 
        /// MCA_CONFIG[Mcax] is present in all MCA banks.
        const SCALABLEMCA = 1 << 3;
    }

    pub struct ExtFn7EDX: u32 {
        /// Temperature sensor.
        const TS = 1 << 0;
        /// Frequency ID control. Function replaced by HwPstate.
        const FID = 1 << 1;
        /// Voltage ID control. Function replaced by HwPstate.
        const VID = 1 << 2;
        /// THERMTRIP.
        const TPP = 1 << 3;
        /// Hardware thermal control (HTC). 
        const TM = 1 << 4;
        /// 100 MHz multiplier Control.
        const STEP100MHZ = 1 << 6;
        /// Hardware P-state control. MSRC001_0061 (P-state Current Limit), 
        /// MSRC001_0062 (P-state Control), and MSRC001_0063 (P-state Status) exist.
        const HWPSTATE = 1 << 7;
        /// TSC invariant. The TSC rate is ensured to be invariant across all P-States, CStates, 
        /// and stop grant transitions (such as STPCLK Throttling); therefore the TSC is suitable 
        /// for use as a source of time. Otherwise no such guarantee is made and software should
        /// avoid attempting to use the TSC as a source of time. 
        const TSCINVARIANT = 1 << 8;
        /// Core performance boost.
        const CPB = 1 << 9;
        /// Read-only effective frequency interface.
        /// Indicates presence of MSRC000_00E7 (MPerfReadOnly) and MSRC000_00E8 (APerfReadOnly).
        const EFF_FREQ_RO = 1 << 10;
        /// DEPRECATED. Processor feedback interface.
        const FBI = 1 << 11;
        /// Processor power reporting interface supported. 
        const PR = 1 << 12;
    }
}
/// Processor Power Management and RAS Capabilities. Return data of CPUID function 0x8000_0007.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PowerInfo {
    /// RAS features that allow system software to detect specific hardware errors.
    pub ebx_ras_capabilities: ExtFn7EBX,
    /// Specifies the ratio of the compute unit power accumulator sample period to the 
    /// TSC counter period. `None` if not system-applicable.
    pub pwr_sample_time_ratio: Option<NonZeroU32>,
    /// Advanced power management and power reporting features.
    pub edx_pwr_features: ExtFn7EDX,
}
impl PowerInfo {
    /// Performs CPUID function 0x8000_0007, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (_, ebx, ecx, edx) = cpuid(0x8000_0007, 0)?;

        Some(
            Self {
                ebx_ras_capabilities: ExtFn7EBX::from_bits_truncate(ebx),
                pwr_sample_time_ratio: NonZeroU32::new(ecx),
                edx_pwr_features: ExtFn7EDX::from_bits_truncate(edx),
            }
        )
    }
}

bitflags::bitflags! {
    pub struct ExtFn8EBX: u32 {
        /// CLZERO instruction supported.
        const CLZERO = 1 << 0;
        /// Instruction Retired Counter MSR available.
        const INST_RET_CNT = 1 << 1;
        /// FP Error Pointers Restored by XRSTOR.
        const RSTR_FP_ERR_PTRS = 1 << 2;
        /// INVLPGB and TLBSYNC instruction support.
        const INVLPGB = 1 << 3;
        /// RDPRU instruction support.
        const RDPRU = 1 << 3;
        /// MCOMMIT instruction support.
        const MCOMMIT = 1 << 8;
        /// WBNOINVD instruction support.
        const WBNOINVD = 1 << 9;
        /// Indirect Branch Prediction Barrier.
        const IBPB = 1 << 12;
        /// WBINVD/WBNOINVD are interruptible.
        const INT_WBINVD = 1 << 13;
        /// Indirect Branch Restricted Speculation.
        const IBRS = 1 << 14;
        /// Single Thread Indirect Branch Prediction mode.
        const STIBP = 1 << 15;
        /// Processor prefers that IBRS be left on.
        const IBRS_ALWAYS_ON = 1 << 16;
        /// Processor prefers that STIBP be left on.
        const STIBP_ALWAYS_ON = 1 << 17;
        /// IBRS is preferred over software solution.
        const IBRS_PREFERRED = 1 << 18;
        /// IBRS provides same mode speculation limits.
        const IBRS_SAME_MODE = 1 << 19;
        ///  EFER.LMSLE is unsupported.
        const EFER_LMSLE_UNSUPPORTED = 1 << 20;
        ///  INVLPGB support for invalidating guest nested translations.
        const INVLPGB_NESTED = 1 << 21;
        /// Speculative Store Bypass Disable
        const SSBD = 1 << 24;
        /// Use VIRT_SPEC_CTL for SSBD
        const SSBD_VIRT_SPEC_CTRL = 1 << 25;
        /// SSBD not needed on this processor.
        const SSBD_NOT_REQUIRED = 1 << 26;
        /// Predictive Store Forward Disable.
        const PSFD = 1 << 28;
    }
}
/// Processor Capacity Parameters and Extended Features. Return data of CPUID function 0x8000_0008.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct CapacityInfo {
    /// Maximum physical address size in bits. When `guest_phys_addr_size` is `None` (zero),
    /// this field also indicates the maximum guest physical address size. 
    pub phys_addr_size: u8,
    /// Maximum linear address size in bits. 
    pub linr_addr_size: u8,
    /// Maximum guest physical address size in bits. This number applies only to guests using nested paging. 
    /// When this field is `None` (zero), refer to `phys_addr_size` for the maximum guest physical address size. 
    pub guest_phys_addr_size: Option<NonZeroU8>,

    pub ebx_misc_features: ExtFn8EBX,

    /// Number of CPU cores/physical threads minus 1.
    pub nc: u8, // impl notes: new docs reference NC but document NT, old docs ref NC and doc NC
    /// APIC ID size. The number of bits in the initial APIC20\[ApicId\] value that indicate
    /// logical processor ID within a package. The size of this field determines the
    /// maximum number of logical processors (MNLP) that the package could
    /// theoretically support, and not the actual number of logical processors that are
    /// implemented or enabled in the package, as indicated by `nc`. A value of zero indicates 
    /// that legacy methods must be used to determine the maximum number of logical processors, 
    /// as indicated by `nc`.
    pub apic_id_size: u8,
    /// Performance time-stamp counter size. Indicates the size of MSRC001_0280\[PTSC\].
    /// - 00b: 40 bits
    /// - 01b: 48 bits
    /// - 10b: 56 bits
    /// - 11b: 64 bits
    pub perf_tsc_size: u8,

    /// Maximum page count for INVLPGB instruction.
    pub invlpgb_count_max: u16,
    /// The maximum ECX value recognized by RDPRU.
    pub max_rdpru_id: u16,
}
impl CapacityInfo {
    /// Performs CPUID function 0x8000_0008, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, ecx, edx) = cpuid(0x8000_0008, 0)?;

        Some(
            Self {
                phys_addr_size: eax as u8,
                linr_addr_size: (eax >> 8) as u8,
                guest_phys_addr_size: NonZeroU8::new((eax >> 16) as u8),

                ebx_misc_features: ExtFn8EBX::from_bits_truncate(ebx),

                nc: ecx as u8,
                apic_id_size: (ecx >> 12) as u8 & 0xf,
                perf_tsc_size: (ecx >> 16) as u8 & 0x3,

                invlpgb_count_max: edx as u16,
                max_rdpru_id: (edx >> 16) as u16,
            }
        )
    }
}

bitflags::bitflags! {
    /// CPUID Extended Function 0x8000_000A - EDX return value: SVM Feature Identifiers.
    pub struct ExtFnAEDX: u32 {
        /// Nested paging support.
        const NP = 1 << 0;
        /// LBR virtualization support.
        const LBR_VIRT = 1 << 1;
        /// SVM lock support.
        const SVML = 1 << 2;
        /// NRIP save support on #VMEXIT.
        const NRIPS = 1 << 3;
        /// MSR based TSC rate control support.
        const TSC_RATE_MSR = 1 << 4;
        /// VMCB clean bits support.
        const VMCB_CLEAN = 1 << 5;
        /// TLB flush events, including CR3 writes and CR4.PGE toggles, flush only the current 
        /// ASID's TLB entries. Also indicates support for the extended VMCB TLB_Control. 
        const FLUSH_BY_ASID = 1 << 6;
        /// Decode assists support.
        const DECODE_ASSISTS = 1 << 7;
        /// Pause intercept filter support. 
        const PAUSE_FILTER = 1 << 10;
        /// PAUSE filter cycle count threshold support.
        const PAUSE_FILTER_THRESH = 1 << 12;
        /// Support for the Advanced Virtual Interrupt Controller. 
        const AVIC = 1 << 13;
        /// VMSAVE and VMLOAD virtualization. 
        const VMSAVE_VIRT = 1 << 15;
        /// Virtualize the Global Interrupt Flag.
        const VGIF = 1 << 16;
        /// Guest Mode Execution Trap.
        const GMET = 1 << 17;
        /// SVM supervisor shadow stack restrictions.
        const SSS_CHK = 1 << 19;
        /// SPEC_CTRL virtualization.
        const SPEC_CTRL = 1 << 20;
        /// When host CR4::MCE is set and guest CR4::MCE is clear, machine check
        /// exceptions in a guest do not cause shutdown and are always intercepted.
        const HOST_MCE_OVERRIDE = 1 << 23;
        /// Support for INVLPGB/TLBSYNC hypervisor enable in VMCB and TLBSYNC intercept. 
        const TLBICTL = 1 << 24;
    }
}
/// Secure Virtual Machine Architecture Features. Return data of CPUID function 0x8000_000A.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SvmInfo {
    /// SVM revision number
    pub svm_rev: u8,
    /// Number of available address space identifiers (ASID).
    pub asid_count: u32,
    /// Secure Virtual Machine architecture feature information.
    pub svm_features: ExtFnAEDX,
}
impl SvmInfo {
    /// Performs CPUID function 0x8000_000A, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        if !ExtFeatureInfo::test_ecx_flags(ExtFn1ECX::SVM) {
            return None;
        }

        let (eax, ebx, _, edx) = cpuid(0x8000_000A, 0)?;

        Some(
            Self {
                svm_rev: eax as u8,
                asid_count: ebx,
                svm_features: ExtFnAEDX::from_bits_truncate(edx),
            }
        )
    }
}

/// L1 and L2 TLB 1GB Page Cache Information. Return data of CPUID function 0x8000_0019.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Tlb1GbCacheInfo {
    /// L1 data TLB number of entries for 1GiB and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub data_tlbl1_1gb_info: Option<(u16, CacheAssociativity)>,
    /// L1 instruction TLB number of entries for 1GiB and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub inst_tlbl1_1gb_info: Option<(u16, CacheAssociativity)>,

    /// L2 data TLB number of entries for 1GiB pages and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub data_tlbl2_1gb_info: Option<(u16, CacheAssociativity)>,
    /// L2 instruction TLB number of entries for 1GiB pages and associativity.
    /// `None` where the data must be instead retrieved from CPUID Extended Function 0x8000_001D.
    pub inst_tlbl2_1gb_info: Option<(u16, CacheAssociativity)>,
}
impl Tlb1GbCacheInfo {
    /// Performs CPUID function 0x8000_0019, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        let (eax, ebx, _, _) = cpuid(0x8000_0019, 0)?;

        Some(
            Self {
                inst_tlbl1_1gb_info: CacheAssociativity::from_bits((eax >> 12) as u8 & 0xf)
                    .map(|c| ((eax >> 00) as u16 & 0xfff, c)),
                data_tlbl1_1gb_info: CacheAssociativity::from_bits((eax >> 28) as u8 & 0xf)
                    .map(|c| ((eax >> 16) as u16 & 0xfff, c)),
                
                inst_tlbl2_1gb_info: CacheAssociativity::from_bits((ebx >> 12) as u8 & 0xf)
                    .map(|c| ((ebx >> 00) as u16 & 0xfff, c)),
                data_tlbl2_1gb_info: CacheAssociativity::from_bits((ebx >> 28) as u8 & 0xf)
                    .map(|c| ((ebx >> 16) as u16 & 0xfff, c)),
            }
        )
    }
}

bitflags::bitflags! {
    /// CPUID Extended Function 0x8000_001A - EAX return value: Instruction Optimisation Identifiers.
    pub struct ExtFn1AEAX: u32 {
        /// The internal FP/SIMD execution datapath is 128 bits wide.
        const FP128 = 1 << 0;
        /// MOVU SSE nstructions are more efficient and should be preferred to SSE MOVL/MOVH.
        const MOVU = 1 << 1;
        /// The internal FP/SIMD execution datapath is 256 bits wide. 
        const FP256 = 1 << 2;
    }
}
/// Instruction Optimizations Information. Return data of CPUID function 0x8000_001A.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct InstrOptsInfo {
    /// Instruction performance-related identifiers.
    pub perf_opt_idents: ExtFn1AEAX,
}
impl InstrOptsInfo {
    /// Performs CPUID function 0x8000_001A, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        if !ExtFeatureInfo::test_ecx_flags(ExtFn1ECX::IBS) {
            return None;
        }
        
        let (eax, _, _, _) = cpuid(0x8000_001A, 0)?;

        Some(
            Self {
                perf_opt_idents: ExtFn1AEAX::from_bits_truncate(eax),
            }
        )
    }
}

bitflags::bitflags! {
    /// CPUID Extended Function 0x8000_001B - EAX return value: IBS Feature Identifiers.
    pub struct ExtFn1BEAX: u32 {
        /// IBS feature flags valid.
        const IBSFFV = 1 << 0;
        /// IBS fetch sampling supported. 
        const FETCHSAM = 1 << 1;
        /// IBS execution sampling supported.
        const OPSAM = 1 << 2;
        /// Read write of op counter supported. 
        const RDWROPCNT = 1 << 3;
        /// Op counting mode supported.
        const OPCNT = 1 << 4;
        /// Branch target address reporting supported.
        const BRNCNT = 1 << 5;
        /// IbsOpCurCnt and IbsOpMaxCnt extend by 7 bits. 
        const OPCNTEXT = 1 << 6;
        /// Invalid RIP indication supported.
        const RIPINVCHK = 1 << 7;
        /// Fused branch micro-op indication supported.
        const OPBRNFUSE = 1 << 8;
    }
}
/// Instruction-Based Sampling Capabilities. Return data of CPUID function 0x8000_001B.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct IbsInfo {
    /// The IBS features that this processor supports.
    pub ibs_features: ExtFn1BEAX,
}
impl IbsInfo {
    /// Performs CPUID function 0x8000_001B, if supported, and returns the rendered data.
    pub fn read() -> Option<Self> {
        if !ExtFeatureInfo::test_ecx_flags(ExtFn1ECX::IBS) {
            return None;
        }

        let (eax, _, _, _) = cpuid(0x8000_001B, 0)?;

        Some(
            Self {
                ibs_features: ExtFn1BEAX::from_bits_truncate(eax),
            }
        )
    }
}


