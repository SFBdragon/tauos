use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout, Allocator, AllocError},
    fmt::Debug,
    intrinsics::assume, ops::Range,
};
use crate::utils::{self, llist::LlistNode};
use spin::{Mutex, MutexGuard};

/// Limit imposed by the AMD64 linear address space.
pub const MAXIMUM_ARENA_SIZE: usize = 1 << 48;


/// Returns whether the block of the given base is the lower of its buddy pair.
#[inline]
fn is_lower_buddy(block_base: *mut u8, size: usize) -> bool {
    block_base as usize & size == 0
}


/// # Talloc: The TauOS Allocator
/// 
/// ### Features:
/// * Low time complexity and maximizing performance at the cost of memory usage
/// * Minimization of external fragmentation at the cost of internal fragmentation
/// * Arena can wrap around the address space, including `null` if desired.
/// See below for more info.
/// 
/// ### Allocator design:
/// * **O(log n)** worst case allocation and deallocation performance.
/// * **O(2^n)** memory usage, at most `arena size / 128 + k`, where k is small.
/// * **buddy allocation** thus will *always* allocate in powers of two.
/// * **linked free-lists** the headers' slice must be stored seperately.
/// * **bitmap**: the bitmap slice must be stored seperately.
/// 
/// Note that the extra slices can be stored within the arena, 
/// as long as they remain reserved.
/// 
/// ### Allocator usage:
/// Intantiation functions treat the arena as entirely reserved, allowing arenas 
/// to be created over memory invalid for reads/writes. However, attempting to 
/// allocate in this state will fail. 
/// * `Talloc::release` must be used, see its docs for more.
/// * `Talloc::reserve` can be used thereafter, see it's docs for caveats.
/// 
/// 
/// ### Null handling:
/// Due to the fact that the arena is allowed to start at/overlap with zero/null, 
/// this should be taken into account when releasing memory, as while the
/// internal interface is happy to allocate valid zero-pointers, `GlobalAlloc`
/// and `Allocator` interfaces do not allow this. The latter will error, the
/// former will return the zero-pointer, however this is indistinguishable
/// from the behaviour of running out of memory. Hence, do not `release`
/// a span covering null if you wish to use these interfaces.
/// Failing to do so is, however, safe.
#[derive(Debug)]
pub struct Talloc {
    /// The base pointer of the arena.
    arena_base: isize,
    /// The size of the arena in bytes.
    arena_size: usize,
    /// The next power-of-two size of the arena in bytes.
    arena_size_pow2: usize,
    /// The leading zero count of arena size.
    arena_size_pow2_lzcnt: u32,
    /// The power-of-two size of the smallest allocatable block in bytes.
    smlst_block: usize,

    /// Tracks memory block availability in the linked lists. Bit index corresponds to granularity.
    // This mechanism caps maximum granularity at 64, however that is already well beyond impractical.
    avails: usize,
    /// The sentinels of the linked lists that each hold available fixed-size 
    /// memory blocks per granularity at an index.
    llists: *mut [LlistNode<()>],
    /// Describes occupation of memory blocks in the arena.
    /// 
    /// Bitfield of length `1 << llists.len()` in bits, where each granularity has a bit for each buddy,
    /// offset from the base by that width in bits. Where digits represent each bit for a certain
    /// granularity: `01223333_44444444_55555555_55555555_6...` and so on. Buddies are represented from
    /// low addresses to high addresses.
    /// * Clear bit indicates homogeneity: both or neither are allocated.
    /// * Set bit indicated heterogeneity: one buddy is allocated.
    bitmap: *mut [u8],
}

impl Talloc {
    /// Returns the corresponding granularity for a given block size.
    #[inline]
    fn block_granularity(&self, size: usize) -> usize {
        // effectively computing: arena_size_pow2.log2() - size.log2()
        (size.leading_zeros() - self.arena_size_pow2_lzcnt) as usize
    }

