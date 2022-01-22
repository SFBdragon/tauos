use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout}, ops::Range, mem::MaybeUninit, pin::Pin,
};
use amd64::paging;
use crate::utils::llist::LlistNode;
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


/// A helper type that allows for safe calculation and compliance with `Talloc`'s arena
/// configuration requirements. Read `Talloc` docs for more info.
/// 
/// All calculations can be done in `const` contexts.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ArenaConfig {
    /// The base of the arena, a casted pointer. Must not overflow when `size` is added.
    pub base: u64,
    /// Size of the arena in bytes. Must not overflow when added to `base`.
    pub size: u64,
    /// The log base 2 of the smallest allocatable block size. Must be `>= 16`.
    pub smlst_log2: u32,
}

impl ArenaConfig {
    /// Create a new valid arena configuration. A convenience function for:
    /// ```ArenaConfig::shrink_to_valid(ArenaConfig { base, size, smlst_log2 }, align_base_else_size)```
    #[inline]
    pub const fn new_valid_shrunk(base: u64, size: u64, smlst_log2: u32, align_base_else_size: bool) -> Self {
        Self::shrink_to_valid(Self { base, size, smlst_log2 }, align_base_else_size)
    }

    /// Shrink the arena to reach a valid state. This does not adjust the configuration if it is already valid.
    /// 
    /// `align_base_else_size` defines which end of the arena is shrunk to satisfy alignment.
    /// Note that the other end of the arena is also shrunk to eliminate dead space.
    pub const fn shrink_to_valid(mut config: Self, align_base_else_size: bool) -> Self {
        let req_align = config.req_align();

        assert!(config.base.checked_add(config.size).is_some(), "ArenaConfig where base + size overflows unfixable.");

        // align base/acme by shrinking the arena accordingly
        if align_base_else_size && config.base.trailing_zeros() < req_align {
            config.base = (config.base >> req_align) + 1 << req_align;
        } else if !align_base_else_size && (config.base + config.size).trailing_zeros() < req_align {
            config.size = ((config.base + config.size) >> req_align << req_align) - config.base;
        }

        // Req_align may have changed in some edge cases here, but will not be more demanding.
        // Aligning back to the new align may make slightly more memory available, but may in turn
        // reset the required alignment back, causing a nasty edge case.

        // if there is dead space in the arena, shrink the arena at the opposite end to alignment
        if config.size & (1 << config.smlst_log2) - 1 != 0 {
            if align_base_else_size {
                config.size = config.size >> config.smlst_log2 << config.smlst_log2;
            } else {
                config.base = (config.base >> config.smlst_log2) + 1 << config.smlst_log2;
            }
        }

        config
    }

    /// Ensure `self` is a valid arena configuration for the system allocator.
    pub const fn validate(&self) {
        // ensure none of the fields are zero
        assert!(self.base != 0, "ArenaConfig with a base of zero is invalid.");
        assert!(self.size != 0, "ArenaConfig with a size of zero is invalid.");
        // ensure granularity is within expected bounds
        assert!(self.smlst_log2 > 3,
            "ArenaConfig with an allocatable block smaller than 16 bytes is invalid.");

        

        // ensure size does not contain unusable space:
        // no bits pertaining to blocks smaller than smallest allocatable are set
        assert!(self.size.trailing_zeros() >= self.smlst_log2 && self.base.trailing_zeros() >= self.smlst_log2,
            "ArenaConfig arena contains unusable space, which is invalid.");

        let req_align = self.req_align();

        // ensure required alignment is satisfied either by the base or the acme
        assert!(self.base.trailing_zeros() >= req_align || (self.base + self.size).trailing_zeros() >= req_align,
            "ArenaConfig where neither the base or acme are aligned to requirement is invalid.");
    }


