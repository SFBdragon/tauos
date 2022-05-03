//! Memory management module.

pub mod talloc;
pub mod mapping;

use amd64::paging::{self, PTE_MAPPED_SIZE};

/// The offset to displace physical addresses into linear address space.
pub const PHYS_LADDR_OFFSET: u64 = paging::CANONICAL_HIGHER_HALF + paging::PML4E_MAPPED_SIZE;
/// The index to recurr through the PML4T onto itself.
pub const RECURSIVE_IDX: u64 = 0o400;
/// The index to map a PML4 entry onto another PML4.
pub const GUEST_IDX: u64 = 0o401;




/* BOOTBOOT requires kernel to be mapped between:
    0xffffffffC0000000 -> 0xffffffffffffffff (-1GiB -> -1)
Kernel code model requires symbols to be:
    0xffffffff80000000 -> 0xffffffffff000000 (-2GiB -> -16MiB)

It is chosen that the kernel be mapped from 0xffffffffC0000000 (-256MiB),
plus a 4KiB page, in practice. This is in order to both have more than 
sufficient space (128MiB away from BOOTBOOT mapped data) and yet remain 
within the topmost 1 GiB huge page (along with its stacks below it). */

/// Kernel lower bound mapped virtual address.
pub const KRNL_VIRT_BASE: u64 = 0xffffffffC0000000 + PTE_MAPPED_SIZE;
/// Acme of the topmost kernel stack (the bootstrap CPU).
pub const KRNL_STACK_ACME: u64 = KRNL_VIRT_BASE - paging::PTE_MAPPED_SIZE;
/// Size of each kernel process stack, excluding seperation page.
pub const KRNL_STACK_SIZE: u64 = 1024 * 1024 - paging::PTE_MAPPED_SIZE;


