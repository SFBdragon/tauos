use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout, Allocator, AllocError},
    fmt::Debug,
    intrinsics::assume,
};
use crate::utils::llist::LlistNode;
use spin::{Mutex, MutexGuard};


/// ### Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_log2(val: usize) -> usize {
    assume(val != 0);
    usize::BITS as usize - 1 ^ val.leading_zeros() as usize
}
/// ### Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_prev_pow2(val: usize) -> usize {
    assume(val != 0);
    1 << fast_non0_log2(val)
}
/// ### Safety:
/// `val` must be nonzero 
#[inline]
const unsafe fn fast_non0_next_pow2(val: usize) -> usize {
    assume(val != 0);
    1 << u64::BITS - (val - 1).leading_zeros() 
}


/// Returns whether the block of the given base is the lower of its buddy pair.
#[inline]
fn is_lower_buddy(block_base: *mut u8, size: usize) -> bool {
    block_base.to_bits() & size == 0
}
/// Returns the offset in bits into the bitmap that indicates the block's buddy status.
/// ### Safety:
/// `size` must be nonzero
#[inline]
unsafe fn bitmap_offset(arena_base: usize, arena_size_pow2: usize, 
block_base: usize, block_size: usize) -> usize {
    // offset of the granularity into the field, plus, offset into the granularity
    // arena_size_pow2 >> (log2(block_size) + 1), plus,
    // block_size - (arena_base &!(size - 1)) >> (log2(block_size) + 1)
    // Precalculating `arena_size_pow2`, approximately halves generated assembly.
    arena_size_pow2 + (block_base - (arena_base & !(block_size - 1)))
    >> fast_non0_log2(block_size) + 1
}