    /// Returns the alignment required by the arena's base or acme. This is used to determine shrink requirements.
    /// 
    /// Does not require the config be valid. Only that `size` is accurate for arenas smaller than a page (4KiB).
    #[inline]
    pub const fn req_align(&self) -> u32 {
        // Types usually don't require alignment larger than their size, and the largest alignment that a
        // rust type can demand is 4KiB. The largest type this allocator will allow is the floor(log2(arena size))
        // due to the buddy allocation mechanism. The required alignment is thusly derived.
        if self.size.log2() < paging::PTE_MAPPED_SIZE.trailing_zeros() {
            self.size.log2()
        } else {
            paging::PTE_MAPPED_SIZE.trailing_zeros()
        }
    }

    /// Returns the required length of the `llists` `slice` in terms of `u64`.
    /// This value is the `maximum granularity of the arena plus one`, see `Talloc` type-level docs for more info.
    /// 
    /// Validation checks `self`.
    #[inline]
    pub const fn llists_len(&self) -> usize {
        self.validate();
        // effectively: self.size.log2() - self.smlst_log2 + 1
        (64 - self.smlst_log2 - self.size.leading_zeros()) as usize
    }

    /// Returns the required length of the `bitmap` slice in terms of `u64`.
    /// 
    /// Validation checks `self`.
    #[inline]
    pub const fn bitmap_len(&self) -> usize {
        let bits = 1 << self.llists_len(); // validation checks
        if bits >= 64 {
            bits / 64
        } else {
            1
        }
    }
}