    /// Returns the offset in bits into the bitmap that indicates the block's buddy status.
    /// ### Safety:
    /// `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: *mut u8, size: usize) -> usize {
        // offset of the granularity's field, plus, offset into the field
        // arena_size_pow2 >> (log2(block_size) + 1), plus,
        // block_size - (arena_base &!(size - 1)) >> (log2(block_size) + 1)
        // (Precalculating `arena_size_pow2`, approximately halves generated assembly.)
        (
            self.arena_size_pow2 + 
            (base as isize - (self.arena_base & !(size as isize-1))) as usize
        ) >> utils::fast_non0_log2(size)+1
    }
    /// Utility function to read the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: usize) -> bool {
        *self.bitmap.get_unchecked_mut(
            bitmap_offset >> u8::BITS.trailing_zeros()
        ) & 1 << (bitmap_offset & u8::BITS as usize - 1) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: usize) {
        *self.bitmap.get_unchecked_mut(
            bitmap_offset >> u8::BITS.trailing_zeros()
        ) ^= 1 << (bitmap_offset & u8::BITS as usize - 1);
    }

    /// Registers a block into the books, making it available for allocation.
    /// ### Safety:
    /// `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn add_block_next(&mut self, granularity: usize, bitmap_offset: usize, 
    node: *mut LlistNode<()>) {
        // populating llist
        self.avails |= 1 << granularity;

        // add node to llist
        // SAFETY: guaranteed by caller
        let sentinel = self.llists.get_unchecked_mut(granularity);
        LlistNode::new(node, sentinel, (*sentinel).next.get(), ());

        // toggle bitmap flag
        // SAFETY: guaranteed by caller
        self.toggle_bitflag(bitmap_offset);
    }
    /// Unregisters the next block in the free list, reserving it against 
    /// allocation, and returning the base.
    /// ### Safety:
    /// * `granularity`'s linked list must have a nonsentinel element: 
    /// `avails` at bit `granularity` should be `1`.
    /// * `size` must agree with `granularity`'s corresponding block size.
    #[inline]
    unsafe fn remove_block_next(&mut self, granularity: usize, size: usize) -> *mut u8 {
        let sentinel = self.llists.get_unchecked_mut(granularity);
        if (*sentinel).prev == (*sentinel).next {
            // last nonsentinel block in llist, toggle off avails flag
            self.avails &= !(1 << granularity);
        }
        
        // remove node from llist
        // SAFETY: caller guaranteed
        let node = (*sentinel).next.get();
        LlistNode::remove(node);
        
        // toggle bitmap flag
        // SAFETY: caller guaranteed
        self.toggle_bitflag(self.bitmap_offset(node.cast(), size));
        node.cast()
    }
    /// Unregisters a block from the free list, reserving it against allocation.
    /// 
    /// To reserve a block from the linked list directly (which this API does not allow),
    /// consider instead using `remove_block_next(...)`.
    /// ### Safety:
    /// * `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn remove_block(&mut self, granularity: usize, bitmap_offset: usize,
    node: *mut LlistNode<()>) {
        if (*node).prev == (*node).next {
            // last nonsentinel block in llist, toggle off avails flag
            self.avails &= !(1 << granularity);
        }

        // remove node from llist
        // SAFETY: caller guaranteed
        LlistNode::remove(node);

        // toggle bitmap flag
        // SAFETY: caller guaranteed
        self.toggle_bitflag(bitmap_offset);
    }

    
    /// Takes a `Layout` and outputs a block size that is:
    /// * Nonzero
    /// * A power of two
    /// * Not smaller than smlst_block
    /// * Not smaller than `layout.size`
    /// * Sufficiently aligned
    /// 
    /// In other words, it ensures Talloc's size requirements are met.
    /// 
    /// ### Safety:
    /// `layout.size` must be nonzero.
    #[inline]
    unsafe fn layout_to_size(&self, layout: Layout) -> usize {
        // Get the maximum between the required size as a power of two, the smallest allocatable,
        // and the alignment. The alignment being larger than the size is a rather esoteric case,
        // which is handled by simply allocating a larger size with the required alignment. This
        // may be highly memory inefficient for very bizarre scenarios.
        utils::fast_non0_prev_pow2( // SAFETY: caller guaranteed
            utils::fast_non0_next_pow2(layout.size())
            | layout.align()
            | self.smlst_block
        )
    }



    /// Guaratees the following:
    /// * `arena_size` and `smallest_allocatable_size` are > zero.
    /// * `arena_size.next_power_of_two()` does not overflow.
    /// * `smallest_block` is a powers of two.
    /// * `smallest_block` is larger or equal to the size of a `LlistNode<()>`.
    /// * `LlistNode<()>` has the expected size.
    fn validate_arena_args(arena_size: usize, smallest_block: usize) {
        use core::mem;
        
        assert!(arena_size > 0,
            "arena_size must be > zero.");
        assert!(arena_size <= MAXIMUM_ARENA_SIZE,
            "arena_size must be <= talloc::MAXIMUM_ARENA_SIZE.");
        assert!(smallest_block > 0,
            "smallest_block must be > zero.");
        assert!(smallest_block.count_ones() == 1,
            "smallest_block must be a power of two.");
        
        assert!(mem::size_of::<*mut u8>() * 2 == mem::size_of::<LlistNode<()>>());
        assert!(smallest_block >= mem::size_of::<LlistNode<()>>(),
            "smallest_block must be greater or equal the size of two pointers.");
    }
    
    /// Returns `llists` length and `bitmap` length respectively.
    pub fn slice_lengths(arena_size: usize, smallest_block: usize) -> (usize, usize) {
        Self::validate_arena_args(arena_size, smallest_block);

        // validate_arena_args guarantees `arena_size` and `smallest_block` are non-zero
        // and that `arena_size.next_power_of_two()` does not overflow
        let llists_len = ((arena_size - 1).log2() + 1) - smallest_block.log2() + 1;
        let bitmap_len = 1usize << llists_len >> u8::BITS.trailing_zeros();

        (llists_len as usize, if bitmap_len != 0 { bitmap_len } else { 1 })
    }

    /// Create a new `Talloc`.
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths should equal `Talloc::slice_lengths`'s values.
    /// * `16 <= smallest_block`
    /// * `0 < arena_size <= MAXIMUM_ARENA_SIZE`
    /// * The arena may wrap around the address space.
    pub fn new(arena_base: *mut u8, arena_size: usize, smallest_block: usize,
    llists: *mut [LlistNode<()>], bitmap: *mut [u8]) -> Self {
        // verify arena validity
        Self::validate_arena_args(arena_size, smallest_block);
        // verify slice lengths' validity
        let slice_lengths = Self::slice_lengths(arena_size, smallest_block);
        assert_eq!(slice_lengths.0, llists.len());
        assert_eq!(slice_lengths.1, bitmap.len());

        // initialize slices
        unsafe {
            bitmap.as_mut_ptr().write_bytes(0, bitmap.len());
            for i in 0..llists.len() {
                LlistNode::new_llist(llists.as_mut_ptr().wrapping_add(i), ());
            }
        }

        let arena_size_pow2 = (arena_size as usize).next_power_of_two();
        Self {
            arena_base: arena_base as isize,
            arena_size: arena_size,
            arena_size_pow2: arena_size_pow2,
            arena_size_pow2_lzcnt: arena_size_pow2.leading_zeros(),
            smlst_block: smallest_block,
            avails: 0,
            llists,
            bitmap,
        }
    }



    /// Returns a closed range describing the span of memory conservatively 
    /// in terms of smallest allocatable units. Address-space wraparound is allowed.
    /// 
    /// A primary use case for this bounding method is the releasing of the 
    /// arena according to available blocks of memory. Conservative bounding 
    /// ensures that only available memory is described as available.
    /// ### Arguments:
    /// * `size` should not be smaller than `smallest_block`.
    #[inline]
    pub fn bound_available(&self, base: *mut u8, size: usize) -> Range<isize> {
        assert!(size >= self.smlst_block);
        let sbm1 = (self.smlst_block-1) as isize;
        
        (base as isize + sbm1 & !sbm1)..
        (base as isize + size as isize & !sbm1)
    }
    /// Returns a closed range describing the span of memory liberally 
    /// in terms of smallest allocatable units. Address-space wraparound is allowed.
    /// 
    /// A primary use case for this bounding method is the reserving and 
    /// subsequent releasing of memory within the arena once already released. 
    /// Liberal bounding ensures that no unavailable memory is described as available.
    /// ### Arguments:
    /// * `size` should not be zero, but it can be smaller than `smallest_block`.
    #[inline]
    pub fn bound_reserved(&self, base: *mut u8, size: usize) -> Range<isize> {
        assert!(size != 0);
        let sbm1 = (self.smlst_block-1) as isize;

        (base as isize & !sbm1)..
        (base as isize + size as isize + sbm1 & !sbm1)
    }

    /// Reserve released memory against use within half-open `span`.
    /// Address-space wraparound is allowed.
    /// 
    /// `span` is expected to be the result of `bound_available(...)` 
    /// or `bound_reserved(...)`.
    /// ### Performance:
    /// This function has potentially poor performance where `span`'s fields 
    /// are poorly aligned (time complexity 2^n, where n is proportional to 
    /// the smallest trailing zero count). Accounting for this is recommended 
    /// if this function is to be used in a hotter path.
    /// 
    /// ### Safety:
    /// The memory within `bound` must be entirely available for allocation.
    pub unsafe fn reserve(&mut self, span: Range<isize>) {
        // Strategy:
        // - Loop through all available block nodes to the smallest granularity 
        //   possible given bound alignment
        // - On encountering a fully contained block, reserve it
        // - On encountering a partially contained block, break it down, 
        //   reserving it within the bound

        // validity checks
        debug_assert!(span.start != span.end);
        debug_assert!(span.start >= self.arena_base);
        debug_assert!(span.end <= (self.arena_base + self.arena_size as isize));
        debug_assert!(span.start as usize & self.smlst_block-1 == 0);
        debug_assert!(span.end as usize & self.smlst_block-1 == 0);

        // Caller guarantees that no allocations are made within the span, and
        // that all memory therein is available. Hence it can be assumed that all 
        // relevant blocks will be aligned at least as well as the bounds. Thus 
        // greater granularities than that of the bounds need not be checked.
        let base_granularity = self.block_granularity(1 << span.start.trailing_zeros());
        let acme_granularity = self.block_granularity(1 << span.end.trailing_zeros());
        let finest_granularity = base_granularity.max(acme_granularity);
        
        let mut block_size = self.arena_size_pow2;
        for granularity in 0..finest_granularity {
            let sentinel = self.llists.get_unchecked_mut(granularity);
            for node in LlistNode::iter_mut(sentinel) {
                let block_base = node as isize;
                let block_end = block_base + block_size as isize;
                
                if span.start <= block_base && block_end <= span.end {
                    // this block is entirely reserved
                    self.remove_block(
                        granularity, 
                        self.bitmap_offset(block_base as *mut _, block_size), 
                        node
                    );

                    // return if block represents the entire reserved area
                    if span.start == block_base && span.end == block_end { return; }
                } else {
                    // handle partial containment cases
                    let is_first_contained = block_base < span.start && span.start < block_end;
                    let is_last_contained = block_base < span.end && span.end < block_end;

                    if is_first_contained || is_last_contained {
                        self.remove_block(
                            granularity, 
                            self.bitmap_offset(block_base as *mut _, block_size), 
                            node
                        );
                    }
                    
                    if is_first_contained {
                        // restore free memory from the bottom
                        let mut base = block_base;
                        let mut delta = (span.start - base) as usize;
                        while delta > 0 {
                            let block_size = utils::fast_non0_prev_pow2(delta);
                            delta -= block_size;

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(base as *mut _, block_size),
                                base as *mut _,
                            );

                            base += block_size as isize;
                        }
                    }
                    
                    if is_last_contained {
                        // restore free memory from the top
                        let mut acme = block_end;
                        let mut delta = (acme - span.start) as usize;
                        while delta > 0 {
                            let block_size = utils::fast_non0_prev_pow2(delta);
                            delta -= block_size;
                            acme -= block_size as isize;

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(acme as *mut _, block_size),
                                acme as *mut _,
                            );
                        }
                    }
                }
            }
            block_size >>= 1;
        }
    }

    /// Release reserved memory for use within half-open `span`.
    /// Address-space wraparound is allowed.
    /// 
    /// `span` is expected to be the result of `bound_available(...)` 
    /// or `bound_reserved(...)`.
    /// ### Safety:
    /// * The memory inclusively within `bound` must be unallocatable (reserved).
    /// * All the memory inclusively within `bound` must be safely readable and writable.
    pub unsafe fn release(&mut self, span: Range<isize>) {
        // Strategy:
        // - Start address at the base of the bounds
        // - Allocate as large a block as possible repeatedly, bump address
        // - Do so until adding a larger block would overflow the top bound; then continue
        // - Allocate the previous power of two of the delta between current address and top + smlst, bump address
        // - When the delta is zero, the bounds have been entirely filled

        // validity checks
        debug_assert!(span.start != span.end);
        debug_assert!(span.start >= self.arena_base);
        debug_assert!(span.end <= (self.arena_base + self.arena_size as isize));
        debug_assert!(span.start as usize & self.smlst_block-1 == 0);
        debug_assert!(span.end as usize & self.smlst_block-1 == 0);
        
        let mut base = span.start;
        let mut asc_block_sizes = true;
        loop {
            let block_size = if asc_block_sizes {
                let block_size = 1 << base.trailing_zeros();

                if base + block_size as isize <= span.end {
                    block_size
                } else {
                    asc_block_sizes = false;
                    continue;
                }
            } else {
                let delta = (span.end - base) as usize;
                if delta >= self.smlst_block {
                    // SAFETY: smlst_block is never zero
                    utils::fast_non0_prev_pow2(delta)
                } else {
                    break;
                }
            };
            
            // SAFETY: deallocating reserved memory is valid and memory safe
            self.dealloc(base as *mut u8, block_size);

            base += block_size as isize;
        }
    }

    
    /// Allocate memory. 
    /// 
    /// Allocations are guaranteed to be a power of two in size, size-aligned,
    /// not smaller than `layout.size()`.
    /// 
    /// Returns `Err` upon memory exhaustion.
    /// May return a *valid* zero-pointer. See `Talloc` docs for more info.
    /// ### Safety:
    /// * `size` must be a nonzero power of two.
    /// * `size` must not be smaller than `smallest_block`.
    pub unsafe fn alloc(&mut self, size: usize) -> Result<*mut u8, AllocError> {
        // SAFETY: caller guaranteed
        assume(size != 0);
        assume(size.is_power_of_two());
        
        let granularity = self.block_granularity(size);

        // Allocate immediately if a block of the correct size is available
        if self.avails & 1 << granularity != 0 {
            return Ok(self.remove_block_next(granularity, size) as *mut u8);
        }

        // find a larger block to break apart:
        let larger_avl = self.avails & !(usize::MAX << granularity);
        if larger_avl == 0 { return Err(AllocError); } // not enough memory
        
        let lgr_granularity = utils::fast_non0_log2(larger_avl);
        let lgr_size = self.arena_size_pow2 >> lgr_granularity;
        let lgr_base = self.remove_block_next(lgr_granularity, lgr_size);

        // break down the large block into smaller blocks
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            let hi_block_base = lgr_base.wrapping_add(hi_block_size);

            // SAFETY: https://yewtu.be/watch?v=rp8hvyjZWHs
            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                hi_block_base.cast()
            );

            hi_block_size >>= 1;
        }

        Ok(lgr_base)
    }

    /// Deallocate the block of memory.
    /// ### Safety:
    /// `ptr` must have been previously acquired, given `size`.
    pub unsafe fn dealloc(&mut self, mut ptr: *mut u8, mut size: usize) {
        // SAFETY: caller guaranteed
        assume(size != 0);
        assume(size.is_power_of_two());

        //let mut size = size as isize;
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(ptr, size);
        
        while self.read_bitflag(bitmap_offset) { // while buddy was heterogenous - available
            let buddy_ptr: *mut u8;
            let next_ptr: *mut u8;
            if is_lower_buddy(ptr, size) {
                buddy_ptr = ptr.wrapping_add(size);
                next_ptr = ptr;
            } else {
                buddy_ptr = ptr.wrapping_sub(size);
                next_ptr = ptr.wrapping_sub(size);
            }

            // SAFETY: buddy has been confirmed to exist here, LlistNodes are not moved
            self.remove_block(
                granularity, 
                bitmap_offset, 
                buddy_ptr.cast()
            );
            
            size <<= 1;
            ptr = next_ptr;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(ptr, size);
        }

        self.add_block_next(
            granularity, 
            bitmap_offset, 
            ptr.cast()
        );
    }

    /// Grow the block of memory provided.
    /// 
    /// Allocations are guaranteed to be a power of two in size, size-aligned,
    /// not smaller than `new_layout.size()`.
    /// 
    /// Returns `Err` upon memory exhaustion. 
    /// May return a *valid* null pointer. See `Talloc` docs for more info.
    /// ### Safety:
    /// * Both sizes must be nonzero powers of two not smaller than `smallest_block`.
    /// * `old_size` must be smaller than `new_size`.
    /// * `ptr` must have been previously acquired, given `old_size`.
    pub unsafe fn grow(&mut self, ptr: *mut u8, old_size: usize, new_size: usize)
    -> Result<*mut u8, AllocError> {
        // SAFETY: caller guaranteed
        assume(old_size != 0);
        assume(old_size.is_power_of_two());
        assume(new_size != 0);
        assume(new_size.is_power_of_two());

        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(new_size);
        
        // Check high buddies recursively, if available, reserve them, else realloc.
        // This satisfies the requirement on Allocator::grow that the memory
        // must not be modified or reclaimed if Err is returned.

        let mut size = old_size;
        let mut bitmap_offset = self.bitmap_offset(ptr, size);
        let mut granularity = old_granularity;

        while granularity > new_granularity {
            // realloc is necessary:
            // * if this is a high buddy and a larger block is required
            // * if the high buddy is not available and a larger block is required
            if !is_lower_buddy(ptr, size) || !self.read_bitflag(bitmap_offset) {
                let allocation = self.alloc(new_size);
                if let Ok(alloc_ptr) = allocation {
                    ptr::copy_nonoverlapping(ptr, alloc_ptr, old_size);
                    self.dealloc(ptr, old_size);
                }
                return allocation;
            }
            
            size <<= 1;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(ptr, size);
        }

        // reiterate, having confirmed there is sufficient memory available
        // remove all buddy nodes as necessary
        let mut size = old_size;
        let mut granularity = old_granularity;
        while granularity > new_granularity {
            self.remove_block(
                granularity,
                self.bitmap_offset(ptr, size),
                ptr.wrapping_add(size).cast()
            );

            size <<= 1;
            granularity -= 1;
        }

        Ok(ptr)
    }

    /// Shrink the block of memory provided.
    /// 
    /// Allocations are guaranteed to be a power of two in size, size-aligned,
    /// not smaller than `new_layout.size()`.
    /// ### Safety:
    /// * Both sizes must be nonzero powers of two not smaller than `smallest_block`.
    /// * `old_size` must be larger than `new_size`.
    /// * `ptr` must have been previously acquired, given `old_size`.
    pub unsafe fn shrink(&mut self, ptr: *mut u8, old_size: usize, new_size: usize) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(old_size != 0);
        assume(old_size.is_power_of_two());
        assume(new_size != 0);
        assume(new_size.is_power_of_two());
        
        // break up the block until the required size is reached
        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(new_size);

        let mut hi_block_size = old_size >> 1;
        for hi_granularity in (old_granularity + 1)..=new_granularity {
            let hi_block_base = ptr.wrapping_add(hi_block_size);

            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                hi_block_base.cast()
            );

            hi_block_size >>= 1;
        }

        ptr
    }
}


