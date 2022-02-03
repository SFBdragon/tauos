use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout, Allocator, AllocError},
    ops::Range,
    mem::MaybeUninit,
    pin::Pin,
    fmt::Debug,
};
use crate::utils::{llist::LlistNode, pinning::{PinSliceUtils, iter_pin_mut}};
use spin::Mutex;


/// # Safety:
/// `val` must be nonzero
#[inline]
const unsafe fn fast_non0_log2(val: u64) -> u64 {
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
    1 << 64 - (val - 1).leading_zeros() 
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


/// The bookkeeping `struct` for tracking `Talloc`s state:
/// * `llists` linked list sentinels holding fixed-size blocks of available memory,
/// * `bitmap` a bitmap describing occupation of memopry blocks in the arena,
/// * `avails` a bitfield to track block availability in the linked lists.
/// 
/// Read the respective field docs for more info.
struct TallocBooks<'a> {
    /// The sentinels of the linked lists that each hold available blocks per index/granularity.
    llists: Pin<&'a mut [LlistNode<()>]>,
    /// Bitfield of length `1 << llists.len()` in bits, where each granularity has a bit for each buddy,
    /// offset from the base by that width in bits. Where digits represent each bit for a certain
    /// granularity: `01223333_44444444_55555555_55555555 ...` and so on. Buddies are represented from
    /// low addresses to high addresses.
    /// * Clear bit indicates homogeneity: both or neither are allocated.
    /// * Set bit indicated heterogeneity: one buddy is allocated.
    bitmap: &'a mut [u64],
    /// Indicates whether a block is available in the linked lists, bit index corresponds to granularity.
    avails: u64,
}

impl<'a> Debug for TallocBooks<'a> {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("TallocBooks")
            .field("llists", &self.llists)
            .field("avails", &self.avails)
            .field("bitmap.len()", &self.bitmap.len())
            .finish()
    }
}

impl<'a> TallocBooks<'a> {
    /// Utility function to read the bitmap at the offset in bits
    /// # Safety:
    /// `bitmap_offset` must be valid.
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: u64) -> bool {
        *self.bitmap.get_unchecked(bitmap_offset as usize >> 6) & 1 << (bitmap_offset & 63) != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits
    /// # Safety:
    /// `bitmap_offset` must be valid.
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: u64) {
        *self.bitmap.get_unchecked_mut(bitmap_offset as usize >> 6) ^= 1 << (bitmap_offset & 63);
    }

    /// Registers a block into the books, making it available for allocation.
    /// # Safety:
    /// * `bitmap_offset`'s source `size` and `position` must agree with
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
            sentinel.next().get_ref(),
            ()
        );

        // toggle bitmap flag
        // SAFETY: guaranteed by caller
        self.toggle_bitflag(bitmap_offset);
    }
    /// Unregisters the next block from the books, reserving it against allocation, and returning the base.
    /// # Safety:
    /// * `granularity`'s linked list must have at least two elements (avails at bit granularity should be one).
    /// * `size` must agree with `granularity`'s corresponding block size.
    #[inline]
    unsafe fn remove_block_next(&mut self, granularity: usize, size: u64, talloc: &Talloc) -> u64 {
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
        self.toggle_bitflag(talloc.bitmap_offset(block_base, size));

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
}

/// ## Interface documentation:
/// 
/// ### An allocator, built to prioritise:
/// * low time complexity, maximising performance where possible
/// * a minimisation of external fragmentation at the cost of internal fragmentation
/// * suitability for diverse use-cases
/// 
/// ### Allocator design:
/// * **O(log n)** worst case allocation and deallocation performance
/// * **O(2^n)** memory usage, where the 2^n component is at most `arena size / 128`
/// * **buddy allocation**: it uses a system of multiple levels of power-of-two size memory
/// blocks which can be split and repaired to form smaller and larger allocatable blocks.
/// * **linked-list allocation**: it uses free-lists to keep track of available memory.
/// * **bitmap** employment: a field of bits to track block buddy status across granularities.
/// 
/// ### Allocator usage:
/// - Call the const `TALLOC::new_invalid()`
/// - Call the const `init_arena(&mut self...)` on the result thereof
/// - Call `init_books(&self, ...)` thereafter, at runtime, to complete initialization
/// 
/// Initialization functions treat the arena as entirely reserved, allowing arenas to be created
/// over memory that cannot be written to. However, attempting to allocate in this state will
/// cause allocations to fail. `release(...)` or `release_arena()` must be used, see their 
/// documentation for more.
/// 
/// Resizing the arena is possible, including when memory is still allocated, however
/// you are required to guarantee to not exclude allocations from the current arena.
/// A similar requirement applies to re-reserving memory.

