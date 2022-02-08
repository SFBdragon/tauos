use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout, Allocator, AllocError},
    ops::Range,
    mem::MaybeUninit,
    pin::Pin,
    fmt::Debug,
    intrinsics::assume,
};
use crate::utils::{llist::LlistNode, pinning::{PinSliceUtils, iter_pin_mut}};
use spin::Mutex;


const U64_BITS_MASK: u64 = u64::BITS as u64 - 1;

/// # Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_log2(val: u64) -> u64 {
    assume(val != 0);
    U64_BITS_MASK ^ val.leading_zeros() as u64
}
/// # Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_prev_pow2(val: u64) -> u64 {
    assume(val != 0);
    1 << fast_non0_log2(val)
}
/// # Safety:
/// `val` must be nonzero 
#[inline]
const unsafe fn fast_non0_next_pow2(val: u64) -> u64 {
    assume(val != 0);
    1 << u64::BITS - (val - 1).leading_zeros() 
}

#[inline]
fn pin_to_ptr<T>(pin: Pin<&T>) -> u64 {
    pin.get_ref() as *const _ as u64
}
/// # Safety:
/// * `ptr` must not be null and aligned accordingly with `T`.
/// * `ptr`'s memory location must not be moved from or to.
#[inline]
unsafe fn pin_from_ptr<'a, T>(ptr: u64) -> Pin<&'a mut MaybeUninit<T>> {
    Pin::new_unchecked(NonNull::new_unchecked(ptr as *mut T).as_uninit_mut())
}
/// # Safety:
/// * `ptr` must not be null and aligned accordingly with `T`.
/// * `ptr` must be initialized, valid, and dereferenceable.
/// * `ptr`'s memory location must not be moved from or to.
#[inline]
unsafe fn pin_from_ptr_initd<'a, T>(ptr: u64) -> Pin<&'a mut T> {
    Pin::new_unchecked(NonNull::new_unchecked(ptr as *mut T).as_mut())
}

/// Returns whether the block of the given base is the lower of its buddy pair.
#[inline]
fn is_lower_buddy(base: u64, size: u64) -> bool {
    base & size == 0
}
/// Returns the offset in bits into the bitmap that indicates the block's buddy status.
/// # Safety:
/// * `size` must be nonzero
#[inline]
unsafe fn bitmap_offset(arena_base: u64, arena_size_next_pow2: u64, block_base: u64, block_size: u64) -> u64 {
    // offset of the granularity into the field, plus, offset into the granularity within the arena
    // arena_size.next_power_of_2() >> (log2(size) + 1), plus, base - (arena_base &!(size - 1)) >> (log2(size) + 1)
    // by precalculating the `arena_size_pow2`, this function's generated assembly is approximately halved
    block_base - (arena_base & !(block_size - 1)) + arena_size_next_pow2 >> fast_non0_log2(block_size) + 1
}


pub struct Talloc<'a> {
    /// The base of the arena as an address.
    arena_base: u64,
    /// The size of the arena in bytes.
    arena_size: u64,
    /// The next power-of-two size of the arena in bytes.
    arena_size_pow2: u64,
    /// The leading zero count of size.
    arena_size_pow2_lzcnt: u32,
    /// The power-of-two size of the smallest allocatable block in bytes.
    smlst_alloctbl: u64,

    /// Tracks memory block availability in the linked lists. Bit index corresponds to granularity.
    // This mechanism caps maximum granularity at 64, however that is already well beyond impractical.
    avails: u64,
    /// The sentinels of the linked lists that each hold available fixed-size memory blocks per granularity at an index.
    llists: Pin<&'a mut [LlistNode<()>]>,
    /// Describes occupation of memory blocks in the arena.
    /// 
    /// Bitfield of length `1 << llists.len()` in bits, where each granularity has a bit for each buddy,
    /// offset from the base by that width in bits. Where digits represent each bit for a certain
    /// granularity: `01223333_44444444_55555555_55555555_6...` and so on. Buddies are represented from
    /// low addresses to high addresses.
    /// * Clear bit indicates homogeneity: both or neither are allocated.
    /// * Set bit indicated heterogeneity: one buddy is allocated.
    bitmap: &'a mut [u64],
}

impl<'a> Debug for Talloc<'a> {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        // Don't print out bitmap or llists. Subject to change if necessary.
        f.debug_struct("Talloc")
            .field("arena_base", &self.arena_base)
            .field("arena_size", &self.arena_size)
            .field("arena_size_pow2", &self.arena_size_pow2)
            .field("arena_size_pow2_lzcnt", &self.arena_size_pow2_lzcnt)
            .field("smlst_alloctbl", &self.smlst_alloctbl)
            .field("avails", &self.avails)
            .finish_non_exhaustive()
    }
}

