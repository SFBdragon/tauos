
pub const BOOTBOOT_MAGIC: [u8; 4] = [b'B', b'O', b'O', b'T'];

pub const PROTOCOL_MINIMAL: u8 = 0;
pub const PROTOCOL_STATIC: u8 = 1;
pub const PROTOCOL_DYNAMIC: u8 = 2;
pub const PROTOCOL_BIGENDIAN: u8 = 128;

pub const LOADER_BIOS: u32 = 0;
pub const LOADER_UEFI: u32 = 4;
pub const LOADER_RPI: u32 = 8;

pub const FB_ARGB: u8 = 0;
pub const FB_RGBA: u8 = 1;
pub const FB_ABGR: u8 = 2;
pub const FB_BGRA: u8 = 3;

pub const MMAP_USED: u64 = 0;
pub const MMAP_FREE: u64 = 1;
pub const MMAP_ACPI: u64 = 2;
pub const MMAP_MMIO: u64 = 3;

pub const INITRD_MAXSIZE: u32 = 16;

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
    pub fb_width: u32,
    pub fb_height: u32,
    pub fb_scanline: u32,

    #[cfg(target_arch = "x86_64")]
    pub platform: BootBootAmd64,

    pub mmap: MMapEnt,
}

#[repr(C, packed)]
#[derive(Debug, Copy, Clone)]
pub struct MMapEnt {
    pub ptr: u64,
    pub size: u64,
}

#[repr(C, packed)]
#[derive(Debug, Copy, Clone)]
pub struct BootBootAmd64 {
    pub acpi_ptr: u64,
    pub smbi_ptr: u64,
    pub efi_ptr: u64,
    pub mp_ptr: u64,
    pub unused0: u64,
    pub unused1: u64,
    pub unused2: u64,
    pub unused3: u64,
}