// Concepts, implementation details, and fields:
// - Arena: the bounding region of contiguous memory in which allocations can be performed.
// The arena is not assumed to be safe to read/write to. The user must explicitly make all available
// memory allocatable using the provided functions.
// - Largest allocatable size: The previous/current power-of-two of the arena size.
// - Smallest allocatable size: A power-of-two size as defined by the arena configuration. This 
// must be greater than or equal to 16 due to the size of the linked list nodes.
// - Virtual arena: An ideal buddy system operates within a power-of-two sized and base-aligned
// arena, but an ideal allocator can be used over almost any arena, thus a 'virtual arena' is created
// and used, while natural alignment of memory blocks is used accordingly.
// - Granularity: The orders of magnitude of memory blocks sizes that are available for
// allocation. A granularity of zero is the virtual size, which may or may not be allocatable.
// A granularity of one is the virtual size split into two halves - a single buddy, thus requiring
// one bit in the bitmap, and so on.
// - `llists.len()`: This represents the maximum granularity + 1, and is equal to the log base 2
// of the bitmap size in bits. `largest block size >> (llists.len() - 1) == smallest`.
#[derive(Debug)]
pub struct Talloc<'a> {
    /// The base of the arena, a casted pointer.
    base: u64,
    /// Size of the arena in bytes.
    size: u64,

    /// Size of the smallest allocatable block in bytes.
    smlst: u64,

    /// The floored-to-power-of-two base of the arena.
    virt_base: u64,
    /// The ceiled-to-power-of-two size of the arena.
    virt_size: u64,

    /// Mutex-guarded mutable bookkeeping data
    books: spin::Mutex<TallocBooks<'a>>,
}


impl<'a> Talloc<'a> {
    /// Creates an uninitialized `Talloc`.
    /// # Safety:
    /// Initialize with `init_arena(...)`. Calling any other methods on the result is undefined behaviour.
    pub const unsafe fn new_invalid() -> Self {
        use core::slice::from_raw_parts_mut;

        Self {
            base: 0,
            size: 0,
            smlst: 0,
            virt_base: 0,
            virt_size: 0,

            books: Mutex::new(
                TallocBooks {
                    llists: Pin::new_unchecked(from_raw_parts_mut(NonNull::dangling().as_ptr(), 0)),
                    bitmap: from_raw_parts_mut(NonNull::dangling().as_ptr(), 0),
                    avails: 0,
                }
            ),
        }
    }

    /// Initialize `self`'s arena configuration.
    /// # Safety:
    /// `books` remains in an invalid state, thus calling `init_books(...)` before use is necessary.
    /// 
    /// Do not call this function twice.
    pub const unsafe fn init_arena(&mut self, mut base: u64, mut size: u64, smallest_allocatable_size: u64) {
        assert!(base != 0 && size != 0 && smallest_allocatable_size != 0,
            "init_arena: arguments should be nonzero.");
        assert!(size >= 16,
            "init_arena: size argument should be >=16.");
        assert!(base.checked_add(size).is_some(),
            "init_arena: arena must not wrap around nor be up against the boundary of virtual address space.");
        assert!(smallest_allocatable_size.count_ones() == 1,
            "init_arena: smallest_allocatable_size argument should be a power of two.");

        // ceil base to an alignment of smallest_allocatable_size
        base = base + smallest_allocatable_size - 1 & !(smallest_allocatable_size - 1);
        // floor size to a multiple of smallest_allocatable_size
        size = size & !(smallest_allocatable_size - 1);

        self.base = base;
        self.size = size;

        self.smlst = smallest_allocatable_size;

        self.virt_size = size.next_power_of_two();
        self.virt_base = base & !(self.virt_size - 1);
    }