impl<'a> Talloc<'a> {
    /// Returns the corresponding granularity for a given block size.
    #[inline]
    fn block_granularity(&self, size: u64) -> usize {
        // effectively computing: arena_size_pow2.log2() - size.log2()
        (size.leading_zeros() - self.arena_size_pow2_lzcnt) as usize
    }
    /// Returns the offset in bits into the bitmap that indicates the block's buddy status.
    /// # Safety:
    /// * `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: u64, size: u64) -> u64 {
        bitmap_offset(self.arena_base, self.arena_size_pow2, base, size)
    }

    /// Utility function to read the bitmap at the offset in bits.
    /// # Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: u64) -> bool {
        *self.bitmap.get_unchecked((bitmap_offset / u64::BITS as u64) as usize) 
            & 1 << (bitmap_offset & U64_BITS_MASK) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits.
    /// # Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: u64) {
        *self.bitmap.get_unchecked_mut((bitmap_offset / u64::BITS as u64) as usize) 
            ^= 1 << (bitmap_offset & U64_BITS_MASK);
    }

    /// Registers a block into the books, making it available for allocation.
    /// # Safety:
    /// `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn add_block_next(&mut self, granularity: usize, bitmap_offset: u64, node: Pin<&mut MaybeUninit<LlistNode<()>>>) {
        // populating llist
        self.avails |= 1 << granularity;

        // add node from llist
        // SAFETY: guaranteed by caller
        let sentinel = self.llists.as_ref().get_pin_unchecked(granularity);
        LlistNode::new(
            node,
            sentinel.get_ref(),
            sentinel.next(),
            ()
        );

        // toggle bitmap flag
        // SAFETY: guaranteed by caller
        self.toggle_bitflag(bitmap_offset);
    }
    /// Unregisters the next block from the books, reserving it against allocation, and returning the base.
    /// # Safety:
    /// * `granularity`'s linked list must have at least two elements: `avails` at bit `granularity` should be `1`.
    /// * `size` must agree with `granularity`'s corresponding block size.
    #[inline]
    unsafe fn remove_block_next(&mut self, granularity: usize, size: u64) -> u64 {
        // SAFETY: caller guaranteed
        let sentinel = self.llists.as_mut().get_pin_unchecked_mut(granularity);
        if sentinel.as_ref().is_neighbours_equal() {
            // last non-sentinel block in llist, toggle off avl flag
            self.avails &= !(1 << granularity);
        }
        
        // remove node from llist
        // SAFETY: the exclusive reference to self guarantees that aliasing will not occur
        let next_node = sentinel.next_mut();
        let block_base = pin_to_ptr(next_node.as_ref());
        next_node.remove();
        
        // toggle bitmap flag
        // SAFETY: caller guaranteed
        self.toggle_bitflag(self.bitmap_offset(block_base, size));

        block_base
    }
    /// Unregisters a block from the books, reserving it against allocation.
    /// 
    /// To reserve a block from the linked list directly (which this API does not allow),
    /// consider instead using `remove_block_next(...)`.
    /// # Safety:
    /// * `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn remove_block(&mut self, granularity: usize, bitmap_offset: u64, node: Pin<&mut LlistNode<()>>) {
        if node.as_ref().is_neighbours_equal() {
            // last non-sentinel block in llist, toggle off avl flag
            self.avails &= !(1 << granularity);
        }

        // remove node from llist
        node.remove();

        // toggle bitmap flag
        // SAFETY: caller guaranteed
        self.toggle_bitflag(bitmap_offset);
    }



    /// # Safety:
    /// Accessing the field of/calling methods on the result hereof is undefined behaviour.
    const unsafe fn new_invalid() -> Self {
        Self {
            smlst_alloctbl: 0,
            arena_base: 0,
            arena_size: 0,
            arena_size_pow2: 0,
            arena_size_pow2_lzcnt: 0,
            avails: 0,
            llists: Pin::new_unchecked(core::slice::from_raw_parts_mut(NonNull::dangling().as_ptr(), 0)),
            bitmap: core::slice::from_raw_parts_mut(NonNull::dangling().as_ptr(), 0),
        }
    }

    /// Guaratees the following:
    /// * `arena_size` and `smallest_allocatable_size` is non-zero.
    /// * `arena_size.next_power_of_two()` does not overflow.
    /// * `smallest_allocatable_size` is a powers of two.
    /// * `LlistNode<()>` has the expected size.
    /// * `smallest_allocatable_size` is larger or equal to the size of a `LlistNode<()>`
    fn validate_arena_args(arena_size: u64, smallest_allocatable_size: u64) {
        assert!(arena_size != 0, "arena_size must be non-zero.");
        assert!(arena_size <= 1 << 63, "arena_size.next_power_of_two() may not overflow.");
        assert!(smallest_allocatable_size != 0, "smallest_allocatable_size must be non-zero.");
        assert!(smallest_allocatable_size.count_ones() == 1, "smallest_allocatable_size must be a power of 2.");
        
        assert!(usize::BITS as usize / 8 * 2 == core::mem::size_of::<LlistNode<()>>(),
            "LlistNode must be equal to the size of two pointers.");
        assert!(smallest_allocatable_size >= core::mem::size_of::<LlistNode<()>>() as u64,
            "smallest_allocatable_size must equal to or larger than the size of two pointers.");
    }
    
    /// Returns `llists` length and `bitmap` length respectively.
    pub fn slice_arg_sizes(arena_size: u64, smallest_allocatable_size: u64) -> (usize, usize) {
        Self::validate_arena_args(arena_size, smallest_allocatable_size);

        // validate_arena_args guarantees `arena_size` and `smallest_allocatable_size` are non-zero
        // and that `arena_size.next_power_of_two()` does not overflow
        let llists_len = arena_size.next_power_of_two().log2() - smallest_allocatable_size.log2() + 1; // fixme?
        let bitmap_len = (1usize << llists_len) / u64::BITS as usize;

        (llists_len as usize, if bitmap_len != 0 { bitmap_len } else { 1 })
    }

    /// Create a new `Talloc`.
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths must equal `Talloc::slice_arg_sizes`'s values.
    /// * `smallest_allocatable_size` must be a power of two greater than the size of two pointers.
    /// * `arena_base + arena_size` must not overflow to greater than zero.
    /// * `arena_size` must be non-zero.
    pub fn new(arena_base: u64, arena_size: u64, smallest_allocatable_size: u64,
    mut llists: Pin<&'a mut [MaybeUninit<LlistNode<()>>]>, bitmap: &'a mut [MaybeUninit<u64>]) -> Self {
        // verify arena validity
        Self::validate_arena_args(arena_size, smallest_allocatable_size);
        assert!(arena_base.checked_add(arena_size - 1).is_some(), "arena overflow is not allowed.");
        // verify slice lengths
        let (llists_len, bitmap_len) = Self::slice_arg_sizes(arena_size, smallest_allocatable_size);
        assert_eq!(llists_len, llists.as_ref().len());
        assert_eq!(bitmap_len, bitmap.len());

        bitmap.fill(MaybeUninit::new(0));
        for node in iter_pin_mut(llists.as_mut()) {
            LlistNode::new_llist(node, ());
        }

        Self {
            arena_base,
            arena_size,
            arena_size_pow2: arena_size.next_power_of_two(),
            arena_size_pow2_lzcnt: arena_size.next_power_of_two().leading_zeros(),
            smlst_alloctbl: smallest_allocatable_size,
            avails: 0,

            // SAFETY: both slices' contents were just initialized
            llists: unsafe { llists.map_unchecked_mut(|x| 
                MaybeUninit::slice_assume_init_mut(x)
            )},
            bitmap: unsafe {
                MaybeUninit::slice_assume_init_mut(bitmap)
            },
        }
    }



    /// Return a range describing the span of memory conservatively in terms of smallest allocatable units.
    /// The range describes the addresses of the smallest allocatable blocks bottom-inclusive and top-exclusive.
    /// 
    /// A primary use case for this bounding method is the releasing of the arena according to available
    /// blocks of memory. Conservative bounding ensures that only available memory is described as available.
    /// 
    /// `base + size` should not overflow (will error in debug mode):
    /// the last block of smallest allocatable size in address space is, accordingly, permenantly reserved.
    #[inline]
    pub fn bound_available(&self, base: u64, size: u64) -> Range<u64> {
        debug_assert!(size != 0, "cannot bound zero length regions of memory"); // otherwise risks underflow
        // round up to first smlst block contained in the range
        base + (self.smlst_alloctbl - 1) & !(self.smlst_alloctbl - 1)..
        // round down to last smlst block exclusive to the range
        base + size & !(self.smlst_alloctbl - 1)
        
    }
    /// Return a range describing a reserved span of memory liberally in terms of smallest allocatable units.
    /// 
    /// A primary use case for this bounding method is the reserving and subsequent releasing of memory within the
    /// arena once already released. Liberal bounding ensures that no unavailable memory is described as available.
    /// 
    /// `base + size` (rounded up to smallest allocatable size) should not overflow (will error in debug mode):
    /// the last block of smallest allocatable size in address space is, accordingly, permenantly reserved.
    #[inline]
    pub fn bound_reserved(&self, base: u64, size: u64) -> Range<u64> {
        debug_assert!(size != 0, "cannot bound zero length regions of memory"); // otherwise risks underflow
        // round down to first smlst block containing the range
        base & !(self.smlst_alloctbl - 1)..
        // round up to last smlst block exclusive to the range
        (base + size - 1 & !(self.smlst_alloctbl - 1)) + self.smlst_alloctbl
    }

    /// Reserve released memory against use within `bound` inclusive.
    /// 
    /// `bound` is expected to be the result of `bound_available(...)` or `bound_reserved(...)`.
    /// # Performance:
    /// This function has potentially poor performance where `span`'s fields are
    /// poorly aligned (time complexity 2^n, where n is proportional to the smallest trailing zero count).
    /// Accounting for this is recommended if this function is to be used in a hot path.
    /// 
    /// # Safety:
    /// * The memory inclusively within `bound` must be entirely available.
    pub unsafe fn reserve(&mut self, span: Range<u64>) {
        // Strategy:
        // - Loop through all available block nodes to the smallest granularity possible given bound alignment
        // - On encountering a fully contained block, reserve it
        // - On encountering a partially contained block, break it down, reserving it within the bound
        //   - This is similar to the allocation routine of breaking down a block

        let (mem_base, mem_acme) = (span.start, span.end);

        debug_assert!((mem_acme as usize).checked_add(self.smlst_alloctbl as usize).is_some(),
            "Provided bound implies a block against the top of the address space, which is not allowed. \
            Ensure that you do not include the top-most smallest allocatable block in bound argument.");
        debug_assert!(mem_base >= self.arena_base && mem_acme <= (self.arena_base + (self.arena_size - self.smlst_alloctbl)),
            "Provided bound argument is out of bounds.");
        debug_assert!((mem_base | mem_acme) & self.smlst_alloctbl - 1 == 0,
            "Provided bound argument is misaligned.");

        // Caller guarantees that no allocations are made within the span, and that all memory therein is available.
        // Hence it can be assumed that all relevant blocks will be aligned at least as well as the bounds.
        // Thus granularities of a smaller size than that of the alignment need not be checked.
        let base_granularity = self.block_granularity(1 << mem_base.trailing_zeros());
        let acme_granularity = self.block_granularity(1 << mem_acme.trailing_zeros());
        let finest_granularity = base_granularity.max(acme_granularity);
        
        let mut block_size = self.arena_size_pow2;
        for granularity in 0..finest_granularity {
            for node in self.llists.as_mut().get_pin_mut(granularity).unwrap().iter_mut() {
                let block_base = pin_to_ptr(node.as_ref());
                let block_acme = block_base + block_size;
                
                if mem_base <= block_base && mem_acme >= block_acme {
                    // this block is entirely reserved and should be removed as if it were allocated
                    self.remove_block(granularity, self.bitmap_offset(block_base, block_size), node);

                    if mem_base == block_base && mem_acme == block_acme {
                        // block represents the entire reserved area; return
                        return;
                    }
                } else {
                    // handle partial containment cases
                    let is_first_contained = mem_base > block_base && mem_base < block_acme;
                    let is_last_contained = mem_acme > block_base && mem_acme < block_acme;

                    if is_first_contained || is_last_contained {
                        self.remove_block(granularity, self.bitmap_offset(block_base, block_size), node);
                    }
                    
                    if is_first_contained {
                        // first is contained within the block; restore free memory from the bottom
                        let mut base = block_base;
                        let mut delta = mem_base - base;
                        while delta > 0 {
                            let block_size = fast_non0_prev_pow2(delta);
                            delta -= block_size;

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(base, block_size),
                                pin_from_ptr(base),
                            );

                            base += block_size;
                        }
                    }
                    
                    if is_last_contained {
                        // last is contained within the block; restore free memory from the top
                        let mut acme = block_acme;
                        let mut delta = acme - mem_acme;
                        while delta > 0 {
                            let block_size = fast_non0_prev_pow2(delta);
                            delta -= block_size;
                            acme -= block_size;

                            self.add_block_next(
                                self.block_granularity(block_size),
                                self.bitmap_offset(acme, block_size),
                                pin_from_ptr(acme),
                            );
                        }
                    }
                    
                    if is_first_contained && is_last_contained {
                        return;
                    }
                }
            }
            block_size >>= 1;
        }
    }

    /// Release reserved memory for use within `bound` inclusive.
    /// 
    /// `bound` is expected to be the result of `bound_available(...)` or `bound_reserved(...)`.
    /// # Safety:
    /// * The memory inclusively within `bound` must be entirely reserved.
    /// * All the memory inclusively within `bound` must be safely readable and writable.
    pub unsafe fn release(&mut self, span: Range<u64>) {
        // Strategy:
        // - Start address at the base of the bounds
        // - Allocate as large a block as possible repeatedly, bump address
        // - Do so until adding a larger block would overflow the top bound + smlst; then continue
        // - Allocate the previous power of two of the delta between current address and top + smlst, bump address
        // - When the delta is zero, the bounds have been entirely filled

        let (mem_base, mem_acme) = (span.start, span.end);

        debug_assert!((mem_acme as usize).checked_add(self.smlst_alloctbl as usize).is_some(),
            "Provided bound implies a block against the top of the address space, which is not allowed. \
            Ensure that you do not include the top-most smallest allocatable block in bound argument.");
        debug_assert!(mem_base >= self.arena_base && mem_acme <= self.arena_base.saturating_add(self.arena_size),
            "Provided bound argument is out of bounds.");
        debug_assert!((mem_base | mem_acme) & self.smlst_alloctbl - 1 == 0,
            "Provided bound argument is misaligned.");
        
        let mut base = mem_base;
        let mut ascending_block_sizes = true;
        loop {
            let block_size = if ascending_block_sizes {
                let block_size = 1 << base.trailing_zeros();

                if base + block_size <= mem_acme {
                    block_size
                } else {
                    ascending_block_sizes = false;
                    continue;
                }
            } else {
                let delta = mem_acme - base;
                if delta >= self.smlst_alloctbl {
                    // SAFETY: self.smlst is never zero, thus delta is non-zero
                    fast_non0_prev_pow2(delta)
                } else {
                    break;
                }
            };
            
            // SAFETY: deallocating reserved memory is valid and memory safe
            self.dealloc(
                // SAFETY: https://www.youtube.com/watch?v=rp8hvyjZWHs
                base as *mut _, 
                // SAFETY: block_size is a power of two
                Layout::from_size_align_unchecked(block_size as usize, 1)
            );

            base += block_size;
        }
    }

    
    /// Allocate memory as described by the given layout.
    /// 
    /// Returns null to indicate memory exhaustion.
    /// # Safety:
    /// `layout`'s size must be non-zero.
    unsafe fn alloc(&mut self, layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(layout.size() != 0);

        // Get the maximum between the required size as a power of two, the smallest allocatable,
        // and the alignment. The alignment being larger than the size is a rather esoteric case,
        // which is handled by simply allocating a larger size with the required alignment. This
        // may be highly memory inefficient for very bizarre scenarios.
        let size = fast_non0_prev_pow2( // SAFETY: val is never zero
            fast_non0_next_pow2(layout.size() as u64)
            | layout.align() as u64
            | self.smlst_alloctbl
        );
        let granularity = self.block_granularity(size);

        // Allocate immediately if a block of the correct size is available
        if self.avails & 1 << granularity != 0 {
            return self.remove_block_next(granularity, size) as *mut u8;
        }

        // find a larger block to break apart - mask out bits for smaller blocks
        let larger_avl = self.avails & core::arch::x86_64::_blsmsk_u64(1 << granularity);
        if larger_avl == 0 { return ptr::null_mut(); } // not enough memory
        
        let lgr_granularity = fast_non0_log2(larger_avl) as usize;
        let lgr_size = self.arena_size_pow2 >> lgr_granularity;
        let lgr_base = self.remove_block_next(lgr_granularity, lgr_size);

        // break down the large block into smaller blocks until the required size is reached
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            let hi_block_base = lgr_base + hi_block_size;

            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                // SAFETY: location is not moved from/into, every block's base is guaranteed to be 
                // large enough and aligned sufficiently for use of LlistNode<()> pointers thereto.
                pin_from_ptr(hi_block_base)
            );

            hi_block_size >>= 1;
        }

        lgr_base as *mut u8
    }

    /// Deallocate the block of memory.
    /// # Safety:
    /// `ptr` must have been previously acquired, given `layout`.
    unsafe fn dealloc(&mut self, ptr: *mut u8, layout: Layout) {
        // SAFETY: caller guaranteed
        assume(layout.size() != 0);

        // Same process as allocate(), see docs there for rationale
        let mut size = fast_non0_prev_pow2(
            fast_non0_next_pow2(layout.size() as u64)
            | self.smlst_alloctbl
            | layout.align() as u64
        );
        let mut base = ptr as u64;
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(base, size);
        
        while self.read_bitflag(bitmap_offset) { // while buddy was heterogenous - available
            let (buddy_base, next_base) = if is_lower_buddy(base, size) {
                (base + size, base)
            } else {
                (base - size, base - size)
            };

            // SAFETY: buddy has been confirmed to exist here, LlistNodes are not moved
            self.remove_block(granularity, bitmap_offset, pin_from_ptr_initd(buddy_base));
            
            size <<= 1;
            base = next_base;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(base, size);
        }

        // SAFETY: location is not moved from/into, every block's base is guaranteed to be large enough and
        // aligned sufficiently for use of LlistNode<()> pointers thereto.
        self.add_block_next(granularity, bitmap_offset, pin_from_ptr(base));
    }

    /// Grow the block of memory provided.
    /// 
    /// Returns null to indicate memory exhaustion.
    /// 
    /// Books must be initialized.
    /// # Safety:
    /// * `new_layout`'s size must be larger than or equal to `old_layout`'s.
    /// * `old_layout` and `new_layout`'s sizes must be non-zero.
    /// * `ptr` must have been previously acquired, given `old_layout`.
    unsafe fn grow(&mut self, ptr: *mut u8, old_layout: Layout, new_layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(old_layout.size() != 0);
        assume(new_layout.size() != 0);

        let old_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(old_layout.size() as u64)
            | self.smlst_alloctbl
            | old_layout.align() as u64
        );
        let tgt_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(new_layout.size() as u64)
            | self.smlst_alloctbl
            | new_layout.align() as u64
        );

        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(tgt_size);
        
        if tgt_size > old_size {
            // size is bigger, check hi buddies recursively, if available, reserve them, else alloc and dealloc
            // follows a remotely similar routine to dealloc

            let base = ptr as u64;

            let mut size = old_size;
            let mut bitmap_offset = self.bitmap_offset(base, size);
            let mut granularity = old_granularity;

            while granularity > new_granularity {
                // if this is a high buddy, and a further larger block is required, slow realloc is necessary
                // if the high buddy is not available and a further larger block is required, slow realloc is necessary
                if !is_lower_buddy(base, size) || !self.read_bitflag(bitmap_offset) {
                    let allocd = self.alloc(new_layout);
                    if allocd != ptr::null_mut() {
                        ptr::copy_nonoverlapping(ptr, allocd, old_layout.size());
                        self.dealloc(ptr, old_layout);
                    }
                    return allocd;
                }
                
                size <<= 1;
                granularity -= 1;
                bitmap_offset = self.bitmap_offset(base, size);
            }

            // reiterate, with confidence that there is enough available space to be able to realloc in place
            // remove all available buddy nodes as necessary
            let mut size = old_size;
            let mut granularity = old_granularity;
            while granularity > new_granularity {
                self.remove_block(
                    granularity,
                    self.bitmap_offset(base, size),
                    // SAFETY: all nodes have already been confirmed to exist, LlistNodes are not moved
                    pin_from_ptr_initd(base + size)
                );

                size <<= 1;
                granularity -= 1;
            }
        }

        ptr
    }

    /// Shrink the block of memory provided.
    /// # Safety:
    /// * `new_layout`'s size must be smaller than or equal to `old_layout`'s.
    /// * `old_layout` and `new_layout`'s sizes must be non-zero.
    /// * `ptr` must have been previously acquired, given `old_layout`.
    unsafe fn shrink(&mut self, ptr: *mut u8, old_layout: Layout, new_layout: Layout) -> *mut u8 {
        // SAFETY: caller guaranteed
        assume(old_layout.size() != 0);
        assume(new_layout.size() != 0);

        let old_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(old_layout.size() as u64)
            | self.smlst_alloctbl
            | old_layout.align() as u64
        );
        let tgt_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(new_layout.size() as u64)
            | self.smlst_alloctbl
            | new_layout.align() as u64
        );
        
        if tgt_size < old_size {
            // if size is smaller, break up the block until the required size is reached

            let old_granularity = self.block_granularity(old_size);
            let new_granularity = self.block_granularity(tgt_size);

            let mut hi_block_size = old_size >> 1;
            for hi_granularity in (old_granularity + 1)..=new_granularity {
                let hi_block_base = ptr as u64 + hi_block_size;
                self.add_block_next(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    // SAFETY: location is not moved from/into, every block's base is guaranteed to be large enough and
                    // aligned sufficiently for use of LlistNode<()> pointers thereto.
                    pin_from_ptr(hi_block_base)
                );

                hi_block_size >>= 1;
            }
        }

        ptr
    }
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
/// blocks which can be split and repaired to form smaller and larger allocatable blocks.
/// * **linked-list allocation**: it uses free-lists to keep track of available memory.
/// * **bitmap** employment: a field of bits to track block buddy status across granularities.
/// 
/// ### Allocator usage:
/// Intantiation functions treat the arena as entirely reserved, allowing arenas to be created
/// over memory that cannot be written to. However, attempting to allocate in this state will
/// cause allocations to fail. 
/// `Talloc::release` must be used, see its documentation for more.
#[derive(Debug)]
pub struct Tallock<'a>(pub spin::Mutex<Talloc<'a>>);

