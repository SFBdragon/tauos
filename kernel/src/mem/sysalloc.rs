use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout},
    arch::x86_64::{_blsmsk_u64, _blsr_u64}, mem::MaybeUninit
};

use amd64::paging;
use spin::Mutex;
use crate::utils::LlistNode;

/*
    Allocations of arena size, even when a power of two, are disallowed.
    Granularity defines the number of different sized power of two blocks can be allocated. 1 is min.
    The smallest block must be greater or equal to sixteen, 0x10.
*/

#[derive(Debug)]
struct SysAllocMutInner<const G: usize> {
    avl_llists: u64,
    llist_heads: [LlistNode<()>; G],
}

#[derive(Debug)]
pub struct SysAlloc<const GRANULARITY: usize> {
    arena: *mut u8,
    arena_size: u64,
    lsgst_size: u64,
    smlst_size: u64,

    bitmap: *mut u64,

    inner: spin::Mutex<SysAllocMutInner<GRANULARITY>>
}


impl<const GRANULARITY: usize> SysAlloc<GRANULARITY> {
    /// # Safety:
    /// Call `init` on the returned instance before using it.
    pub const unsafe fn new() -> Self {
        //const INVALID_LLIST_NODE: LlistNode<'static, ()> = unsafe { LlistNode::new_llist_invalid(()) };

        Self { 
            arena: ptr::null_mut(),
            arena_size: 0,
            lsgst_size: 0,
            smlst_size: 0,
            bitmap: ptr::null_mut(),
            inner: Mutex::new(
                SysAllocMutInner {
                    avl_llists: 0,
                    llist_heads: [const { unsafe { LlistNode::new_llist_invalid(()) } }; GRANULARITY],
                }
            )
        }
    }

    #[allow(dead_code)]
    /// todo
    pub unsafe fn init(&mut self, arena: *mut u8, arena_size: u64, bitmap: *mut u64) {
        assert!(GRANULARITY != 0);

        // Ensure that blocks below a size of sixteen cannot be produced, as not to impede linked list node storage.
        assert!(arena_size.log2() - GRANULARITY as u32 >= 3);
 
        // Types usually don't require alignment larger than their size, and the largest alignment that a
        // rust type can demand is 4KiB. The largest type this allocator will allow is the floor(log2(arena_size))
        // due to the buddy allocation mechanism. The required alignment is thusly derived.
        let required_alignment = u32::min(arena_size.log2(), paging::PTE_MAPPED_SIZE.trailing_zeros());

        // Initialize self
        self.arena = arena;
        self.arena_size = arena_size;
        self.lsgst_size = 1 << arena_size.log2();
        self.smlst_size = 1 << (arena_size.log2() - GRANULARITY as u32 + 1);
        self.bitmap = bitmap;

        let mut inner = self.inner.lock();

        for node in inner.llist_heads.iter_mut() {
            node.init_llist();
        }

        // Alignment can be satisfied in two ways: base and end.
        // End is preferable due to realloc performance from initial allocations
        let top_aligned = (arena as u64 + arena_size).trailing_zeros() >= required_alignment;
        assert!(top_aligned | ((arena as u64).trailing_zeros() >= required_alignment));

        let mut arena_size_bitmap = arena_size;
        let (mut addr_offset, offset_coeff) = if top_aligned {
            (arena as u64 + arena_size, -1i64 as u64)
        } else {
            (arena as u64, 1)
        };

        while arena_size_bitmap != 0 {
            let block_size = _blsr_u64(arena_size_bitmap);
            arena_size_bitmap = arena_size_bitmap ^ block_size;

            addr_offset = addr_offset.wrapping_add(block_size * offset_coeff);
            let index = self.block_index(block_size);
            let head_ptr = inner.llist_heads.get_unchecked_mut(index);

            todo!();
            //LlistNode::new((addr_offset as *mut LlistNode<'llists, ()>).as_uninit_mut().unwrap(), head_ptr, head_ptr, ());
            //self.toggle_bit_flag(block_size, addr_offset);
            inner.avl_llists |= index as u64;
        }
    }

    #[inline]
    fn block_index(&self, size: u64) -> usize {
        // this is effectively computing: arena_size.log2() - size.log2()
        (size.leading_zeros() - self.arena_size.leading_zeros()) as usize
    }
    