/// The bookkeeping `struct` for tracking `Talloc`s state:
/// * `bitmap` a bitmap describing occupation of memopry blocks in the arena,
/// * `llists` linked list sentinels holding fixed-size blocks of available memory,
/// * `avails` a bitfield to track block availability in the linked lists.
/// 
/// Read the respective field docs for more info.
#[derive(Debug)]
struct TallocBooks<'a> {
    /// Bitfield of length `1 << llists.len()` in bits, where each granularity has a bit for each buddy,
    /// offset from the base by that width in bits. Where digits represent each bit for a certain
    /// granularity: `01223333_44444444_55555555_55555555 ...` and so on. Buddies are represented from
    /// low addresses to high addresses.
    /// * Clear bit indicates homogeneity: both or neither are allocated.
    /// * Set bit indicated heterogeneity: one buddy is allocated.
    bitmap: &'a mut [u64],
    /// The sentinels of the linked lists that each hold available blocks per index/granularity.
    llists: &'a mut [LlistNode<()>],
    /// Indicates whether a block is available in the linked lists, bit index corresponds to granularity.
    avails: u64,
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
    /// `granularity`'s block size and `node`'s block base and size.
    /// * `node` must be aligned, dereferencable, and not mutably aliased, though it needn't be initialized.
    /// * The granularities's sentinel, and the sentinel's next node, must not be mutably referenced.
    #[inline]
    unsafe fn add_block(&mut self, granularity: usize, bitmap_offset: u64, node: Pin<&mut MaybeUninit<LlistNode<()>>>) {
        if self.avails & 1 << granularity == 0 {
            // populating llist
            self.avails |= 1 << granularity;
        }

        // add node from llist
        let sentinel = self.llists.get_unchecked_mut(granularity);
        LlistNode::new(
            node, 
            sentinel,
            // SAFETY: sentinel is not moved
            Pin::new_unchecked(sentinel).next().as_ref().get_ref(),
            ()
        );

        // toggle bitmap flag
        self.toggle_bitflag(bitmap_offset);
    }
    /// Unregisters a block from the books, reserving it against allocation.
    /// # Safety:
    /// * `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s block size and `node`'s block base and size.
    /// * `node` must be aligned, dereferencable, and not mutably aliased, though it needn't be initialized.
    /// * `node`'s neighbours must not be mutably referenced.
    /// * The granularities's sentinel, and the sentinel's next node, must not be mutably referenced.
    #[inline]
    unsafe fn remove_block(&mut self, granularity: usize, bitmap_offset: u64, node: Pin<&mut LlistNode<()>>) {
        if ptr::eq(node.next().as_ref().get_ref(), node.prev().as_ref().get_ref()) {
            // last block in llist, toggle off avl flag
            self.avails &= !(1 << granularity);
        }

        // remove node from llist
        node.remove();

        // toggle bitmap flag
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
/// * **O(2^n)** memory usage, to a maximum of `arena size / 128`
/// * **buddy** allocation: it uses a system of multiple levels of power-of-two size memory
/// blocks which can be split and repaired to form smaller and larger allocatable blocks.
/// * **linked-list** allocation: it uses free-lists to keep track of available memory.
/// * **bitmap** employment: a field of bits to track block buddy status across granularities.
/// 
/// ### Allocator usage:
/// Use `ArenaConfig` to create a new arena configuration using `ArenaConfig::new_valid_shrunk`
/// and subsequently use its `bitmap_len` and `llists_len` to determine the length of the slices
/// to pass to the `Talloc` initialisation functions.
/// 
/// `Talloc` can be used in both on the stack, on a heap, or in `static mut` and `static` contexts.
/// For static contexts, it is required to use the former where arena size or smallest allocatable
/// size is not known at compile time.
/// 
/// Initialization at compile time:
/// * `static TALLOC = Talloc::const_new(...);`, then later at runtime before use,
/// `TALLOC.const_init(...);`.
/// 
/// Initialization at runtime:
/// * `static mut TALLOC = unsafe { Talloc::new_invalid() };`, which must later be reassigned,
/// `unsafe { TALLOC = Talloc::dyn_new(...); }`.
/// 
/// Initialization functions treat the arena as entirely reserved, allowing arenas to be created
/// over memory that cannot be written to. However, attempting to allocate in this state will
/// cause allocations to fail. Either the entire arena (`TALLOC.release_arena()`) or parts
/// (`loop { unsafe { TALLOC.release(TALLOC.bound_conservative(part_base, part_size)); } }`)
/// must be released.
/// 
/// 
/// ## Concepts, implementation details, and fields:
///
/// - Arena: the bounding region of contiguous memory in which allocations can be performed.
/// The arena is not assumed to be safe to read/write to. The user must explicitly make all available
/// memory allocatable using the provided functions.
///
/// - Largest allocatable size: The previous/current power-of-two of the arena size.
/// - Smallest allocatable size: A power-of-two size as defined by the arena configuration. This 
/// must be greater than or equal to 16 due to the size of the linked list nodes.
///
/// - Virtual arena: An ideal buddy system operates within a power-of-two sized and base-aligned
/// arena, but an ideal allocator can be used over almost any arena, thus this allocator makes
/// the following requirement:
/// Either the base or acme (base + size) must be aligned to either a page, or the largest
/// allocatable block size when smaller than that. This guarantees that all allocations of typical
/// types are automatically aligned.
/// If the base complies with this requirement, virtual base is the real base, else is the acme
/// minus the virtual size, which is the next/current power-of-two of arena size. This may wrap
/// into 'the negatives', which is why arithmetic involving virt_base and virt_size must use
/// wrapping operations.
///
/// - Granularity: The orders of magnitude of memory blocks sizes that are available for
/// allocation. A granularity of zero is the virtual size, which may or may not be allocatable.
/// A granularity of one is the virtual size split into two halves - a single buddy, thus requiring
/// one bit in the bitmap, and so on.
///
/// - `llists.len()`: This represents the maximum granularity + 1, and is equal to the log base 2
/// of the bitmap size in bits. `largest block size >> (llists.len() - 1) == smallest`. This is an
/// important value for the contruction of the allocator, but is abstract and error-prone to 
/// calculate, hence a reason for `AllocConfig`'s existence, as well as for the transparency of the
/// arena shrinking process to satisfy the above alignment constraint (as well as remove unallocatable
/// space within the arena), as hiding that behaviour may cause unexpected results for users.
#[derive(Debug)]
pub struct Talloc<'a> {
    /// The base of the arena, a casted pointer.
    base: u64,
    /// Size of the arena in bytes.
    size: u64,

    /// Size of the largest allocatable block in bytes.
    lrgst: u64,
    /// Size of the smallest allocatable block in bytes.
    smlst: u64,

    /// The hypothetical base of the arena if it was a power of two size.
    /// 
    /// *Note:* this may wrap arround the boundary of `u64`,
    /// thus wrapping operations are required when used for arithmetic.
    virt_base: u64,
    /// The hypothetical size of the arena if it was a power of two.
    virt_size: u64,

    /// Mutex-guarded mutable bookkeeping data
    books: spin::Mutex<TallocBooks<'a>>,
}