/// # `Talloc`
/// 
/// ### Built to prioritise:
/// * low time complexity and maximising performance at the cost of memory usage
/// * minimization of external fragmentation at the cost of internal fragmentation
/// * suitability for diverse use-cases
/// 
/// ### Allocator design:
/// * **O(log n)** worst case allocation and deallocation performance.
/// * **O(2^n)** memory usage, where the 2^n component is at most `arena size / 128`.
/// * **buddy allocation**: it uses a system of multiple levels of power-of-two size memory
/// blocks which are split and joined to form smaller and larger allocatable blocks.
/// * **linked-lists**: it uses arena-embedded free-lists to keep track of available memory.
/// * **bitmap** employment: a field of bits to track block buddy status across granularities.
/// 
/// ### Allocator usage:
/// Intantiation functions treat the arena as entirely reserved, allowing arenas to be created
/// over memory that cannot be written to. However, attempting to allocate in this state will
/// cause allocations to fail. 
/// `Talloc::release` must be used, see its documentation for more.
#[derive(Debug)]
pub struct Talloc {
    /// The base of the arena as an address.
    arena_base: NonNull<u8>,
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
    llists: NonNull<[LlistNode<()>]>,
    /// Describes occupation of memory blocks in the arena.
    /// 
    /// Bitfield of length `1 << llists.len()` in bits, where each granularity has a bit for each buddy,
    /// offset from the base by that width in bits. Where digits represent each bit for a certain
    /// granularity: `01223333_44444444_55555555_55555555_6...` and so on. Buddies are represented from
    /// low addresses to high addresses.
    /// * Clear bit indicates homogeneity: both or neither are allocated.
    /// * Set bit indicated heterogeneity: one buddy is allocated.
    bitmap: NonNull<[u8]>,
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
        bitmap_offset(
            self.arena_base.as_ptr().to_bits(), 
            self.arena_size_pow2, 
            base.to_bits(), 
            size
        )
    }
    /// Utility function to read the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: usize) -> bool {
        *self.bitmap.get_unchecked_mut(
            bitmap_offset >> u8::BITS.trailing_zeros()
        ).as_ptr() as usize & 1 << (bitmap_offset & u8::BITS as usize - 1) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: usize) {
        *self.bitmap.get_unchecked_mut(
            bitmap_offset >> u8::BITS.trailing_zeros()
        ).as_ptr() ^= 1 << (bitmap_offset & u8::BITS as usize - 1);
    }

    /// Registers a block into the books, making it available for allocation.
    /// ### Safety:
    /// `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn add_block_next(&mut self, granularity: usize, bitmap_offset: usize, 
    node: NonNull<LlistNode<()>>) {
        // populating llist
        self.avails |= 1 << granularity;

        // add node to llist
        // SAFETY: guaranteed by caller
        let sentinel = self.llists.get_unchecked_mut(granularity);
        LlistNode::new(node, sentinel, (*sentinel.as_ptr()).next.get(), ());

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
        let node = (*sentinel.as_ptr()).next.get();
        if (*node.as_ptr()).prev == (*node.as_ptr()).next {
            // last nonsentinel block in llist, toggle off avails flag
            self.avails &= !(1 << granularity);
        }
        
        // remove node from llist
        // SAFETY: caller guaranteed
        LlistNode::remove(node);
        
        // toggle bitmap flag
        // SAFETY: caller guaranteed
        self.toggle_bitflag(self.bitmap_offset(node.as_ptr().cast(), size));
        node.as_ptr().cast()
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
    node: NonNull<LlistNode<()>>) {
        if (*node.as_ptr()).prev == (*node.as_ptr()).next {
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


    /// Guaratees the following:
    /// * `arena_size` and `smallest_allocatable_size` is non-zero.
    /// * `arena_size.next_power_of_two()` does not overflow.
    /// * `smallest_block` is a powers of two.
    /// * `smallest_block` is larger or equal to the size of a `LlistNode<()>`
    /// * `LlistNode<()>` has the expected size.
    fn validate_arena_args(arena_size: usize, smallest_block: usize) {
        use core::mem;
        
        assert!(arena_size != 0,
            "arena_size must be non-zero.");
        assert!(arena_size <= 1 << usize::BITS - 1,
            "arena_size.next_power_of_two() may not overflow.");
        assert!(smallest_block != 0,
            "smallest_block must be non-zero.");
        assert!(smallest_block.count_ones() == 1,
            "smallest_block must be a power of 2.");
        
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
        let bitmap_len = 1usize << llists_len >> u8::BITS.trailing_zeros() as usize;

        (llists_len as usize, if bitmap_len != 0 { bitmap_len } else { 1 })
    }

    /// Create a new `Talloc`.
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths should equal `Talloc::slice_lengths`'s values.
    /// * `smallest_block` should be a power of two greater than the size of two pointers.
    /// * `arena_base + arena_size` should not overflow to greater than zero.
    /// * `arena_size` should be non-zero.
    /// * `arena_size.next_power_of_two()` should not overflow.
    /// 
    /// Failure to meet these requirements will result in a panic!
    pub fn new(arena_base: NonNull<u8>, arena_size: usize, smallest_block: usize,
    llists: NonNull<[LlistNode<()>]>, bitmap: NonNull<[u8]>) -> Self {
        // verify arena validity
        Self::validate_arena_args(arena_size, smallest_block);
        // ensure against overflow greater than zero
        assert!(arena_base.as_ptr().to_bits().checked_add(arena_size - 1).is_some());

        // verify slice lengths' validity
        let (llists_len, bitmap_len) = Self::slice_lengths(arena_size, smallest_block);
        assert_eq!(llists_len, llists.len());
        assert_eq!(bitmap_len, bitmap.len());

        // initialize slices
        unsafe {
            bitmap.as_mut_ptr().write_bytes(0, bitmap.len());
            for i in 0..llists.len() {
                LlistNode::new_llist(NonNull::new_unchecked(
                    llists.as_mut_ptr().wrapping_add(i)), ()
                );
            }
        }

        Self {
            arena_base,
            arena_size,
            arena_size_pow2: arena_size.next_power_of_two(),
            arena_size_pow2_lzcnt: arena_size.next_power_of_two().leading_zeros(),
            smlst_block: smallest_block,
            avails: 0,
            llists,
            bitmap,
        }
    }



    /// Returns a closed range describing the span of memory conservatively 
    /// in terms of smallest allocatable units.
    /// 
    /// A primary use case for this bounding method is the releasing of the 
    /// arena according to available blocks of memory. Conservative bounding 
    /// ensures that only available memory is described as available.
    /// ### Arguments:
    /// * `base.to_bits() + size` may overflow to zero.
    /// * `size` can be zero.
    #[inline]
    pub fn bound_available(&self, base: *mut u8, size: usize) -> (*mut u8, *mut u8) {
        let sbm1 = self.smlst_block - 1;
        if size < self.smlst_block {
            (   // return zero-length range, this is checked for later
                <*mut u8>::from_bits(base.to_bits() & !sbm1), 
                <*mut u8>::from_bits(base.to_bits() & !sbm1),
            )
        } else {
            (   // round up to first smlst block contained in the range
                <*mut u8>::from_bits(base.to_bits() + sbm1 & !sbm1),
                // last partial smlst block - 1
                <*mut u8>::from_bits((base.to_bits() + (size - self.smlst_block) & !sbm1) + sbm1)
            )
        }
    }
    /// Returns a closed range describing the span of memory liberally 
    /// in terms of smallest allocatable units.
    /// 
    /// A primary use case for this bounding method is the reserving and 
    /// subsequent releasing of memory within the arena once already released. 
    /// Liberal bounding ensures that no unavailable memory is described as available.
    /// ### Arguments:
    /// `base.to_bits() + size` may overflow to zero.
    /// * `size` can be zero.
    #[inline]
    pub fn bound_reserved(&self, base: *mut u8, mut size: usize) -> (*mut u8, *mut u8) {
        if size == 0 { size = 1; }
        let sbm1 = self.smlst_block - 1;

        (   // round down to first smlst block containing the range
            <*mut u8>::from_bits(base.to_bits() & !sbm1),
            // last partial smlst block + smb1
            <*mut u8>::from_bits((base.to_bits() + (size - 1) & !sbm1) + sbm1)
        )
    }

    /// Reserve released memory against use within `span`.
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
    pub unsafe fn reserve(&mut self, span: (*mut u8, *mut u8)) {
        // Strategy:
        // - Loop through all available block nodes to the smallest granularity possible given bound alignment
        // - On encountering a fully contained block, reserve it
        // - On encountering a partially contained block, break it down, reserving it within the bound
        //   - This is similar to the allocation routine of breaking down a block

        // validity checks
        debug_assert!(span.0 != span.1);
        debug_assert!(span.0 >= self.arena_base.as_ptr());
        debug_assert!(span.1 <= self.arena_base.as_ptr().add(self.smlst_block - 1));
        debug_assert!(span.0.to_bits() & self.smlst_block - 1 == 0);
        debug_assert!(span.1.to_bits() & self.smlst_block - 1 == self.smlst_block - 1);

        // Caller guarantees that no allocations are made within the span, and
        // that all memory therein is available. Hence it can be assumed that all 
        // relevant blocks will be aligned at least as well as the bounds. Thus 
        // greater granularities than that of the bounds need not be checked.
        let base_granularity = self.block_granularity(
            1 << span.0.to_bits().trailing_zeros());
        let acme_granularity = self.block_granularity(
            1 << span.1.to_bits().wrapping_add(1).trailing_zeros());
        let finest_granularity = base_granularity.max(acme_granularity);
        
        let mut block_size = self.arena_size_pow2;
        for granularity in 0..finest_granularity {
            let sentinel = self.llists.get_unchecked_mut(granularity);
            for node in LlistNode::iter_mut(sentinel) {
                let block_base = node.as_ptr().cast::<u8>();
                let block_end = block_base.add(block_size - 1);
                
                if span.0 <= block_base && span.1 > block_end {
                    // this block is entirely reserved
                    self.remove_block(
                        granularity, 
                        self.bitmap_offset(block_base, block_size), 
                        node
                    );

                    // return if block represents the entire reserved area
                    if span.0 == block_base && span.1 == block_end { return; }
                } else {
                    // handle partial containment cases
                    let is_first_contained = span.0 > block_base && span.1 < block_end;
                    let is_last_contained = span.0 > block_base && span.1 < block_end;

                    if is_first_contained || is_last_contained {
                        self.remove_block(
                            granularity, 
                            self.bitmap_offset(block_base, block_size), 
                            node
                        );
                    }
                    
                    if is_first_contained {
                        // restore free memory from the bottom
                        let mut base = block_base;
                        let mut delta = span.0.to_bits() - base.to_bits();
                        while delta > 0 {
                            let block_size = fast_non0_prev_pow2(delta);
                            delta -= block_size;

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(base, block_size),
                                NonNull::new_unchecked(base.cast()),
                            );

                            base = base.add(block_size);
                        }
                    }
                    
                    if is_last_contained {
                        // restore free memory from the top
                        let mut end = block_end;
                        let mut delta = end.to_bits() - span.0.to_bits();
                        while delta > 0 {
                            let block_size = fast_non0_prev_pow2(delta);
                            delta -= block_size;
                            end = end.sub(block_size);

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(end.add(1), block_size),
                                NonNull::new_unchecked(end.cast()),
                            );
                        }
                    }
                }
            }
            block_size >>= 1;
        }
    }

    /// Release reserved memory for use within `span`.
    /// 
    /// `span` is expected to be the result of `bound_available(...)` 
    /// or `bound_reserved(...)`.
    /// ### Safety:
    /// * The memory inclusively within `bound` must be unallocatable (reserved).
    /// * All the memory inclusively within `bound` must be safely readable and writable.
    pub unsafe fn release(&mut self, span: (*mut u8, *mut u8)) {
        // Strategy:
        // - Start address at the base of the bounds
        // - Allocate as large a block as possible repeatedly, bump address
        // - Do so until adding a larger block would overflow the top bound; then continue
        // - Allocate the previous power of two of the delta between current address and top + smlst, bump address
        // - When the delta is zero, the bounds have been entirely filled

        if span.0 == span.1 { return; }

        // validity checks
        debug_assert!(span.0 >= self.arena_base.as_ptr());
        debug_assert!(span.1 <= self.arena_base.as_ptr().add(self.smlst_block - 1));
        debug_assert!(span.0.to_bits() & self.smlst_block - 1 == 0);
        debug_assert!(span.1.to_bits() & self.smlst_block - 1 == self.smlst_block - 1);
        
        let mut base = span.0;
        let mut asc_block_sizes = true;
        loop {
            let block_size = if asc_block_sizes {
                let block_size = 1usize << base.to_bits().trailing_zeros();

                if base.add(block_size - 1) <= span.1 {
                    block_size
                } else {
                    asc_block_sizes = false;
                    continue;
                }
            } else {
                let delta = span.1.to_bits() - base.to_bits() + 1;
                if delta >= self.smlst_block {
                    // SAFETY: smlst_block is never zero
                    fast_non0_prev_pow2(delta)
                } else {
                    break;
                }
            };
            
            // SAFETY: deallocating reserved memory is valid and memory safe
            self.dealloc(
                base,
                Layout::from_size_align_unchecked(block_size, 1)
            );

            base = base.add(block_size);
        }
    }

    
    /// Allocate memory as described by the given layout.
    /// 
    /// Returns null to indicate memory exhaustion.
    /// ### Safety:
    /// `layout`'s size must be non-zero.
    pub unsafe fn alloc(&mut self, layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(layout.size() != 0);

        // Get the maximum between the required size as a power of two, the smallest allocatable,
        // and the alignment. The alignment being larger than the size is a rather esoteric case,
        // which is handled by simply allocating a larger size with the required alignment. This
        // may be highly memory inefficient for very bizarre scenarios.
        let size = fast_non0_prev_pow2( // SAFETY: val is never zero
            fast_non0_next_pow2(layout.size())
            | layout.align()
            | self.smlst_block
        );
        let granularity = self.block_granularity(size);

        // Allocate immediately if a block of the correct size is available
        if self.avails & 1 << granularity != 0 {
            return self.remove_block_next(granularity, size) as *mut u8;
        }

        // find a larger block to break apart - mask out bits for smaller blocks
        let larger_avl = self.avails & !(usize::MAX << granularity);
        if larger_avl == 0 { return ptr::null_mut(); } // not enough memory
        
        let lgr_granularity = fast_non0_log2(larger_avl);
        let lgr_size = self.arena_size_pow2 >> lgr_granularity;
        let lgr_base = self.remove_block_next(lgr_granularity, lgr_size);

        let mut hi_block_size = lgr_size >> 1;
        // break down the large block into smaller blocks until the required size is reached
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            let hi_block_base = lgr_base.wrapping_add(hi_block_size);

            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                NonNull::new_unchecked(hi_block_base.cast())
            );

            hi_block_size >>= 1;
        }

        lgr_base
    }

    /// Deallocate the block of memory.
    /// ### Safety:
    /// `ptr` must have been previously acquired, given `layout`.
    pub unsafe fn dealloc(&mut self, mut ptr: *mut u8, layout: Layout) {
        // SAFETY: caller guaranteed
        assume(layout.size() != 0);

        // Same process as allocate(), see docs there for rationale
        let mut size = fast_non0_prev_pow2(
            fast_non0_next_pow2(layout.size())
            | layout.align()
            | self.smlst_block
        );
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(ptr, size);
        
        while self.read_bitflag(bitmap_offset) { // while buddy was heterogenous - available
            let buddy_ptr: *mut u8;
            let next_ptr: *mut u8;
            if is_lower_buddy(ptr, size) {
                buddy_ptr = ptr.add(size);
                next_ptr = ptr;
            } else {
                buddy_ptr = ptr.sub(size);
                next_ptr = ptr.sub(size);
            }

            // SAFETY: buddy has been confirmed to exist here, LlistNodes are not moved
            self.remove_block(
                granularity, 
                bitmap_offset, 
                NonNull::new_unchecked(buddy_ptr.cast())
            );
            
            size <<= 1;
            ptr = next_ptr;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(ptr, size);
        }

        self.add_block_next(
            granularity, 
            bitmap_offset, 
            NonNull::new_unchecked(ptr.cast())
        );
    }

    /// Grow the block of memory provided.
    /// 
    /// Returns null to indicate memory exhaustion.
    /// 
    /// Books must be initialized.
    /// ### Safety:
    /// * `new_layout`'s size must be larger than or equal to `old_layout`'s.
    /// * `old_layout` and `new_layout`'s sizes must be non-zero.
    /// * `ptr` must have been previously acquired, given `old_layout`.
    pub unsafe fn grow(&mut self, ptr: *mut u8, old_layout: Layout, new_layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(old_layout.size() != 0);
        assume(new_layout.size() != 0);

        let old_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(old_layout.size())
            | old_layout.align()
            | self.smlst_block
        );
        let tgt_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(new_layout.size())
            | new_layout.align()
            | self.smlst_block
        );

        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(tgt_size);
        
        if tgt_size > old_size {
            // size is bigger, check hi buddies recursively, if available, reserve them, else alloc and dealloc
            // follows a remotely similar routine to dealloc

            let mut size = old_size;
            let mut bitmap_offset = self.bitmap_offset(ptr, size);
            let mut granularity = old_granularity;

            while granularity > new_granularity {
                // if this is a high buddy, and a further larger block is required, slow realloc is necessary
                // if the high buddy is not available and a further larger block is required, slow realloc is necessary
                if !is_lower_buddy(ptr, size) || !self.read_bitflag(bitmap_offset) {
                    let allocd = self.alloc(new_layout);
                    if allocd != ptr::null_mut() {
                        ptr::copy_nonoverlapping(ptr, allocd, old_layout.size());
                        self.dealloc(ptr, old_layout);
                    }
                    return allocd;
                }
                
                size <<= 1;
                granularity -= 1;
                bitmap_offset = self.bitmap_offset(ptr, size);
            }

            // reiterate, with confidence that there is enough available space to be able to realloc in place
            // remove all available buddy nodes as necessary
            let mut size = old_size;
            let mut granularity = old_granularity;
            while granularity > new_granularity {
                self.remove_block(
                    granularity,
                    self.bitmap_offset(ptr, size),
                    NonNull::new_unchecked(ptr.add(size).cast())
                );

                size <<= 1;
                granularity -= 1;
            }
        }

        ptr
    }

    /// Shrink the block of memory provided.
    /// ### Safety:
    /// * `new_layout`'s size must be smaller than or equal to `old_layout`'s.
    /// * `old_layout` and `new_layout`'s sizes must be non-zero.
    /// * `ptr` must have been previously acquired, given `old_layout`.
    pub unsafe fn shrink(&mut self, ptr: *mut u8, old_layout: Layout, new_layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(old_layout.size() != 0);
        assume(new_layout.size() != 0);

        let old_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(old_layout.size())
            | old_layout.align()
            | self.smlst_block
        );
        let tgt_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(new_layout.size())
            | new_layout.align()
            | self.smlst_block
        );
        
        if tgt_size < old_size {
            // if size is smaller, break up the block until the required size is reached

            let old_granularity = self.block_granularity(old_size);
            let new_granularity = self.block_granularity(tgt_size);

            let mut hi_block_size = old_size >> 1;
            for hi_granularity in (old_granularity + 1)..=new_granularity {
                let hi_block_base = ptr.add(hi_block_size);
                self.add_block_next(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    NonNull::new_unchecked(hi_block_base.cast())
                );

                hi_block_size >>= 1;
            }
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
            smlst_block: 0,
            arena_base: NonNull::dangling(),
            arena_size_pow2: 0,
            arena_size_pow2_lzcnt: 0,
            arena_size: 0,
            avails: 0,
            llists: NonNull::<[_; 0]>::dangling(),
            bitmap: NonNull::<[_; 0]>::dangling(),
        }))
    }

    /// Create a new `Tallock`. Access the inner `Talloc` via `.lock()`.
    /// 
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths should match `Talloc::slice_lengths`.
    /// * `smallest_block` should be a power of two >= than the size of two pointers.
    /// * `arena_base + arena_size` should not overflow to greater than zero.
    /// * `arena_size` should be non-zero.
    /// * `arena_size.next_power_of_two()` should not overflow.
    /// 
    /// Failing to meet these requirements will result in a panic.
    pub fn new(arena_base: NonNull<u8>, arena_size: usize, smallest_block: usize,
    llists: NonNull<[LlistNode<()>]>, bitmap: NonNull<[u8]>) -> Self {
        Self(Mutex::new(Talloc::new(arena_base, arena_size, smallest_block, llists, bitmap)))
    }

    /// Acquire the lock on the `Talloc`.
    #[inline]
    pub fn lock(&self) -> MutexGuard<Talloc> {
        self.0.lock()
    }
}