    /// Returns the length required by `init_books(...)`'s `llists` argument.
    #[inline]
    pub const fn llists_len(&self) -> usize {
        unsafe {
            // SAFETY: smlst & virt_size are never zero
            (fast_non0_log2(self.virt_size) - fast_non0_log2(self.smlst) + 1) as usize
        }
    }
    /// Returns the length required by `init_books(...)`'s `bitmap` argument.
    #[inline]
    pub const fn bitmap_len(&self) -> usize {
        let len = 1 << self.llists_len() >> 3;
        if len > 0 { len } else { 1 }
    }

    /// Initializes the books of the arena to the all-reserved memory state.
    /// 
    /// Use `self.llists_len()` and `self.bitmap_len()` to create the slices, which are assumed to be uninitialized.
    /// # Safety:
    /// Do not call this function twice.
    pub unsafe fn init_books(&self, llists: &'a mut [MaybeUninit<LlistNode<()>>], bitmap: &'a mut [MaybeUninit<u64>]) {
        let mut books = self.books.lock();

        // Ensure slice lengths correspond to expected values
        assert!(llists.len() == self.llists_len(), "llists.len() should equal to self.llists_len().");
        assert!(bitmap.len() == self.bitmap_len(), "bitmap.len() should equal to self.bitmap_len().");

        // Initialize bookkeeping data:
        books.avails = 0;

        bitmap.fill(MaybeUninit::new(0));
        books.bitmap = MaybeUninit::slice_assume_init_mut(bitmap);
        
        for node in llists.iter_mut() {
            LlistNode::new_llist(Pin::new_unchecked(node), ());
        }
        books.llists = Pin::new_unchecked(MaybeUninit::slice_assume_init_mut(llists));
    }

    #[inline]
    fn block_granularity(&self, size: u64) -> usize {
        // effectively computing: largest_block_size.log2() - virt_size.log2()
        (size.leading_zeros() - self.virt_size.leading_zeros()) as usize
    }
    