impl<'a> Talloc<'a> {
    /// Creates an invalid `Talloc` that can act as an uninitialized value.
    /// 
    /// # Safety: todo fixme
    /// Replace before use. Calling any methods on the result is undefined behaviour.
    pub const unsafe fn new_invalid() -> Self {
        Self {
            base: 0,
            size: 0,
            lrgst: 0,
            smlst: 0,
            virt_base: 0,
            virt_size: 0,

            books: Mutex::new(
                TallocBooks {
                    bitmap: core::slice::from_raw_parts_mut(NonNull::dangling().as_ptr(), 0),
                    llists: core::slice::from_raw_parts_mut(NonNull::dangling().as_ptr(), 0),
                    avails: 0,
                }
            ),
        }
    }

    /// todo fixme
    /// 
    /// # Safety:
    /// Reinitializing an arena that has currently allocated memory may cause memory unsafety or UB.
    /// 
    /// Initializes `books` to an invalid state, thus calling `init_books(...)` before use is necessary.
    pub const unsafe fn init_arena(&mut self, config: ArenaConfig) {
        config.validate();

        self.base = config.base;
        self.size = config.size;
        self.lrgst = 1 << config.size.log2();
        self.smlst = 1 << config.smlst_log2;
        self.virt_size = config.size.next_power_of_two();
        self.virt_base = {
            let req_align = config.req_align();
            if config.base.trailing_zeros() >= req_align {
                config.base
            } else {
                (config.base + config.size).wrapping_sub(config.size.next_power_of_two())
            }
        };
    }

    /// Initializes the books of the arena to the all-reserved memory state.
    /// # Safety:
    /// Reinitializing the books of an arena that has currently allocated memory may cause memory unsafety or UB.
    pub unsafe fn init_books(&mut self, bitmap: &mut [MaybeUninit<u64>], llists: &mut [MaybeUninit<LlistNode<()>>]) {
        let mut books = self.books.lock();

        // Extract slice length requirement from arena data
        let llists_len = (64 - self.smlst.log2() - self.size.leading_zeros()) as usize;

        // Ensure slice lengths correspond to expected values
        assert!(llists.len() == llists_len,
            "llists.len() should equal to the arena used for initialization's ArenaConfig::llists_len().");
        assert!(bitmap.len() >= 1 && bitmap.len() >= 1 << llists_len >> 3,
            "bitmap.len() should equal to the arena used for initialization's ArenaConfig::bitmap_len().");

        // Initialize the contents of bitmap and llists
        bitmap.fill(MaybeUninit::new(0));
        for node in llists.iter_mut() {
            // SAFETY: llists' nodes are never moved
            LlistNode::new_llist(Pin::new_unchecked(node), ());
        }

        // Transmute the references to the data to reflect their initialization
        let (initd_bitmap, initd_llists) = (
            // SAFETY: both memory spans were just initialized
            core::slice::from_raw_parts_mut(bitmap.as_mut_ptr() as *mut u64, bitmap.len()),
            core::slice::from_raw_parts_mut(llists.as_mut_ptr() as *mut LlistNode<()>, llists.len())
        );

        // Configure the books
        books.bitmap = initd_bitmap;
        books.llists = initd_llists;
        books.avails = 0;
    }

