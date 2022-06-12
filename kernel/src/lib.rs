#![no_std]

#![feature(abi_x86_interrupt)]

#![feature(allocator_api)]
#![feature(core_intrinsics)]
#![feature(const_assume)]
#![feature(const_mut_refs)]

#![feature(int_log)]
#![feature(array_chunks)]
#![feature(nonnull_slice_from_raw_parts)]
#![feature(const_slice_from_raw_parts)]
#![feature(ptr_to_from_bits)]
#![feature(layout_for_ptr)]
#![feature(slice_ptr_len)]
#![feature(slice_ptr_get)]

extern crate alloc;

pub mod cfg;
pub mod memm;
pub mod out;
pub mod utils;

