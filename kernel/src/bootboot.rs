
pub const BOOTBOOT_MAGIC: [u8; 4] = [b'B', b'O', b'O', b'T'];

pub const PROTOCOL_MINIMAL: u8 = 0;
pub const PROTOCOL_STATIC: u8 = 1;
pub const PROTOCOL_DYNAMIC: u8 = 2;
pub const PROTOCOL_BIGENDIAN: u8 = 128;

pub const LOADER_BIOS: u32 = 0;
pub const LOADER_UEFI: u32 = 4;
pub const LOADER_RPI: u32 = 8;

// bootboot seems to report these backwards?
// bootboot.h values are commented out
pub const FB_ARGB: u8 = 3; // 0;
pub const FB_RGBA: u8 = 2; // 1;
pub const FB_ABGR: u8 = 1; // 2;
pub const FB_BGRA: u8 = 0; // 3;

pub const MMAP_DATA_SIZE_MASK: u64 = 0xfffffffffffffff0;
pub const MMAP_DATA_TYPE_MASK: u64 = 0xf;
pub const MMAP_USED: u64 = 0;
pub const MMAP_FREE: u64 = 1;
pub const MMAP_ACPI: u64 = 2;
pub const MMAP_MMIO: u64 = 3;

pub const FRAMEBUFFER: *mut u8 = 0xfffffffffc000000 as *mut _;
pub const ENV_CFG: *const [u8] = core::ptr::slice_from_raw_parts(0xffffffffffe01000usize as _, 4096);
pub const BOOTBOOT: *const BootBoot = 0xffffffffffe00000 as *const _;
pub const MMAP: *mut MMapEntry = BOOTBOOT.wrapping_offset(1) as *mut _;

#[repr(C, packed)]
#[derive(Debug, Copy, Clone)]
pub struct BootBoot {
    pub magic: [u8; 4],
    pub size: u32,
    pub protocol: u8,
    pub fb_type: u8,
    pub num_cores: u16,
    pub bspid: u16,
    pub timezone: i16,
    pub datetime: [u8; 8],
    pub initrd_ptr: u64,
    pub initrd_size: u64,
    pub fb_ptr: *mut u8,
    pub fb_size: u32,
    /// Framebuffer width in pixels.
    pub fb_width: u32,
    /// Framebuffer height in pixels.
    pub fb_height: u32,
    /// Framebuffer stride/pitch/scanline in bytes.
    pub fb_scanline: u32,

    #[cfg(target_arch = "x86_64")]
    pub platform: BootBootAmd64,

    pub mmap: MMapEntry,
}

#[repr(C, packed)]
#[derive(Debug, Copy, Clone)]
pub struct MMapEntry {
    pub ptr: u64,
    pub data: u64,
}

#[repr(C, packed)]
#[derive(Debug, Copy, Clone)]
pub struct BootBootAmd64 {
    pub acpi_paddr: u64,
    pub smbi_paddr: u64,
    pub efi_paddr: u64,
    pub mp_paddr: u64,
    pub unused0: u64,
    pub unused1: u64,
    pub unused2: u64,
    pub unused3: u64,
}


/// ### Safety:
/// * BOOTBOOT must have been the bootloader to handover control.
/// * The BOOTBOOT memory map must not be erroneously modified for the
/// lifetime of the returned iterator.
pub unsafe fn mmap_available_iter() -> impl Iterator<Item = (usize, usize)> + Clone {
    use core::mem;

    let mmap_size = (*BOOTBOOT).size as usize - mem::size_of::<BootBoot>();
    let mmap_len = mmap_size / mem::size_of::<MMapEntry>();
    let mmap = core::slice::from_raw_parts_mut(MMAP, mmap_len);

    // check if free blocks are actually usable; bootboot misreports sometimes?
    for entry in mmap.iter_mut().filter(|e| e.data & MMAP_FREE != 0) {
        let base_ptr = entry.ptr as *mut u8;
        let val = base_ptr.read_volatile();
        base_ptr.write_volatile(0xAE);
        let invalid = base_ptr.read_volatile() != 0xAE;
        base_ptr.write_volatile(val);
        if invalid {
            entry.data &= !MMAP_FREE;
        }
    }

    mmap
        .iter()
        .filter(|&entry| entry.data & MMAP_FREE != 0)
        .map(|entry| (
            entry.ptr as usize,
            (entry.data & MMAP_DATA_SIZE_MASK) as usize,
        ))
}

/// ### Safety:
/// * BOOTBOOT must have been the bootloader to handover control.
/// * The BOOTBOOT ENV_CFG must have Rust's aliasing rules enforced.
/// * ENV_CFG needs to be mapped at it's initial location, and remain
/// as such for the lifetime of the returned value.
pub unsafe fn env_cfg_as_str() -> &'static str {
    let mut len = 0;
    while len < 4096 && *ENV_CFG.get_unchecked(len) != 0 {
        len += 1;
    }

    core::str::from_utf8_unchecked(ENV_CFG.get_unchecked(..len).as_ref().unwrap())
}