   /*  /// Create and initialize the allocator. Use the `ArenaConfig` type to help create a valid arena and bitmap.
    /// 
    /// This function does not touch the arena itself, and leaves the arena as reserved.
    /// Use the `release` or `release_arena` functions to establish allocatable memory.
    pub fn dyn_new(config: ArenaConfig, bitmap: &mut [MaybeUninit<u64>], llists: &mut [MaybeUninit<LlistNode<()>>])
    -> Self {
        let llists_len = config.llists_len(); // .llists_len() validates config
        // Ensure g is supported
        assert!(llists.len() <= 64, "llists.len()/'g' > 64 is unsupported. Read type-level docs for more info.");
        // Ensure llists length is correct
        assert!(llists.len() == llists_len, "config.llists_len() must equal llists.len().");
        // Ensure bitmap length is correct
        assert!(bitmap.len() >= config.bitmap_len(), "bitmap.len() should equal config.bitmap_len().");

        // Initialize the contents of bitmap and llists
        bitmap.fill(MaybeUninit::new(0));
        for node in llists.iter_mut() {
            // SAFETY: llists' nodes are never moved
            LlistNode::new_llist(unsafe { Pin::new_unchecked(node) }, ());
        }

        // Transmute the references to the data to reflect their initialization
        let (initd_bitmap, initd_llists) = unsafe { (
            // SAFETY: both memory spans were just initialized
            core::slice::from_raw_parts_mut(bitmap.as_mut_ptr() as *mut u64, bitmap.len()),
            core::slice::from_raw_parts_mut(llists.as_mut_ptr() as *mut LlistNode<()>, llists.len())
        )};

        // Construct new and return
        Self {
            base: config.base,
            size: config.size,
            lrgst: 1 << config.size.log2(),
            smlst: 1 << config.smlst_log2,
            virt_size: config.size.next_power_of_two(),
            virt_base: {
                let req_align = config.req_align();
                if config.base.trailing_zeros() >= req_align {
                    config.base
                } else {
                    (config.base + config.size).wrapping_sub(config.size.next_power_of_two())
                }
            },
            books: Mutex::new(
                TallocBooks {
                    bitmap: initd_bitmap,
                    llists: initd_llists,
                    avails: 0,
                }
            ),
        }
    }
 */
    
    #[inline]
    fn block_granularity(&self, size: u64) -> usize {
        // effectively computing: largest_block_size.log2() - virt_size.log2()
        (size.leading_zeros() - self.virt_size.leading_zeros()) as usize
    }
    