    /// Returns the offset in bits into the bitmap that indicates the block's buddy status.
    /// # Safety:
    /// * `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: u64, size: u64) -> u64 {
        base - self.virt_base + self.virt_size >> fast_non0_log2(size) + 1
        // virt_size >> (log2(size) + 1), plus, base - virt_base >> (log2(size) + 1)
    }

    #[inline]
    fn is_lower_buddy(&self, base: u64, size: u64) -> bool {
        base - self.virt_base & size == 0
    }

    /// Return a range describing the span of memory conservatively in terms of smallest allocatable units.
    /// 
    /// A primary use case for this bounding method is the releasing of the arena according to available
    /// blocks of memory. Conservative bounding ensures that only available memory is described as available.
    #[inline]
    pub fn bound_available(&self, base: u64, size: u64) -> Range<u64> {
        // base + size never wraps around address space as guaranteed by init_arena
        (base + self.smlst - 1 & !(self.smlst - 1))..(base + size - 1 & !(self.smlst - 1))
    }
    /// Return a range describing a reserved span of memory liberally in terms of smallest allocatable units.
    /// 
    /// A primary use case for this bounding method is the reserving and subsequent releasing of memory within the
    /// arena once already released. Liberal bounding ensures that no unavailable memory is described as available.
    #[inline]
    pub fn bound_reserved(&self, base: u64, size: u64) -> Range<u64> {
        // base + size never wraps around address space as guaranteed by init_arena
        (base & !(self.smlst - 1))..((base + size - 1 & !(self.smlst - 1)) + self.smlst)
    }

    /// Reserve the specified span of memory against allocation.
    /// 
    /// `span` should be the result of `bound_available(...)` or `bound_reserved(...)`.
    /// # Safety:
    /// `span` must not overlap with any allocations.
    pub unsafe fn reserve(&self, span: Range<u64>) {
        /* Strategy:
            Loop through all available block nodes, from the largest to the smallest, and
            break up/eliminate them if they overlap with/are contained in the span respectively.
            The breakdown process currently is relied on in order to prevent over-reserving.

            This algorithm creates a state within the allocator that is not expected; two buddies
            both being available at the same time without being unified. This is currently fine as
            one block or the other is either broken down or eliminated. The bitmap's bits handle
            this case implicitly due to the xor toggle. After the algorithm completed, this
            state should not be present at all.

            This function cannot verify that all of the memory to be reserved is actually 
            available or reserved in the first place, hence the unsafety.
        */

        assert!(span.start >= self.base && span.end <= (self.base + self.size), "Provided span is out of bounds.");
        assert!((span.start | self.base) & self.smlst - 1 == 0, "Provided span is misaligned.");

        let mut books = self.books.lock();

        let smlst_granularity = books.llists.len() - 1;
        let mut block_size = self.virt_size;
        for granularity in 0..smlst_granularity { // do not apply to the granularity of the smallest blocks
            for node in books.llists.as_mut().get_pin_mut(granularity).unwrap().iter_mut() {

                // SAFETY: reference and pointer is not moved out of or into
                let block_base = pin_to_ptr(node.as_ref());
                let block_acme = block_base + block_size;
                
                if span.start < block_base && span.end >= block_acme {
                    // this block is entirely reserved and should be removed as if it were allocated
                    books.remove_block(granularity, self.bitmap_offset(block_base, block_size), node);
                } else if span.start == block_base && span.end == block_acme {
                    // block represents the entire reserved area - remove and return
                    books.remove_block(granularity, self.bitmap_offset(block_base, block_size), node);
                    return;
                } else if span.start >= block_base && span.start < block_acme
                || span.end > block_base && span.end <= block_acme {
                    // block contains lo_end or hi_end - break it down
                    books.remove_block(granularity, self.bitmap_offset(block_base, block_size), node);

                    let half_size = block_size / 2;
                    // SAFETY: location is not moved from/into, every block's base is guaranteed to be large enough and
                    // aligned sufficiently for use of LlistNode<()> pointers thereto.
                    books.add_block_next(granularity + 1, self.bitmap_offset(block_base, half_size), 
                        pin_from_ptr(block_base));
                    books.add_block_next(granularity + 1, self.bitmap_offset(block_base + half_size, half_size),
                        pin_from_ptr(block_base + half_size));
                }
            }
            block_size >>= 1;
        }
        
        // now eliminate all remaining smallest blocks as necessary,
        // with confidence that the elimination will never over-eliminate
        for node in books.llists.as_mut().get_pin_mut(smlst_granularity).unwrap().iter_mut() {
            
            let block_base = pin_to_ptr(node.as_ref());
            let block_acme = block_base + self.smlst;

            if span.start < block_acme && span.end > block_base {
                // this block is reserved and should be removed as if it were allocated
                books.remove_block(
                    smlst_granularity,
                    self.bitmap_offset(block_base, self.smlst),
                    node
                );
            }
        }
    }

    /// Release reserved memory for use. This can be invoked after allocations have been performed.
    /// 
    /// `span` should be the result of `bound_available(...)` or `bound_reserved(...)`.
    /// # Safety:
    /// The memory span must be entirely reserved.
    pub unsafe fn release(&self, span: Range<u64>) {
        /* Strategy:
            Essentially, the opposite process to reserve() is applied. While deallocating each small block
            in the span is simple and correct, it is slow. Thus a routine to combine them automatically
            within the span is employed. Deallocating is still necessary, as the blocks being made available
            may need to be recombined with buddies outside of the span.
            
            This function cannot verify that all of the memory to be released is actually 
            unallocated or reserved in the first place, hence the unsafety.
        */

        assert!(span.start >= self.base && span.end <= (self.base + self.size), "Provided span is out of bounds.");
        assert!((span.start | self.base) & self.smlst - 1 == 0, "Provided span is misaligned.");

        let mut stepping_up = true;
        let mut stepper_up = span.start;
        let mut stepper_down = 0;

        loop {
            let block_size = if stepping_up {
                let block_size = 1 << stepper_up.trailing_zeros();
                if stepper_up + block_size <= span.end {
                    block_size
                } else {
                    stepper_down = span.end - stepper_up;
                    stepping_up = false;
                    continue;
                }
            } else {
                if stepper_down >= self.smlst {
                    // SAFETY: self.smlst is never zero, thus stepper_down is nonzero
                    fast_non0_prev_pow2(stepper_down)
                } else {
                    break;
                }
            };
            
            // SAFETY: deallocing reserved memory in talloc is valid and memory safe when releasing memory
            self.deallocate(
                NonNull::new_unchecked(stepper_up as *mut _),
                // SAFETY: block_size is a power of two, stepper + block_size is checked to not overflow
                Layout::from_size_align_unchecked(block_size as usize, block_size as usize)
            );

            stepper_up += block_size;
            stepper_down &= !block_size;
        }
    }


    /// Smallest block sized must be equal.
    /// 
    /// # Safety:
    /// * Must not exclude avail or allocd mem
    pub unsafe fn resize_arena<'b>(&'b mut self, new_base: u64, new_size: u64,
    bitmap: &'b mut [MaybeUninit<u64>], llists: &'b mut [MaybeUninit<LlistNode<()>>])
    where 'b : 'a {
        // initialize new arena
        let mut new_arena = Talloc::new_invalid();
        new_arena.init_arena(new_base, new_size, self.smlst);
        
        // copy over the bitmap
        let mut old_books = self.books.lock();
        let new_llists_len = new_arena.llists_len();
        let old_llists_len = self.llists_len();
        let smlst_llists_len = usize::min(new_llists_len, old_llists_len);
        let smlst_llists_base = old_llists_len - smlst_llists_len;

        let bitmap = if new_llists_len == old_llists_len {
            // bitmaps are compatible; copy over
            MaybeUninit::write_slice(bitmap, old_books.bitmap)
        } else {
            bitmap.fill(MaybeUninit::new(0));
            let bitmap = MaybeUninit::slice_assume_init_mut(bitmap);

            let arena_overlap_lo = new_arena.base.max(self.base);
            let arena_overlap_hi = (new_arena.base + new_arena.size).min(self.base + self.size);

            for index in (old_llists_len - smlst_llists_len)..old_llists_len {
                let block_size = self.virt_base >> index + smlst_llists_base;

                let old_base_offset = self.bitmap_offset(arena_overlap_lo, block_size) as usize;
                let old_acme_offset = self.bitmap_offset(arena_overlap_hi, block_size) as usize;
                let new_base_offset = new_arena.bitmap_offset(arena_overlap_lo, block_size) as usize;
                let new_acme_offset = new_arena.bitmap_offset(arena_overlap_hi, block_size) as usize;
                debug_assert!(old_acme_offset - old_base_offset == new_acme_offset - new_base_offset);

                if (old_base_offset | old_acme_offset | new_base_offset | new_acme_offset) & 63 == 0 {
                    // bits are word-aligned, copy as normal
                    let old = old_books.bitmap.get((new_base_offset >> 6)..=(new_acme_offset - 1 >> 6)).unwrap();
                    let new = bitmap.get_mut((new_base_offset >> 6)..=(new_acme_offset - 1 >> 6)).unwrap();
                    new.copy_from_slice(old);
                } else if (old_base_offset | old_acme_offset | new_base_offset | new_acme_offset) & 7 == 0 {
                    // bits are byte-aligned, cast and copy
                    let old = core::slice::from_raw_parts(
                        old_books.bitmap.as_ptr() as *const u8, 
                        old_books.bitmap.len() * 8
                    ).get((old_base_offset >> 3)..=(old_acme_offset - 1 >> 3)).unwrap();

                    let new = core::slice::from_raw_parts_mut(
                        bitmap.as_mut_ptr() as *mut u8, 
                        bitmap.len() * 8
                    ).get_mut((new_base_offset >> 3)..=(new_acme_offset - 1 >> 3)).unwrap();

                    new.copy_from_slice(old);
                } else {
                    // the bits are not word-aligned, and may not even have the same alignment
                    crate::utils::copy_bits(
                        bitmap,
                        old_books.bitmap,
                        new_base_offset,
                        new_acme_offset,
                        old_base_offset,
                        old_acme_offset
                    );
                }
            }

            bitmap
        };

        let mut llists_pinned = Pin::new_unchecked(llists);
        for (index, node) in 
        iter_pin_mut(old_books.llists.as_mut()).skip(old_llists_len - smlst_llists_len).enumerate() {
            node.mov(
                llists_pinned.as_mut()
                    .get_pin_mut(index + new_llists_len - smlst_llists_len)
                    .unwrap(), 
                ()
            );
        }

        let llists_transmuted = Pin::new_unchecked(core::mem::transmute(llists_pinned));
        let old_avails = old_books.avails;

        drop(old_books);

        let _ = core::mem::replace(self, new_arena);
        let mut new_books = self.books.lock();

        new_books.llists = llists_transmuted;
        new_books.bitmap = bitmap;
        new_books.avails = old_avails >> old_llists_len - smlst_llists_len;
    }
}

