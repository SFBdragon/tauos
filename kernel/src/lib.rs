#![no_std]

#![feature(allocator_api)]
#![feature(core_intrinsics)]
#![feature(const_assume)]

#![feature(int_log)]

#![feature(nonnull_slice_from_raw_parts)]
#![feature(ptr_to_from_bits)]
#![feature(slice_ptr_len)]
#![feature(slice_ptr_get)]

extern crate alloc;

pub mod memm;
pub mod out;
pub mod utils;