/// Concurrency synchronisation layer on top of `Talloc`, see its documentation for more.
/// 
/// This is just a thin wrapper containing a spin mutex which implements the allocator
/// traits. The underlying allocator does not have any internal synchoronisation, which
/// may be subject to improvement.
#[derive(Debug)]
pub struct Tallock(spin::Mutex<Talloc>);

impl Tallock {
    /// Returns an invalid `Tallock`. This can be useful for initializing 
    /// static, mutable variables.
    /// 
    /// Alternatively consider using `Tallock::new(...)`.
    /// ### Safety: 
    /// It is undefined behaviour to access fields/call any methods on the result hereof.
    pub const unsafe fn new_invalid() -> Self {
        Self(Mutex::new(Talloc {
            arena_base: 0,
            arena_size_pow2: 0,
            arena_size_pow2_lzcnt: 0,
            arena_size: 0,
            smlst_block: 0,
            avails: 0,
            llists: NonNull::<[_; 0]>::dangling().as_ptr(),
            bitmap: NonNull::<[_; 0]>::dangling().as_ptr(),
        }))
    }

    /// Create a new `Tallock`. Access the inner `Talloc` via `.lock()`.
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths should equal `Talloc::slice_lengths`'s values.
    /// * `16 <= smallest_block`
    /// * `0 < arena_size <= MAXIMUM_ARENA_SIZE`
    /// * The arena may wrap around the address space.
    pub fn new(arena_base: *mut u8, arena_size: usize, smallest_block: usize,
    llists: *mut [LlistNode<()>], bitmap: *mut [u8]) -> Self {
        Self(Mutex::new(Talloc::new(
            arena_base, 
            arena_size, 
            smallest_block, 
            llists, 
            bitmap,
        )))
    }