unsafe impl<'a> GlobalAlloc for Talloc<'a> {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        match self.allocate(layout) {
            Ok(ptr) => ptr.as_mut_ptr(),
            Err(_) => ptr::null_mut(),
        }
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        self.deallocate(NonNull::new_unchecked(ptr), layout);
    }
    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        match self.allocate_zeroed(layout) {
            Ok(ptr) => ptr.as_mut_ptr(),
            Err(_) => ptr::null_mut(),
        }
    }
    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        let growd = if new_size >= layout.size() {
            self.grow(
                NonNull::new_unchecked(ptr), 
                layout, 
                Layout::from_size_align_unchecked(new_size, layout.align())
            )
        } else {
            self.shrink(
                NonNull::new_unchecked(ptr), 
                layout, 
                Layout::from_size_align_unchecked(new_size, layout.align())
            )
        };

        match growd {
            Ok(ptr) => ptr.as_mut_ptr(),
            Err(_) => ptr::null_mut(),
        }
    }
}

unsafe impl<'a> Allocator for Talloc<'a> {
    fn allocate(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        // Handle ZSTs
        if layout.size() == 0 {
            return Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0));
        }

        let mut books = self.books.lock();

        // Get the maximum between the required size as a power of two, the smallest allocatable,
        // and the alignment. The alignment being larger than the size is a rather esoteric case,
        // which is handled by simply allocating a larger size with the required alignment. This
        // may be highly memory inefficient for very bizarre scenarios.
        let size = unsafe { fast_non0_prev_pow2( // SAFETY: argument is never zero
            fast_non0_next_pow2(layout.size() as u64) // SAFETY: ZSTs are handled above
            | self.smlst
            | layout.align() as u64
        )};
        let granularity = self.block_granularity(size);

        // Allocate immediately if a block of the correct size is available
        if books.avails & 1 << granularity != 0 {
            let block = unsafe { NonNull::new_unchecked(books.remove_block_next(granularity, size, &self) as *mut u8) };
            return Ok(NonNull::slice_from_raw_parts(block, size as usize));
        }

        // find a larger block to break apart - mask out bits for smaller blocks
        let larger_avl = books.avails & unsafe { core::arch::x86_64::_blsmsk_u64(1 << granularity) };
        if larger_avl == 0 { return Err(AllocError) } // not enough memory
        
        let lgr_granularity = unsafe { fast_non0_log2(larger_avl) } as usize;
        let lgr_size = self.virt_size >> lgr_granularity;
        let lgr_base = unsafe { books.remove_block_next(lgr_granularity, lgr_size, &self) };

        // break down the large block into smaller blocks until the required size is reached
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity { // fixme? hi_block_base is wrong
            let hi_block_base = lgr_base + hi_block_size;
            unsafe {
                books.add_block_next(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    // SAFETY: location is not moved from/into, every block's base is guaranteed to be 
                    // large enough and aligned sufficiently for use of LlistNode<()> pointers thereto.
                    pin_from_ptr(hi_block_base)
                )
            };

            hi_block_size >>= 1;
        }

        unsafe { Ok(NonNull::slice_from_raw_parts(NonNull::new_unchecked(lgr_base as *mut _), size as usize)) }
    }

    unsafe fn deallocate(&self, ptr: NonNull<u8>, layout: Layout) {
        // Handle ZSTs
        if layout.size() == 0 {
            return;
        }

        let mut books = self.books.lock();
        
        // Same process as allocate(), see docs there for rationale
        let mut size = fast_non0_prev_pow2( // SAFETY: input is never zero
            fast_non0_next_pow2(layout.size() as u64) // SAFETY: ZSTs are handled above
            | self.smlst
            | layout.align() as u64
        );
        let mut base = ptr.as_ptr() as u64;
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(base, size);
        
        while books.read_bitflag(bitmap_offset) { // while buddy was heterogenous - available
            let (buddy_base, next_base) = if self.is_lower_buddy(base, size) {
                (base + size, base)
            } else {
                (base - size, base - size)
            };

            // SAFETY: buddy has been confirmed to exist here, LlistNodes are not moved
            books.remove_block(granularity, bitmap_offset, pin_from_ptr_initd(buddy_base));
            
            size <<= 1;
            base = next_base;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(base, size);
        }

        // SAFETY: location is not moved from/into, every block's base is guaranteed to be large enough and
        // aligned sufficiently for use of LlistNode<()> pointers thereto.
        books.add_block_next(granularity, bitmap_offset, pin_from_ptr(base));
    }

    fn allocate_zeroed(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        let ptr = self.allocate(layout)?;
        // SAFETY: `alloc` returns a valid memory block
        unsafe { ptr.as_non_null_ptr().as_ptr().write_bytes(0, ptr.len()) }
        Ok(ptr)
    }

    unsafe fn grow(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() >= old_layout.size());

        // Handle ZSTs
        if old_layout.size() == 0 {
            return self.allocate(new_layout);
        }

        let mut books = self.books.lock();

        let old_size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(old_layout.size() as u64) // ZSTs are handled above
            | self.smlst
            | old_layout.align() as u64
        );
        let tgt_size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(new_layout.size() as u64) // ZSTs are handled above
            | self.smlst
            | new_layout.align() as u64
        );

        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(tgt_size);
        
        
        if tgt_size > old_size {
            // size is bigger, check hi buddies recursively, if available, reserve them, else alloc and dealloc
            // follows a remotely similar routine to dealloc

            let base = ptr.as_ptr() as u64;

            let mut size = old_size;
            let mut bitmap_offset = self.bitmap_offset(base, size);
            let mut granularity = old_granularity;

            while granularity > new_granularity {
                // if this is a high buddy, and a further larger block is required, slow realloc is necessary
                // if the high buddy is not available and a further larger block is required, slow realloc is necessary
                if !self.is_lower_buddy(base, size) || !books.read_bitflag(bitmap_offset) {
                    drop(books);
                    let allocd = self.allocate(new_layout)?;
                    ptr::copy_nonoverlapping(ptr.as_ptr(), allocd.as_mut_ptr(), old_layout.size());
                    self.deallocate(ptr, old_layout);
                    return Ok(allocd);
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
                books.remove_block(
                    granularity,
                    self.bitmap_offset(base, size),
                    // SAFETY: all nodes have already been confirmed to exist, LlistNodes are not moved
                    pin_from_ptr_initd(base + size)
                );

                size <<= 1;
                granularity -= 1;
            }
        }

        Ok(NonNull::slice_from_raw_parts(ptr, new_layout.size()))
    }
    
    unsafe fn grow_zeroed(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        let growd = self.grow(ptr, old_layout, new_layout)?;
        growd.as_uninit_slice_mut().get_unchecked_mut(old_layout.size()..new_layout.size()).fill(MaybeUninit::new(0));
        Ok(growd)
    }
    
    unsafe fn shrink(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        debug_assert!(new_layout.size() <= old_layout.size());

        // Handle ZSTs
        if new_layout.size() == 0 {
            return Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0));
        }
        
        let old_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(old_layout.size() as u64) // ZSTs are handled above
            | self.smlst
            | old_layout.align() as u64
        );
        let tgt_size = fast_non0_prev_pow2(
            fast_non0_next_pow2(new_layout.size() as u64) // ZSTs are handled above
            | self.smlst
            | new_layout.align() as u64
        );
        
        if tgt_size < old_size {
            // if size is smaller, break up the block until the required size is reached

            let mut books = self.books.lock();

            let old_granularity = self.block_granularity(old_size);
            let new_granularity = self.block_granularity(tgt_size);

            let mut hi_block_size = old_size >> 1;
            for hi_granularity in (old_granularity + 1)..=new_granularity {
                let hi_block_base = ptr.as_ptr() as u64 + hi_block_size;
                books.add_block_next(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    // SAFETY: location is not moved from/into, every block's base is guaranteed to be large enough and
                    // aligned sufficiently for use of LlistNode<()> pointers thereto.
                    pin_from_ptr(hi_block_base)
                );

                hi_block_size >>= 1;
            }
        }

        Ok(NonNull::slice_from_raw_parts(ptr, tgt_size as usize))
    }

    fn by_ref(&self) -> &Self {
        self
    }
}