    /// Returns the offset in bits into the bitmap that indicates buddy status.
    /// Use `toggle_bitflag` to toggle the bit by passing in the returned value.
    /// 
    /// * Clear bit indicates homogeneity: either both are allocated or neither.
    /// * Set bit indicated heterogeneity: one of the pair is allocated.
    /// 
    /// # Safety:
    /// `addr` must be within the arena. Assumes `size` is a power of two implicitly.
    #[inline]
    unsafe fn get_bitmap_offset(&self, size: u64, addr: u64) -> u64 {
        self.lsgst_size + addr - self.arena as u64 >> 64 - size.leading_zeros()
        // expanded:
        // base = lsgst_size >> log2(size) - 1
        // offset = base + (addr - arena_base >> log2(size) - 1))
    }
    /// Utility function to read the bitmap at the offset in bits
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: u64) -> bool {
        *self.bitmap.wrapping_add(bitmap_offset as usize >> 6) & 1 << (bitmap_offset & 63) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits
    #[inline]
    unsafe fn toggle_bitflag(&self, bitmap_offset: u64) {
        *self.bitmap.wrapping_add(bitmap_offset as usize >> 6) ^= 1 << (bitmap_offset & 63);
    }

  /*   #[inline]
    unsafe fn add_block(&self, granularity: usize, size: usize, avl_llists: &mut u64,
    llist_heads: &mut [LlistNode<()>; GRANULARITY], ptr: NonNull<LlistNode<()>>) {
        if *avl_llists & 1 << granularity != 0 {
            // populating llist
            *avl_llists |= 1 << granularity;
        }

        // add node from llist
        LlistNode::new(ptr, 
            NonNull::new_unchecked(ptr::addr_of_mut!(llist_heads[granularity])),
            llist_heads[granularity].next.get(),
        ());

        // toggle bitmap flag
        self.toggle_bit_flag(size, ptr.as_ptr() as usize);
    } */
    #[inline]
    unsafe fn remove_block(&self, granularity: usize, size: u64, avl_llists: &mut u64, ptr: *mut LlistNode<()>) {
        if (*ptr).next == (*ptr).prev {
            // last free block in llist, toggle off avl flag
            *avl_llists &= !(1 << granularity);
        }

        // remove node from llist
        todo!();
        //LlistNode::remove(NonNull:: ptr);

        // toggle bitmap flag
        self.toggle_bitflag(self.get_bitmap_offset(size, ptr as u64));
    }
}

unsafe impl<const GRANULARITY: usize> GlobalAlloc for SysAlloc<GRANULARITY> {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let mut sync = self.inner.lock();
        let size = fast_non0_next_pow2(layout.size() as u64).max(self.smlst_size);
        let req_index = self.block_index(size);

        let tgt_index: usize;
        if size >= layout.align() as u64 {
            if sync.avl_llists & 1 << req_index != 0 {
                let next = sync.llist_heads.get_unchecked_mut(req_index).next.get().as_ptr();
                self.remove_block(req_index, size, &mut sync.avl_llists, next);
                return next.cast();
            } else {
                tgt_index = req_index;
            }
        } else {
            // tgt may now be less that req, as extra align in required
            tgt_index = self.block_index(layout.align() as u64);
        }

        // find a larger block to break apart
        // mask out bits for smaller blocks
        let larger_avl = sync.avl_llists & _blsmsk_u64(1 << tgt_index);
        if larger_avl == 0 {
            panic!("not enough memory!")
        } else {
            let lgr_index: usize;
            // the compiler doesn't emit this for some reason, even though it won't cause UB here ever
            asm!("bsr {}, {}", lateout(reg) lgr_index, in(reg) larger_avl, options(nomem, nostack, preserves_flags));

            let lgr_block = sync.llist_heads.get_unchecked_mut(lgr_index).next.get();
            let lgr_size = self.lsgst_size >> lgr_index;

            let mut block_size = lgr_size;
            for granularity in lgr_index..req_index {
                block_size >>= 1;
                
                // add block
                let head_ptr = sync.llist_heads.get_unchecked_mut(granularity);
                let next_ptr = head_ptr/* .as_ref() */.next.get().as_mut();
                let block_ptr =/*  NonNull::new_unchecked( */
                    lgr_block.as_ptr().cast::<u8>().wrapping_add(block_size as usize).cast::<LlistNode<()>>();

            
                todo!();
                //if head_ptr == next_ptr { sync.avl_llists |= 1 << granularity; } // update avl_llists
                //self.toggle_bitflag(block_size, block_ptr.as_ptr() as u64); // update bitmap
                //LlistNode::new(block_ptr.as_uninit_mut().unwrap(), head_ptr, next_ptr, ()); // update llist
            }

            // remove the large block, it is guaranteed to have been broken
            self.remove_block(lgr_index, lgr_size, &mut sync.avl_llists, lgr_block.as_ptr());

            return lgr_block.as_ptr().cast();
        }
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        let mut block_size = fast_non0_next_pow2(layout.size() as u64).max(self.smlst_size);
        let mut block_ptr = ptr;
        let mut granularity = self.block_index(block_size);
        
        let mut bitmap_offset = self.get_bitmap_offset(block_size, ptr as u64);
        while self.read_bitflag(bitmap_offset) { // while buddy isn't allocated
        todo!();
            //LlistNode::remove(node)
        }
        // next) shift size, shift align if necessary(req full align?/do mod from arena?), shift granularity
        // loop check bitmap at loc for set bits
        //     update bitmap
        //     remove llist, update avls 

        todo!()
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ret = self.alloc(layout);
        core::slice::from_raw_parts_mut(ret, layout.size()).fill(0);
        ret
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        todo!()
    }
}


#[inline]
const unsafe fn fast_non0_next_pow2(input: u64) -> u64 {
    // Fails with attempt to wrapping subtract in debug mode when zero.
    // Zero is undefined behaviour in release mode?
    1 << 64 - (input - 1).leading_zeros() 
}