    /// Returns the offset in bits into the bitmap that indicates buddy status.
    /// 
    /// `base` must be within the arena.
    /// # Safety:
    /// * `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: u64, size: u64) -> u64 {
        self.virt_size.wrapping_add(base.wrapping_sub(self.virt_base)) >> fast_non0_log2(size) + 1
        // arena.virt_size >> log2(size) + 1, plus, base - arena.virt_base >> log2(size) + 1
    }

    #[inline]
    fn is_lower_buddy(&self, base: u64, size: u64) -> bool {
        base.wrapping_sub(self.virt_base) & size == 0
    }

    /// Return a range describing the span of memory conservatively in terms of smallest allocatable units.
    /// 
    /// Conservative bounding ensures that no unavailable memory is described as available.
    #[inline]
    pub fn bound_available(&self, base: u64, size: u64) -> Range<u64> {
        ((base - 1).wrapping_sub(self.virt_base) & !(self.smlst - 1)).wrapping_add(self.virt_base) + self.smlst
        ..((base + size).wrapping_sub(self.virt_base) & !(self.smlst - 1)).wrapping_add(self.virt_base)
    }
    /// Return a range describing the span of memory liberally in terms of smallest allocatable units.
    /// 
    /// Liberal bounding ensures that no unavailable memory is described as available.
    #[inline]
    pub fn bound_reserved(&self, base: u64, size: u64) -> Range<u64> {
        (base.wrapping_sub(self.virt_base) & !(self.smlst - 1)).wrapping_add(self.virt_base)..
        ((base + size - 1).wrapping_sub(self.virt_base)& !(self.smlst - 1)).wrapping_add(self.virt_base) + self.smlst
    }

    /// Reserve the specified span of memory against allocation.
    /// # Safety:
    /// `span` must not overlap with any allocations - primary use-case is reservation before allocation.
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
        let mut block_size = self.lrgst;
        for granularity in 0..smlst_granularity { // do not apply to the granularity of the smallest blocks
            for node in Pin::new_unchecked(
            books.llists.get_mut(granularity).unwrap()).iter_mut() {

                let block_base = unsafe {
                    // SAFETY: reference and pointer is not moved out of or into
                    node.get_unchecked_mut()
                } as *mut _ as u64;
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
                    books.add_block(granularity + 1, self.bitmap_offset(block_base, half_size), 
                        NonNull::new_unchecked(block_base as *mut _));
                    books.add_block(granularity + 1, self.bitmap_offset(block_base + half_size, half_size),
                        NonNull::new_unchecked((block_base + half_size) as *mut _));
                }
            }
            block_size >>= 1;
        }
        
        // now eliminate all remaining smallest blocks as necessary,
        // with confidence that the elimination will never over-eliminate
        for node in Pin::new_unchecked(
        books.llists.get_mut(smlst_granularity).unwrap()).iter_mut() {
            
            let block_base = unsafe {
                // SAFETY: reference and pointer is not moved out of or into
                node.get_unchecked_mut()
            } as *mut _ as u64;
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
    /// `span` should be the result of `bound_conservative(...)` or `bound_liberal(...)`.
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

        let mut stepper = span.start.wrapping_sub(self.virt_base);
        let stepper_max = span.end.wrapping_sub(self.virt_base);

        loop {
            let block_size;
            if stepping_up {
                block_size = 1 << stepper.trailing_zeros();

                // stepper + block_size might overflow if the arena is against the top of the address space
                // stepper_max cannot be equal to u64::MAX
                if stepper.checked_add(block_size).unwrap_or(u64::MAX) > stepper_max {
                    // switch from freeing progressively larger block to smaller blocks
                    stepping_up = false;
                    continue;
                }
            } else {
                if stepper < stepper_max {
                    // 1 << tzcnt is too big, so fill with progressively smaller blocks
                    block_size = 1 << stepper.trailing_zeros() - 1;
                } else {
                    break;
                }
            }

            debug_assert!(block_size >= self.smlst);
            
            // SAFETY: deallocing reserved memory in talloc is valid and memory safe when releasing memory
            self.dealloc(
                stepper as *mut _,
                // SAFETY: block_size is a power of two, stepper + block_size is checked to not overflow
                Layout::from_size_align_unchecked(block_size as usize, block_size as usize)
            );

            stepper += block_size;
        }
    }

    /// Release the entire arena of reserved memory for use.
    /// # Safety:
    /// No memory must be allocated, else calling this function may violate memory safety.
    /// 
    /// The entire arena must be reserved. In other words, any allocation must fail. This state can be as a result 
    /// of initialization, or where `reserve(...)` is used on all available memory.
    pub unsafe fn release_arena(&self) {
        let mut books = self.books.lock();

        // Alignment can be satisfied at both arena base and/or arena end
        let is_base_aligned = self.base == self.virt_base;
        let mut offset_base = if is_base_aligned { self.base } else { self.base + self.size };
        let mut arena_size_bitmap = self.size;

        while arena_size_bitmap != 0 {
            // SAFETY: just guaranteed that arena_size_bitmap is nonzero
            let block_size = fast_non0_prev_pow2(arena_size_bitmap);
            let granularity = self.block_granularity(block_size);
            arena_size_bitmap = arena_size_bitmap ^ block_size;

            if !is_base_aligned { offset_base -= block_size; }

            // SAFETY: dependant on algorithm correctness
            books.add_block(
                granularity,
                self.bitmap_offset(offset_base, block_size),
                NonNull::new(offset_base as _).unwrap()
            );

            if is_base_aligned { offset_base += block_size; }
        }
    }

    ///
    /// 
    /// # Safety:
    /// * Must not exclude avail or allocd mem
    pub unsafe fn resize_arena(&mut self, config: ArenaConfig,
    bitmap: &mut [MaybeUninit<u64>], llists: &mut [MaybeUninit<LlistNode<()>>]) {
        // check that smallest blocks are compatible

        // SAFETY: User guarantees that todo
        self.init_arena(config);
        // SAFETY: books are immediately hereafter locked and available memory references are restored
        self.init_books(bitmap, llists);

        let books = self.books.lock();

        // set/shift avails accordingly
        // set llists and fix moved nodes
        // move bitmap data over
        // ensure any pairs with new data are correct? (should already be correct?)

        todo!()
    }
}