unsafe impl GlobalAlloc for Tallock {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 { self.lock().alloc(layout) }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) { self.lock().dealloc(ptr, layout) }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ptr = self.lock().alloc(layout);
        if !ptr.is_null() {
            ptr.write_bytes(0, layout.size());
        }
        ptr
    }

    unsafe fn realloc(&self, ptr: *mut u8, old_layout: Layout, new_size: usize) -> *mut u8 {
        let new_layout = Layout::from_size_align_unchecked(new_size, old_layout.align());
        if new_size > old_layout.size() {
            self.lock().grow(ptr, old_layout, new_layout)
        } else {
            self.lock().shrink(ptr, old_layout, new_layout)
        }
    }
}

unsafe impl Allocator for Tallock {
    fn allocate(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        if layout.size() != 0 {
            match NonNull::new(unsafe { self.lock().alloc(layout) }) {
                Some(ptr) => Ok(NonNull::slice_from_raw_parts(ptr, layout.size())),
                None => Err(AllocError),
            }
        } else {
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }

    unsafe fn deallocate(&self, ptr: NonNull<u8>, layout: Layout) {
        self.lock().dealloc(ptr.as_ptr(), layout)
    }

    unsafe fn grow(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() >= old_layout.size());

        if old_layout.size() != 0 {
            match NonNull::new(self.lock().grow(ptr.as_ptr(), old_layout, new_layout)) {
                Some(ptr) => Ok(NonNull::slice_from_raw_parts(ptr, new_layout.size())),
                None => Err(AllocError),
            }
        } else {
            self.allocate(new_layout)
        }
    }

    unsafe fn grow_zeroed(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() >= old_layout.size());

        if old_layout.size() != 0 {
            let growed = NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(
                    self.lock().grow(ptr.as_ptr(), old_layout, new_layout)
                ),
                new_layout.size()
            );
            growed.as_non_null_ptr().as_ptr().add(old_layout.size())
                .write_bytes(0, new_layout.size() - old_layout.size());
            Ok(growed)
        } else {
            Ok(NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(self.lock().alloc(new_layout)),
                new_layout.size(),
            ))
        }
    }

    unsafe fn shrink(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() <= old_layout.size());
        
        if new_layout.size() != 0 {
            Ok(NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(self.lock().shrink(ptr.as_ptr(), old_layout, new_layout)),
                new_layout.size(),
            ))
        } else {
            self.lock().dealloc(ptr.as_ptr(), old_layout);
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }
}

