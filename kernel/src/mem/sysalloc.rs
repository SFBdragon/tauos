use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout},
};
use crate::utils::LlistNode;
use amd64::paging;
use spin::Mutex;

/*
    Allocations of arena size, even when a power of two, are disallowed.
    Granularity defines the number of different sized power of two blocks can be allocated. 1 is min.
    The smallest block must be greater or equal to sixteen, 0x10.
*/


/// # Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_log2(val: u64) -> u64 {
    // Fails with attempt to wrapping subtract in debug mode when zero.
    // Zero is undefined behaviour in release mode?
    63 ^ val.leading_zeros() as u64
}
/// # Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_prev_pow2(val: u64) -> u64 {
    1 << fast_non0_log2(val)
}
/// # Safety:
/// `val` must be nonzero 
#[inline]
const unsafe fn fast_non0_next_pow2(val: u64) -> u64 {
    // Fails with attempt to wrapping subtract in debug mode when zero.
    // Zero is undefined behaviour in release mode?
    1 << 64 - (val - 1).leading_zeros() 
}


#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ArenaConfig {
    /// The base of the arena, a casted pointer.
    pub base: u64,
    /// Size of the arena in bytes.
    pub size: u64,
    /// The power of two of the smallest allocatable block size.
    pub smlst_pow2: u32,
}

impl ArenaConfig {
    /// Returns the alignment required by `self`'s `size` and `GRANULARITY`.
    /// 
    /// Types usually don't require alignment larger than their size, and the largest alignment that a
    /// rust type can demand is 4KiB. The largest type this allocator will allow is the floor(log2(arena size))
    /// due to the buddy allocation mechanism. The required alignment is thusly derived.
    pub const fn req_align(&self) -> u32 {
        if self.size.log2() < paging::PTE_MAPPED_SIZE.trailing_zeros() {
            self.size.log2()
        } else {
            paging::PTE_MAPPED_SIZE.trailing_zeros()
        }
    }

    /// Shrink the arena to reach a valid state. This does not adjust the configuration if it is already valid.
    /// 
    /// `align_base_else_size` defines which end of the arena is shrunk to satisfy alignment.
    /// Note that the other end of the arena is shrunk to eliminate dead space.
    pub fn shrink_to_valid(&mut self, align_base_else_size: bool) {
        let req_align = self.req_align();

        // align base/acme by shrinking the arena accordingly
        if align_base_else_size && self.base.trailing_zeros() < req_align {
            self.base = (self.base >> req_align) + 1 << req_align;
        } else if !align_base_else_size && (self.base + self.size).trailing_zeros() < req_align {
            self.size = ((self.base + self.size) >> req_align << req_align) - self.base;
        }

        // req_align may have changed in some edge cases here, but will not be more demanding
        // aligning back to the new align may make slightly more memory available, but may in turn
        // change the required alignment back, causing a nasty edge case

        // if there is dead space in the arena, shrink the arena at the opposite end to alignment
        if self.size & (1 << self.smlst_pow2) - 1 != 0 {
            if align_base_else_size {
                self.size = self.size >> self.smlst_pow2 << self.smlst_pow2;
            } else {
                self.base = (self.base >> self.smlst_pow2) + 1 << self.smlst_pow2;
            }
        }
    }


    /// Ensure `self` is a valid arena configuration for the system allocator.
    pub const fn validate(&self) {
        // ensure none of the fields are zero
        assert!(self.base != 0, "ArenaConfig with a base of zero is invalid.");
        assert!(self.size != 0, "ArenaConfig with a size of zero is invalid.");
        
        // ensure granularity is within expected bounds
        assert!(self.smlst_pow2 <= 3,
            "ArenaConfig with an allocatable block smaller than 16 bytes is invalid.");

        // ensure size does not contain unusable space:
        // no bits pertaining to blocks smaller than smallest allocatable are set
        assert!(self.size.trailing_zeros() >= self.smlst_pow2,
            "ArenaConfig size contains unusable space, which is invalid.");

        let req_align = self.req_align();

        // ensure required alignment is satisfied either by the base or the acme
        assert!(self.base.trailing_zeros() >= req_align || (self.base + self.size).trailing_zeros() >= req_align,
            "ArenaConfig where neither the base or acme are aligned to requirement is invalid.");
    }