    /// Acquire the lock on the `Talloc`.
    #[inline]
    pub fn lock(&self) -> MutexGuard<Talloc> {
        self.0.lock()
    }
}

unsafe impl GlobalAlloc for Tallock {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let mut talloc = self.lock();
        let size = talloc.layout_to_size(layout);
        talloc.alloc(size).unwrap_or(core::ptr::null_mut())
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        let mut talloc = self.lock();
        let size = talloc.layout_to_size(layout);
        talloc.dealloc(ptr, size);
    }
    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let mut talloc = self.lock();
        // SAFETY: caller guaranteed
        let size = talloc.layout_to_size(layout);
        let ptr = talloc.alloc(size).unwrap_or(core::ptr::null_mut());

        if !ptr.is_null() {
            ptr.write_bytes(0, layout.size());
        }
        ptr
    }
    unsafe fn realloc(&self, ptr: *mut u8, old_layout: Layout, new_size: usize) -> *mut u8 {
        let talloc = self.lock();
        // SAFETY: caller guaranteed
        let old_size = talloc.layout_to_size(old_layout);
        let new_size = utils::fast_non0_prev_pow2(
            utils::fast_non0_next_pow2(new_size)
            | talloc.smlst_block
        );

        if old_size < new_size {
            self.lock().grow(ptr, old_size, new_size)
                .unwrap_or(core::ptr::null_mut())
        } else if old_size > new_size {
            self.lock().shrink(ptr, old_size, new_size)
        } else {
            ptr
        }
    }
}

