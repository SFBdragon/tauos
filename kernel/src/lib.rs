#![no_std]
#![feature(asm)]
#![feature(int_log)]
#![feature(ptr_metadata)]
#![feature(ptr_as_uninit)]

pub mod mem;
pub mod out;
pub mod utils;


pub struct BootPayload {
    /// The UEFI system table
    pub st: uefi::table::SystemTable<uefi::table::Runtime>,

    /// GRAPHICS_OUTPUT_PROTOCOL-provided memory-mapped framebuffer for pixel-array based drawing
    /// 
    /// Frame buffer pointer should be identity mapped onto memory outside physical address space
    pub frame_buffer_ptr: *mut u8,
    pub frame_buffer_info: uefi::proto::console::gop::ModeInfo,

    /// Up-to-date UEFI memory map
    /// 
    /// Memory map is page-aligned and stored in a LOADER_DATA memory region
    pub mmap: &'static mut [uefi::table::boot::MemoryDescriptor],

    /// The kernel binary data
    /// 
    /// Data is page-aligned and stored in a LOADER_DATA memory region
    pub bin: &'static [u8],
}