impl<'a> Tallock<'a> {
    /// Returns an invalid `Tallock`.
    /// 
    /// # Safety: 
    /// It is undefined behaviour to access fields/call any methods on the result hereof.
    /// Alternatively consider using `Talloc::new(...)`.
    pub const unsafe fn new_invalid() -> Self {
        Self(Mutex::new(Talloc::new_invalid()))
    }

    /// Create a new `Tallock`. Access the inner `Talloc` via `{Tallock}.0.lock()`.
    /// 
    /// ### Arguments:
    /// * `llists`'s and `bitmap`'s lengths must equal `Talloc::slice_arg_sizes`'s values.
    /// * `smallest_allocatable_size` must be a power of two greater than the size of two pointers.
    /// * `arena_base + arena_size` must not overflow to greater than zero.
    /// * `arena_size` must be non-zero.
    pub fn new(arena_base: u64, arena_size: u64, smallest_allocatable_size: u64,
    llists: Pin<&'a mut [MaybeUninit<LlistNode<()>>]>, bitmap: &'a mut [MaybeUninit<u64>]) -> Self {
        Self(Mutex::new(Talloc::new(arena_base, arena_size, smallest_allocatable_size, llists, bitmap)))
    }
}

unsafe impl<'a> GlobalAlloc for Tallock<'a> {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 { self.0.lock().alloc(layout) }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) { self.0.lock().dealloc(ptr, layout) }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ptr = self.0.lock().alloc(layout);
        if !ptr.is_null() {
            ptr.write_bytes(0, layout.size());
        }
        ptr
    }

    unsafe fn realloc(&self, ptr: *mut u8, old_layout: Layout, new_size: usize) -> *mut u8 {
        let new_layout = Layout::from_size_align_unchecked(new_size, old_layout.align());
        if new_size > old_layout.size() {
            self.0.lock().grow(ptr, old_layout, new_layout)
        } else {
            self.0.lock().shrink(ptr, old_layout, new_layout)
        }
    }
}