unsafe impl<'a> GlobalAlloc for Talloc<'a> {
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

        if books.avails & 1 << granularity != 0 { // if a block of size is available, allocate it
            let next = books.llists.get_unchecked_mut(granularity).next();
            books.remove_block(granularity, self.bitmap_offset(next.as_ptr() as u64, size), next);
            return next.as_ptr().cast();
        }

        // find a larger block to break apart - mask out bits for smaller blocks
        let larger_avl = books.avails & core::arch::x86_64::_blsmsk_u64(1 << granularity);
        if larger_avl == 0 { return ptr::null_mut(); } // not enough memory
        
        let lgr_granularity = fast_non0_log2(larger_avl) as usize;
        let lgr_size = self.lrgst >> lgr_granularity;
        let lgr_block = books.llists.get_unchecked_mut(lgr_granularity).next();
        
        // remove the large block, it is guaranteed to be broken
        books.remove_block(
            lgr_granularity,
            self.bitmap_offset(lgr_block.as_ptr() as u64, lgr_size),
            lgr_block
        );

        // break down the large block into smaller blocks until the required size is reached
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            let hi_block_base = lgr_block.as_ptr() as u64 + hi_block_size;
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
        
        // same process as alloc(), see docs there for rationale
        let mut size = fast_non0_prev_pow2( // unbranched maximum between or'd values
            fast_non0_next_pow2(layout.size() as u64) // ZSTs are never allocated
            | self.smlst
            | layout.align() as u64
        );
        let mut base = ptr as u64;
        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(base, size);
        
        while books.read_bitflag(bitmap_offset) { // while buddy was heterogenous - available
            let (buddy_base, next_base) = if self.is_lower_buddy(base, size) {
                (base + size, base)
            } else {
                (base - size, base - size)
            };

            books.remove_block(granularity, bitmap_offset, NonNull::new_unchecked(buddy_base as _));
            
            size <<= 1;
            base = next_base;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(base, size);
        }
        
        books.add_block(granularity, bitmap_offset, NonNull::new(base as _).unwrap());
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        let ret = self.alloc(layout);
        core::slice::from_raw_parts_mut(ret, layout.size()).fill(0);
        ret
    }

    unsafe fn realloc(&self, ptr: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        // same process as alloc(), see docs there for rationale
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
            // if size is smaller, break up the block until the required size is reached

            let mut hi_block_size = old_size >> 1;
            for hi_granularity in (old_granularity + 1)..=new_granularity {
                let hi_block_base = ptr as u64 + hi_block_size;
                books.add_block(
                    hi_granularity,
                    self.bitmap_offset(hi_block_base, hi_block_size),
                    NonNull::new_unchecked(hi_block_base as *mut _)
                );

                hi_block_size >>= 1;
            }
        } else if tgt_size > old_size {
            // size is bigger, check hi buddies recursively, if available, reserve them, else alloc and dealloc
            // follows a remotely similar routine to dealloc

            let base = ptr as u64;

            let mut size = old_size;
            let mut bitmap_offset = self.bitmap_offset(base, size);
            let mut granularity = old_granularity;

            while granularity > new_granularity {
                // if this is a high buddy, and a further larger block is required, slow realloc is necessary
                // if the high buddy is not available and a further larger block is required, slow realloc is necessary
                if !self.is_lower_buddy(base, size) || !books.read_bitflag(bitmap_offset) {
                    drop(books);
                    let allocd = self.alloc(Layout::from_size_align_unchecked(new_size, layout.align()));
                    if !allocd.is_null() {
                        ptr::copy_nonoverlapping(ptr, allocd, layout.size());
                        self.dealloc(ptr, layout);
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
                books.remove_block(
                    granularity,
                    self.bitmap_offset(base, size),
                    NonNull::new_unchecked((base + size) as *mut _)
                );

                size <<= 1;
                granularity -= 1;
            }
        } else {
            // old_size == new_size, do nothing
        }

        ptr
    }
}