    /// Returns the granularity to be used by the allocator.
    pub const fn granularity(&self) -> usize {
        self.validate();
        (64 - self.smlst_pow2 - self.size.leading_zeros()) as usize
    }
}


#[derive(Debug)]
struct SysAllocBooks<const G: usize> {
    /// Bitfield of size `1 << GRANULARITY` in bits, each granularity has a bit for each buddy,
    /// offset by that width in bits, i.e. level 3 is 4 bits long, 4 bits offset from bitmap base.
    /// * Clear bit indicates homogeneity: either both are allocated or neither.
    /// * Set bit indicated heterogeneity: one of the pair is allocated.
    bitmap: *mut u64,
    /// Indicates whether a block is available in the linked lists,
    /// bit index corresponding to index into `llist_heads`.
    avl_llists: u64,
    /// The heads of the linked lists that each hold available blocks per size.
    llist_heads: [LlistNode<()>; G],
}

impl<const GRANULARITY: usize> SysAllocBooks<GRANULARITY> {
    /// Utility function to read the bitmap at the offset in bits
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: u64) -> bool {
        *self.bitmap.wrapping_add(bitmap_offset as usize >> 6) & 1 << (bitmap_offset & 63) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: u64) { // takes &mut intentionally
        *self.bitmap.wrapping_add(bitmap_offset as usize >> 6) ^= 1 << (bitmap_offset & 63);
    }

    #[inline]
    unsafe fn add_block(&mut self, granularity: usize, bitmap_offset: u64, node: NonNull<LlistNode<()>>) {
        if self.avl_llists & 1 << granularity == 0 {
            // populating llist
            self.avl_llists |= 1 << granularity;
        }

        // add node from llist
        let head = self.llist_heads.get_unchecked_mut(granularity);
        LlistNode::new(node, 
            head.into(),
            head.next.get(),
            ()
        );

        // toggle bitmap flag
        self.toggle_bitflag(bitmap_offset);
    }
    #[inline]
    unsafe fn remove_block(&mut self, granularity: usize, bitmap_offset: u64, node: NonNull<LlistNode<()>>) {
        if node.as_ref().next.get() == node.as_ref().prev.get() {
            // last block in llist, toggle off avl flag
            self.avl_llists &= !(1 << granularity);
        }

        // remove node from llist
        LlistNode::remove(node);

        // toggle bitmap flag
        self.toggle_bitflag(bitmap_offset);
    }
}


#[derive(Debug)]
pub struct SysAlloc<const GRANULARITY: usize> {
    /// The base of the arena, a casted pointer.
    base: u64,
    /// Size of the arena in bytes.
    size: u64,

    /// Size of the largest allocatable block in bytes.
    lrgst: u64,
    /// Size of the smallest allocatable block in bytes.
    smlst: u64,

    virt_size: u64,
    virt_base: u64,

    /// Mutex-guarded mutable bookkeeping data
    books: spin::Mutex<SysAllocBooks<GRANULARITY>>,
}


impl<const GRANULARITY: usize> SysAlloc<GRANULARITY> {
    /// # Safety:
    /// Call `init` on the returned instance before using it.
    pub const unsafe fn new_invalid() -> Self {
        const INVALID_LLIST_NODE: LlistNode<()> = unsafe { LlistNode::new_llist_invalid(()) };

        Self {
            base: 0,
            size: 0,
            lrgst: 0,
            smlst: 0,
            virt_base: 0,
            virt_size: 0,

            books: Mutex::new(
                SysAllocBooks {
                    bitmap: ptr::null_mut(),
                    avl_llists: 0,
                    llist_heads: [INVALID_LLIST_NODE; GRANULARITY],
                }
            )
        }
    }