unsafe impl<'a> Allocator for Tallock<'a> {
    fn allocate(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        if layout.size() != 0 {
            match NonNull::new(unsafe { self.0.lock().alloc(layout) }) {
                Some(ptr) => Ok(NonNull::slice_from_raw_parts(ptr, layout.size())),
                None => Err(AllocError),
            }
        } else {
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }

    unsafe fn deallocate(&self, ptr: NonNull<u8>, layout: Layout) {
        if layout.size() != 0 {
            self.0.lock().dealloc(ptr.as_ptr(), layout)
        }
    }

    unsafe fn grow(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() >= old_layout.size());

        if old_layout.size() != 0 {
            match NonNull::new(self.0.lock().grow(ptr.as_ptr(), old_layout, new_layout)) {
                Some(ptr) => Ok(NonNull::slice_from_raw_parts(ptr, new_layout.size())),
                None => Err(AllocError),
            }
        } else {
            self.allocate(new_layout)
        }
    }

    unsafe fn grow_zeroed(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        let growed = self.grow(ptr, old_layout, new_layout)?;
        
        // SAFETY: growed is a valid memory block
        // SAFETY: implicitly handles alloc on ZST
        growed.as_non_null_ptr().as_ptr().wrapping_add(old_layout.size())
            .write_bytes(0, new_layout.size() - old_layout.size());
                
        Ok(growed)
    }

