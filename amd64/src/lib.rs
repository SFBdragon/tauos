//! A library to house AMD64/x86-64 specific code and assembly. Intel 64/IA-32e specific interface is not included.
//! 
//! This exists primarily out of a challenge to not use Phillip Opperman's x86_64 crate or Gerd Zellweger's x86 crate 
//! in the development of this project, in order to facilitate learning and understanding of the details that come 
//! with writing for he AMD64 architecture, and reinforce that through writing what is otherwise admittedly partially 
//! redundant, less thoroughly documented, and untested code.

#![no_std]
#![feature(abi_x86_interrupt)]

pub mod registers;
pub mod interrupts;
pub mod segmentation;
pub mod paging;
pub mod ports;
pub mod cpuid;



// memory protection levels

#[repr(u8)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum PriviledgeLevel {
    /// Operating System
    Ring0 = 0b00,
    Ring1 = 0b01,
    Ring2 = 0b10,
    /// Userland
    Ring3 = 0b11,
}

impl PriviledgeLevel {
    fn from_bits(from: u8) -> Self {
        match from {
            0b00 => PriviledgeLevel::Ring0,
            0b01 => PriviledgeLevel::Ring1,
            0b10 => PriviledgeLevel::Ring2,
            0b11 => PriviledgeLevel::Ring3,
            _ => panic!("Invalid x86 priviledge level: {}", from),
        }
    }
}



// instructions

pub fn hlt() {
    unsafe {
        core::arch::asm!("hlt", options(nostack, nomem, preserves_flags)); 
    }
}
pub fn hlt_loop() -> ! {
    loop {
        unsafe {
            core::arch::asm!("hlt", options(nostack, nomem, preserves_flags)); 
        }
    }
}