    /// todo
    pub unsafe fn init(&mut self, config: ArenaConfig, bitmap: *mut u64) {
        // Ensure the arena configuration is valid
        config.validate();
        // Ensure granularities match
        assert!(GRANULARITY == config.granularity());

        // Initialize self
        self.base = config.base;
        self.size = config.size;
        self.lrgst = fast_non0_prev_pow2(config.size); // size was validated
        self.smlst = 1 << config.smlst_pow2;
        self.virt_size = fast_non0_next_pow2(config.size); // size was validated
        self.virt_base = {
            let req_align = config.req_align();
            if self.base.trailing_zeros() >= req_align {
                self.base
            } else {
                self.base.wrapping_sub(self.virt_size)
            }
        };

        let mut books = self.books.lock();
        books.avl_llists = 0;
        books.bitmap = bitmap;
        for node in books.llist_heads.iter_mut() {
            node.init_llist();
        }

        // Alignment can be satisfied at both arena base and/or arena end
        let is_base_aligned = self.base == self.virt_base;
        let mut offset_base = if is_base_aligned { self.base } else { self.base + self.size };
        let mut arena_size_bitmap = self.size;
        while arena_size_bitmap != 0 {
            let block_size = fast_non0_prev_pow2(arena_size_bitmap);
            let granularity = self.block_granularity(block_size);
            arena_size_bitmap = arena_size_bitmap ^ block_size;

            if !is_base_aligned { offset_base = offset_base.wrapping_sub(block_size); }

            // add block to avl_llists and llist_heads
            // no not toggle bitmap bits, as the buddies cannot be reclaimed
            books.avl_llists |= 1 << granularity;
            let head = books.llist_heads.get_unchecked_mut(granularity);
            LlistNode::new(NonNull::new_unchecked(offset_base as *mut _),
                head.into(), head.next.get(), ());

            if is_base_aligned { offset_base = offset_base.wrapping_add(block_size); }
        }
    }

    #[inline]
    fn block_granularity(&self, size: u64) -> usize {
        // this is effectively computing: largest_block_size.log2() - size.log2()
        (size.leading_zeros() - self.size.leading_zeros()) as usize
    }
    
    /// Returns the offset in bits into the bitmap that indicates buddy status.
    /// # Safety:
    /// * `base` must be within the arena.
    /// * `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: u64, size: u64) -> u64 {
        self.virt_size.wrapping_add(base.wrapping_sub(self.virt_base)) >> fast_non0_log2(size) + 1
        // arena.virt_size >> log2(size) + 1
        // plus
        // base - arena.virt_base >> log2(size) + 1
    }

    #[inline]
    unsafe fn is_lower_buddy(&self, base: u64, size: u64) -> bool {
        base.wrapping_sub(self.virt_base) & size == 0
    }
}

unsafe impl<const GRANULARITY: usize> GlobalAlloc for SysAlloc<GRANULARITY> {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let mut books = self.books.lock();