unsafe impl Allocator for Tallock {
    fn allocate(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        if layout.size() != 0 {
            let mut talloc = self.lock();
            // SAFETY: layout.size is nonzero
            let size = unsafe { talloc.layout_to_size(layout) };
            let allocated = unsafe { talloc.alloc(size)? };
            if let Some(ptr) = NonNull::new(allocated) {
                Ok(NonNull::slice_from_raw_parts(ptr, layout.size()))
            } else {
                panic!("Null pointer returned by Talloc through Allocator interface.")
            }
        } else {
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }

    unsafe fn deallocate(&self, ptr: NonNull<u8>, layout: Layout) {
        if ptr != NonNull::dangling() {
            let mut talloc = self.lock();
            // SAFETY: layout.size() is not nonzero if ptr not dangling
            let size = talloc.layout_to_size(layout);
            talloc.dealloc(ptr.as_ptr(), size)
        }
    }

    unsafe fn grow(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        if old_layout.size() != 0 {
            let talloc = self.lock();
            // SAFETY: caller guaranteed
            let old_size = talloc.layout_to_size(old_layout);
            let new_size = talloc.layout_to_size(new_layout);

            let growed = self.lock().grow(ptr.as_ptr(), old_size, new_size)?;
            if let Some(ptr) = NonNull::new(growed) {
                Ok(NonNull::slice_from_raw_parts(
                    ptr, 
                    new_layout.size()
                ))
            } else {
                panic!("Null pointer returned by Talloc through Allocator interface.")
            }
        } else {
            self.allocate(new_layout)
        }
    }

    unsafe fn grow_zeroed(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        let slice = self.grow(ptr, old_layout, new_layout)?;
        slice.as_non_null_ptr().as_ptr()
            .add(old_layout.size())
            .write_bytes(0, new_layout.size() - old_layout.size());
        Ok(slice)
    }

    unsafe fn shrink(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        if new_layout.size() != 0 {
            let talloc = self.lock();
            // SAFETY: caller guaranteed
            let old_size = talloc.layout_to_size(old_layout);
            let new_size = talloc.layout_to_size(new_layout);


            Ok(NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(
                    self.lock().shrink(ptr.as_ptr(), old_size, new_size)
                ),
                new_layout.size(),
            ))
        } else {
            self.deallocate(ptr, old_layout);
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }
}

