#![no_std]

#![feature(allocator_api)]
#![feature(core_intrinsics)]

#![feature(arbitrary_self_types)]

#![feature(int_log)]
#![feature(int_abs_diff)]

#![feature(ptr_metadata)]
#![feature(ptr_as_uninit)]
#![feature(ptr_to_from_bits)]
#![feature(nonnull_slice_from_raw_parts)]
#![feature(slice_ptr_len)]
#![feature(slice_ptr_get)]
#![feature(maybe_uninit_slice)]
#![feature(maybe_uninit_write_slice)]

#![feature(const_pin)]
#![feature(const_assume)]
#![feature(const_mut_refs)]
#![feature(const_maybe_uninit_write)]
#![feature(const_slice_from_raw_parts)]
#![feature(const_maybe_uninit_assume_init)]

//extern crate alloc;

pub mod memm;
pub mod out;
pub mod utils;