        // Get the maximum between the required size as a power of two, the smallest allocatable,
        // and the alignment. The alignment being larger than the size is a rather esoteric case,
        // which is handled by simply allocating a larger size with the required alignment. This
        // may be highly memory inefficient for very bizarre scenarios.
        let size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(layout.size() as u64) // ZSTs are never allocated
            | self.smlst
            | layout.align() as u64
        ); 
        let granularity = self.block_granularity(size);

        if books.avl_llists & 1 << granularity != 0 { // if a block of size is available, allocate it
            let next = books.llist_heads.get_unchecked_mut(granularity).next.get();
            books.remove_block(granularity, self.bitmap_offset(next.as_ptr() as u64, size), next);
            return next.as_ptr().cast();
        }

        // find a larger block to break apart - mask out bits for smaller blocks
        let larger_avl = books.avl_llists & core::arch::x86_64::_blsmsk_u64(1 << granularity);
        if larger_avl == 0 { return ptr::null_mut(); } // not enough memory
        
        let lgr_granularity = larger_avl.trailing_zeros() as usize;
        let lgr_size = self.lrgst >> lgr_granularity;
        let lgr_block = books.llist_heads.get_unchecked_mut(lgr_granularity).next.get();
        
        // remove the large block, it is guaranteed to be broken
        books.remove_block(
            lgr_granularity,
            self.bitmap_offset(lgr_block.as_ptr() as u64, lgr_size),
            lgr_block
        );

        // break down the large block into smaller blocks until the required size is reached
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            let hi_block_base = (lgr_block.as_ptr() as u64).wrapping_add(hi_block_size);
            books.add_block(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                NonNull::new_unchecked(hi_block_base as *mut _)
            );

            hi_block_size >>= 1;
        }

        return lgr_block.as_ptr().cast();
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        let mut books = self.books.lock();
        
        let mut base = ptr as u64;
        let mut size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(layout.size() as u64) // ZSTs are never allocated
            | self.smlst
            | layout.align() as u64
        );
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(base, size);

        while books.read_bitflag(bitmap_offset) { // while buddy is available
            books.remove_block(granularity, bitmap_offset, NonNull::new_unchecked(base as *mut _));

            if self.is_lower_buddy(base, size) { base = base.wrapping_sub(size); }
            size <<= 1;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(base, size);
        }

        // add block to the books
        books.add_block(granularity, bitmap_offset, NonNull::new(base as _).unwrap());
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ret = self.alloc(layout);
        core::slice::from_raw_parts_mut(ret, layout.size()).fill(0);
        ret
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        let old_size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(layout.size() as u64) // ZSTs are never allocated
            | self.smlst
            | layout.align() as u64
        );
        let tgt_size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(new_size as u64) // ZSTs are never allocated
            | self.smlst
            | layout.align() as u64
        );

        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(tgt_size);

        let mut books = self.books.lock();

        if tgt_size < old_size {
            // if size is smaller, break up the block
            // follows similar routine to alloc

            // remove the old block, it is guaranteed to be broken
            books.remove_block(
                self.block_granularity(old_size),
                self.bitmap_offset(ptr as u64, old_size),
                NonNull::new_unchecked(ptr.cast())
            );

            // break down the large block into smaller blocks until the required size is reached
            let mut hi_block_size = old_size >> 1;
            for hi_granularity in (old_granularity + 1)..=new_granularity {
                let hi_block_base = (ptr as u64).wrapping_add(hi_block_size);
                books.add_block(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    NonNull::new_unchecked(hi_block_base as *mut _)
                );

                hi_block_size >>= 1;
            }
        } else if tgt_size > old_size {
            // if size is bigger, check buddies recursively, if available, reserve them, else alloc and dealloc
            // follows a similar routine to dealloc

            // this stores (base, bitmap_offset) per granularity - it does, however, make the stack frame massive
            let mut chopping_block = [(0, 0); GRANULARITY];

            let mut base = ptr as u64;
            let mut size = old_size;
            let mut bitmap_offset = self.bitmap_offset(base, size);

            for granularity in ((new_granularity + 1)..=old_granularity).rev() {
                if books.read_bitflag(bitmap_offset) { // while buddy is available
                    *chopping_block.get_unchecked_mut(granularity) = (base, bitmap_offset);
    
                    if self.is_lower_buddy(base, size) { base = base.wrapping_sub(size); }
                    size <<= 1;
                    bitmap_offset = self.bitmap_offset(base, size);
                } else {
                    // cannot realloc in place, simply allocate and copy
                    drop(books);
                    let allocd = self.alloc(Layout::from_size_align_unchecked(new_size, layout.align()));
                    ptr::copy_nonoverlapping(ptr, allocd, layout.size());
                    self.dealloc(ptr, layout);
                    return allocd;
                }
            }

            // the buddies were available - delist them
            for granularity in ((new_granularity + 1)..=old_granularity).rev() {
                let (base, bitmap_offset) = *chopping_block.get_unchecked_mut(granularity);
                books.remove_block(granularity, bitmap_offset, NonNull::new_unchecked(base as _));
            }
        }

        ptr
    }
}
