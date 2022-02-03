#![no_std]

#![feature(allocator_api)]
#![feature(int_log)]
#![feature(int_abs_diff)]
#![feature(arbitrary_self_types)]

#![feature(ptr_metadata)]
#![feature(ptr_as_uninit)]

#![feature(slice_ptr_len)]
#![feature(slice_ptr_get, nonnull_slice_from_raw_parts)]
#![feature(maybe_uninit_slice)]
#![feature(maybe_uninit_write_slice)]

#![feature(const_pin)]
#![feature(const_mut_refs)]
#![feature(const_maybe_uninit_write)]
#![feature(const_slice_from_raw_parts)]
#![feature(const_maybe_uninit_assume_init)]

extern crate alloc;

pub mod memman;
pub mod out;
pub mod utils;

#[repr(C)]
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