    unsafe fn shrink(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() <= old_layout.size());
        
        if new_layout.size() != 0 {
            Ok(NonNull::slice_from_raw_parts(
                NonNull::new_unchecked(self.0.lock().shrink(ptr.as_ptr(), old_layout, new_layout)),
                new_layout.size(),
            ))
        } else {
            self.0.lock().dealloc(ptr.as_ptr(), old_layout);
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }
}


/*  /// Resize the arena, maintaining existing allocated blocks of memory.
/// Memory newly included in the arena is treated as reserved. Use `Self::release` to use it.
/// 
/// # Safety:
/// The block of memory from `new_base` of size `new_size` must contain all current allocations.
pub unsafe fn resize_arena(&mut self, new_arena_base: u64, new_arena_size: u64,
mut llists: Pin<&'a mut [MaybeUninit<LlistNode<()>>]>, bitmap: &'a mut [MaybeUninit<u64>]) {
    // verify arena validity
    Self::validate_arena_args(new_arena_base, self.smlst_alloctbl);
    assert!(new_arena_base.checked_add(new_arena_size - 1).is_some(), "arena overflow is not allowed.");
    // verify slice lengths
    let (new_llists_len, new_bitmap_len) =
        Self::slice_arg_sizes(new_arena_size, self.smlst_alloctbl);
    assert_eq!(new_llists_len, llists.as_ref().len());
    assert_eq!(new_bitmap_len, bitmap.len());
    
    let old_llists_len = self.llists.len();
    let smlst_llists_len = usize::min(new_llists_len, old_llists_len);
    let smlst_llists_base = old_llists_len - smlst_llists_len;

    let new_arena_size_pow2 = new_arena_size.next_power_of_two();

    // FIX_ME: if new arena does not cover all of old arena, the llists need to be updated accordingly -
    // each block outside of arena must be deleted or broken down
    // this probably requires looping through *all* nodes and checking them against the new bounds

    // copy over the bitmap
    let bitmap = if new_llists_len == old_llists_len {
        // bitmaps are compatible; copy over
        MaybeUninit::write_slice(bitmap, self.bitmap)
    } else {
        bitmap.fill(MaybeUninit::new(0));
        let bitmap = MaybeUninit::slice_assume_init_mut(bitmap);

        let arena_overlap_lo = new_arena_base.max(self.arena_base);
        let arena_overlap_hi = (new_arena_base + (new_arena_size - 1)).min(self.arena_base + (self.arena_size - 1));

        for index in smlst_llists_base..old_llists_len {
            let block_size = self.arena_size_pow2 >> index;

            let old_base_offset = self.bitmap_offset(arena_overlap_lo, block_size) as usize;
            let old_acme_offset = self.bitmap_offset(arena_overlap_hi, block_size) as usize;
            let new_base_offset = bitmap_offset(new_arena_base, new_arena_size_pow2, 
                arena_overlap_lo, block_size) as usize;
            let new_acme_offset = bitmap_offset(new_arena_base, new_arena_size_pow2, 
                arena_overlap_hi, block_size) as usize;
            debug_assert!(old_acme_offset - old_base_offset == new_acme_offset - new_base_offset);

            if (old_base_offset | new_base_offset) & 63 == 0 {
                // bits are word-aligned, copy as normal
                let old = self.bitmap.get((old_base_offset >> 6)..=(old_acme_offset >> 6)).unwrap();
                let new = bitmap.get_mut((new_base_offset >> 6)..=(new_acme_offset >> 6)).unwrap();
                new.copy_from_slice(old);
            } else if (old_base_offset | new_base_offset) & 7 == 0 {
                // bits are byte-aligned, cast and copy
                let old = core::slice::from_raw_parts(
                    bitmap.as_ptr() as *const u8, 
                    bitmap.len() * 8
                ).get((old_base_offset >> 3)..=(old_acme_offset >> 3)).unwrap();

                let new = core::slice::from_raw_parts_mut(
                    bitmap.as_mut_ptr() as *mut u8, 
                    bitmap.len() * 8
                ).get_mut((new_base_offset >> 3)..=(new_acme_offset - 1 >> 3)).unwrap();

                new.copy_from_slice(old);
            } else {
                // the bits are not word-aligned, and may not even have the same alignment
                crate::utils::copy_slice_bits(
                    bitmap,
                    self.bitmap,
                    new_base_offset,
                    new_acme_offset,
                    old_acme_offset - old_base_offset
                );
            }
        }

        bitmap
    };

    // move the free-llist sentinels over, using LlistNode::mov to maintain pointer itegrity
    for (index, node) in iter_pin_mut(self.llists.as_mut()).skip(smlst_llists_base).enumerate() {
        node.mov(
            llists.as_mut()
                .get_pin_mut(index + new_llists_len - smlst_llists_len)
                .unwrap(), 
            ()
        );
    }

    *self = Self {
        arena_base: new_arena_base,
        arena_size: new_arena_size,
        arena_size_pow2: new_arena_size_pow2,
        arena_size_pow2_lzcnt: new_arena_size_pow2.leading_zeros(),
        smlst_alloctbl: self.smlst_alloctbl,
        avails: self.avails >> old_llists_len - smlst_llists_len,
        llists: Pin::new_unchecked(MaybeUninit::slice_assume_init_mut(llists.get_unchecked_mut())),
        bitmap,
    };
} */


