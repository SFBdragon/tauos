use core::{
    ptr::{self, NonNull},
    alloc::{GlobalAlloc, Layout, Allocator, AllocError},

};
use crate::utils::{self, llist::LlistNode};

/// Limit imposed by the AMD64 linear address space.
pub const MAXIMUM_ARENA_SIZE: usize = 1 << 48;
/// Limit imposed by Talloc status data requirements.
pub const MINIMUM_ARENA_SIZE: usize = 1 << 6;


/// Returns whether the block of the given base is the lower of its buddy pair.
#[inline]
fn is_lower_buddy(block_base: *mut u8, size: usize) -> bool {
    block_base as usize & size == 0
}

/// Talloc Out-Of-Memory handler.
/// 
/// todo: explain
type OomHandler = fn(&mut Talloc, Layout) -> Result<(), AllocError>;

/// # Talloc: The TauOS Allocator
/// 
/// ### Features:
/// * Low time complexity and maximizing performance at the cost of memory usage
/// * Minimization of external fragmentation at the cost of internal fragmentation
/// * Arena can wrap around the address space
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
/// todo: new/new_invalid+extend & oom_handler stuff
pub struct Talloc {
    /// The base pointer of the arena.
    arena_base: isize,
    /// The size of the arena in bytes.
    arena_size: usize,
    /// The next power-of-two size of the arena in bytes.
    arena_size_pow2: usize,
    /// The power-of-two size of the smallest allocatable block in bytes.
    smlst_block: usize,

    /// Tracks memory block availability in the linked lists. Bit index corresponds to granularity.
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

    oom_handler: OomHandler,
}

unsafe impl Send for Talloc {}
unsafe impl Sync for Talloc {}

impl core::fmt::Debug for Talloc {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("Talloc")
        .field("arena_base", &format_args!("{:#x}", self.arena_base as usize))
        .field("arena_size", &format_args!("{:#x}", self.arena_size))
        .field("arena_size_pow2", &format_args!("{:#x}", self.arena_size_pow2))
        .field("smlst_block", &format_args!("{:#x}", self.smlst_block))
        .field("avails", &format_args!("{:#b}", self.avails))
        .field("llists", &format_args!("{:?}", self.llists))
        .field("bitmap", &format_args!("{:?}", self.bitmap))
        .field("oom_handler", &format_args!("{:#p}", self.oom_handler as *mut u8))
        .finish()
    }
}

impl Talloc {
    pub fn debug(&self) {
        crate::println!("{:?}", self);
    }

    /// Returns the corresponding granularity for a given block size.
    /// 
    /// `size` should not be larger than `self.arena_size_pow2`.
    #[inline]
    fn block_granularity(&self, size: usize) -> usize {
        // effectively computing: arena_size_pow2.log2() - size.log2()
        (size.leading_zeros() - self.arena_size_pow2.leading_zeros()) as usize
    }

    /// Returns the offset in bits into the bitmap that indicates the block's buddy status.
    /// ### Safety:
    /// `size` must be nonzero
    #[inline]
    unsafe fn bitmap_offset(&self, base: *mut u8, size: usize) -> usize {
        let aligned_arena_base = self.arena_base & !((size << 1) as isize-1);
        let field_offset = (base as isize - aligned_arena_base) as usize;
        // offset of the granularity's field, plus, offset into the field
        // Precalculating `arena_size_pow2`, approximately halves generated assembly.
        (self.arena_size_pow2 + field_offset) >> utils::fast_non0_log2(size)+1
        // equivalent to:
        // arena_size_pow2 >> (log2(block_size) + 1), plus,
        // block_size - (arena_base &!(size - 1)) >> (log2(block_size) + 1)
    }
    /// Utility function to read the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn read_bitflag(&self, bitmap_offset: usize) -> bool {
        let index = bitmap_offset >> u8::BITS.trailing_zeros();
        let data = *self.bitmap.get_unchecked_mut(index);
        let bit_mask = 1 << (bitmap_offset & u8::BITS as usize - 1);
        data & bit_mask != 0
    }
    /// Utility function to toggle the bitmap at the offset in bits.
    /// ### Safety:
    /// `bitmap_offset` must be correct and within the bounds of the bitmap.
    #[inline]
    unsafe fn toggle_bitflag(&mut self, bitmap_offset: usize) {
        let index = bitmap_offset >> u8::BITS.trailing_zeros();
        let data = self.bitmap.get_unchecked_mut(index);
        let bit_mask = 1 << (bitmap_offset & u8::BITS as usize - 1);
        *data ^= bit_mask;
    }

    /// Registers a block into the books, making it available for allocation.
    /// ### Safety:
    /// `bitmap_offset`'s source `size` and `position` must agree with
    /// `granularity`'s corresponding block size and `node`'s block base and size.
    #[inline]
    unsafe fn add_block_next(&mut self, granularity: usize, bitmap_offset: usize, node: *mut LlistNode<()>) {
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
    unsafe fn remove_block(&mut self, granularity: usize, bitmap_offset: usize, node: *mut LlistNode<()>) {
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


    /// Guaratees the following:
    /// * `arena_size` and `smallest_block` are nonzero.
    /// * `arena_size.next_power_of_two()` does not overflow.
    /// * `smallest_block` is a powers of two.
    /// * `smallest_block` is larger or equal to the size of a `LlistNode<()>`.
    const fn validate_arena_args(arena_size: usize, smallest_block: usize) {
        let llist_node_size = core::mem::size_of::<LlistNode<()>>();
        assert!(arena_size >= MINIMUM_ARENA_SIZE);
        assert!(arena_size <= MAXIMUM_ARENA_SIZE);
        assert!(smallest_block.is_power_of_two());
        assert!(smallest_block >= llist_node_size);
    }
    
    /// Returns `llists` length and `bitmap` length respectively.
    pub const fn slice_bytes(arena_size: usize, smallest_block: usize) -> (usize, usize) {
        Self::validate_arena_args(arena_size, smallest_block);

        // validate_arena_args guarantees `arena_size` and `smallest_block` are non-zero
        // and that `arena_size.next_power_of_two()` does not overflow
        let llists_len = ((arena_size - 1).log2() + 1) - smallest_block.log2() + 1;
        let bitmap_len = 1usize << llists_len >> u8::BITS.trailing_zeros();
        
        (
            llists_len as usize * core::mem::size_of::<LlistNode<()>>(),
            if bitmap_len != 0 { bitmap_len } else { 1 }
        )
    }

    /// ### Arguments:
    /// * `arena` 
    /// ### Safety:
    /// * `free_mem` must be valid for reads and writes.
    pub unsafe fn new(arena_base: isize, arena_size: usize, smallest_block: usize, 
    free_mem: *mut [u8], oom_handler: OomHandler) -> Self {
        let mut talloc = Self::new_invalid(smallest_block, oom_handler);
        talloc.extend(arena_base, arena_size, free_mem);
        talloc
    }

    /// Returns an invalid `Talloc`.
    /// This can be useful for initializing static variables.
    /// 
    /// Alternatively consider using `Talloc::new`.
    /// ### Safety: 
    /// The returned instance is valid only for the `extend_arena` method call,
    /// which initializes the `Talloc` fully. Don't touch anything else.
    pub const unsafe fn new_invalid(smallest_block: usize, oom_handler: OomHandler) -> Self {
        Self {
            arena_base: 0,
            arena_size_pow2: 0,
            arena_size: 0,
            smlst_block: smallest_block,
            avails: 0,
            llists: ptr::slice_from_raw_parts_mut(ptr::null_mut(), 0),
            bitmap: ptr::slice_from_raw_parts_mut(ptr::null_mut(), 0),
            oom_handler,
        }
    }

    /// Returns `(arena_base, arena_size)`.
    pub fn get_arena(&self) -> (isize, usize) {
        (self.arena_base, self.arena_size)
    }
    /// Returns the size requirement for a `free_mem` block
    /// for the given arena parameters as required by `Talloc::extend`.
    pub fn req_free_mem(&self, arena_base: isize, arena_size: usize) -> usize {
        let (ll_bytes, bm_bytes) = Talloc::slice_bytes(arena_size, self.smlst_block);
        // status data memory: padding (max 15)..., llists..., bitmap...
        arena_base as usize % 16 + ll_bytes + bm_bytes
    }

    /// todo
    pub unsafe fn extend(&mut self, arena_base: isize, arena_size: usize, free_mem: *mut [u8]) {
        // get slice byte lengths + validates arena args
        let (ll_bytes, bm_bytes) = Self::slice_bytes(arena_size, self.smlst_block);
        // ensure free_mem is within arena_base, arena_size
        let arena_acme = arena_base + arena_size as isize;
        assert!(free_mem.as_mut_ptr() as isize >= arena_base);
        assert!(free_mem.as_mut_ptr().wrapping_add(free_mem.len()) as isize <= arena_acme);
        // ensure arena_base, arena_size covers the old arena
        if self.bitmap.len() != 0 {
            assert!(arena_base <= self.arena_base);
            assert!(self.arena_base + (self.arena_size as isize) <= arena_acme);
        }

        // use free_mem to create new, larger status data slices
        let node_size: usize = core::mem::size_of::<LlistNode<()>>();
        let ll_align_offset = node_size - (free_mem.as_mut_ptr() as usize & node_size-1);
        // same calculation as req_free_mem
        let mem_offset = ll_align_offset + ll_bytes + bm_bytes;
        let llists_ptr = free_mem.as_mut_ptr().wrapping_add(ll_align_offset);
        let bitmap_ptr = llists_ptr.wrapping_add(ll_bytes);

        // new talloc instance
        let mut talloc = Talloc {
            arena_base,
            arena_size,
            arena_size_pow2: arena_size.next_power_of_two(),
            smlst_block: self.smlst_block,
            avails: 0,
            llists: ptr::slice_from_raw_parts_mut(llists_ptr.cast(), ll_bytes / node_size),
            bitmap: ptr::slice_from_raw_parts_mut(bitmap_ptr, bm_bytes),
            oom_handler: self.oom_handler,
        };
        
        // copy/init llists
        let gra_diff = talloc.llists.len() - self.llists.len();
        for i in 0..talloc.llists.len() {
            if i < gra_diff {
                LlistNode::new_llist(talloc.llists.get_unchecked_mut(i), ());
            } else {
                LlistNode::mov(
                    self.llists.get_unchecked_mut(i - gra_diff),
                    talloc.llists.get_unchecked_mut(i),
                );
            }
        }

        // set avails
        talloc.avails = self.avails << gra_diff;
        
        // init/copy bitmap
        talloc.bitmap.as_mut_ptr().write_bytes(0, talloc.bitmap.len());
        if self.bitmap.len() != 0 {
            for g in 0..self.llists.len() {
                // Bitmap looks like so: 01223333_44444444_55555555_55555555_6...
                // Bitmap is 16-byte aligned due to being directly after llists.
                // Bitmap is hence byte aligned for granularities >= 4
                let old_bmp_bit_offst_sz = (1usize << g >> 1).max(1);
                let new_bmp_bit_offst = talloc.bitmap_offset(
                    self.arena_base as *mut u8, 
                    self.arena_size_pow2 >> g
                );
                if g < 4 {
                    utils::copy_slice_bits(
                        talloc.bitmap,
                        self.bitmap,
                        new_bmp_bit_offst,
                        old_bmp_bit_offst_sz,
                        old_bmp_bit_offst_sz,
                    );
                } else {
                    let old_ptr = self.bitmap.get_unchecked_mut(old_bmp_bit_offst_sz / 8);
                    let new_ptr = talloc.bitmap.get_unchecked_mut(new_bmp_bit_offst / 8);
                    new_ptr.copy_from_nonoverlapping(old_ptr, old_bmp_bit_offst_sz / 8);
                }
            }
        }

        if self.bitmap.len() != 0 {
            // free the old status data + ceil to next smlst_block
            let size = core::mem::size_of_val_raw(self.llists) + self.bitmap.len();
            let size_ceild = size + self.smlst_block - 1 & !(self.smlst_block - 1);
            talloc.release(ptr::slice_from_raw_parts_mut(self.llists.cast(), size_ceild));
        }

        *self = talloc;
        self.release(free_mem.get_unchecked_mut(mem_offset..));
    }


    
    /// Release memory for allocation.
    /// Address-space wraparound is allowed, but `null` block will not be released.
    /// ### Safety:
    /// * `mem` must be reserved (unallocatable).
    /// * `mem` must be safely readable and writable.
    pub unsafe fn release(&mut self, mem: *mut [u8]) {
        let sbm1 = self.smlst_block as isize - 1;
        let base = mem.as_mut_ptr() as isize + sbm1 & !sbm1;
        let acme = mem.as_mut_ptr() as isize + mem.len() as isize & !sbm1;

        assert!(base >= self.arena_base);
        assert!(acme <= self.arena_base + self.arena_size as isize);

        // nothing to release; return early
        if base == acme {
            return;
        }
        
        // avoid releasing null
        if base <= 0 && 0 < acme {
            self.release(mem.get_unchecked_mut(..((0 - base) as usize)));
            self.release(mem.get_unchecked_mut(((self.smlst_block as isize - base) as usize)..));
            return;
        }

        // Strategy:
        // - Start address at the base of the bounds
        // - Allocate as large a block as possible repeatedly for the given alignment, bump address
        // -    Do so until adding a larger block would overflow the top bound
        // - Allocate the previous power of two of the delta between current address and top + smlst, bump address
        // - When the delta is zero, the bounds have been entirely filled
        
        let mut block_base = base;
        let mut asc_block_sizes = true;
        loop {
            let block_size = if asc_block_sizes {
                let block_size = 1 << block_base.trailing_zeros();

                if block_base + block_size as isize <= acme {
                    block_size
                } else {
                    asc_block_sizes = false;
                    continue;
                }
            } else {
                let delta = (acme - block_base) as usize;
                if delta >= self.smlst_block {
                    // SAFETY: smlst_block is never zero
                    utils::fast_non0_prev_pow2(delta)
                } else {
                    break;
                }
            };
            
            // SAFETY: deallocating reserved memory is valid and memory safe
            // and block_size is not smaller than self.smlst_block
            // and null has already been avoided from being released
            self.dealloc(
                NonNull::new_unchecked(block_base as *mut u8), 
                Layout::from_size_align_unchecked(block_size, 1)
            );
            
            block_base += block_size as isize;
        }
    }
    
    
    /// Takes a `Layout` and outputs a block size that is:
    /// * Nonzero
    /// * A power of two
    /// * Not smaller than smlst_block
    /// * Not smaller than `layout.size`
    /// * Sufficiently aligned
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
    
    /// Allocate memory. 
    /// 
    /// Allocations are guaranteed to be a power of two in size, *align-sized*,
    /// not smaller than `layout.size()`.
    /// 
    /// Returns `Err` upon memory exhaustion.
    /// May return a *valid* zero-pointer. See `Talloc` docs for more info.
    /// ### Safety:
    /// * `layout.size()` must be nonzero.
    pub unsafe fn alloc(&mut self, layout: Layout) -> Result<NonNull<u8>, AllocError> {
        // SAFETY: caller guaranteed
        let size = self.layout_to_size(layout);

        // signal OOM until either AllocError or arena_size is large enough
        // otherwise granularity is, garbage in, garbage out
        while size > self.arena_size { (self.oom_handler)(self, layout)?; }
        
        let mut granularity = self.block_granularity(size);

        // allocate immediately if a block of the correct size is available
        if self.avails & 1 << granularity != 0 {
            return Ok(NonNull::new_unchecked(self.remove_block_next(granularity, size)));
        }

        // find a larger block (smaller granularity) to break apart:
        let larger_avl = loop {
            let larger_avl = self.avails & !(usize::MAX << granularity);
            if larger_avl == 0 {
                (self.oom_handler)(self, layout)?;
                granularity = self.block_granularity(size);
                continue;
            } else {
                break larger_avl;
            }
        };
        
        let lgr_granularity = utils::fast_non0_log2(larger_avl);
        let lgr_size = self.arena_size_pow2 >> lgr_granularity;
        let lgr_base = self.remove_block_next(lgr_granularity, lgr_size);
        
        
        // break down the large block into smaller blocks
        let mut hi_block_size = lgr_size >> 1;
        for hi_granularity in (lgr_granularity + 1)..=granularity {
            // SAFETY: https://yewtu.be/watch?v=rp8hvyjZWHs
            
            let hi_block_base = lgr_base.wrapping_add(hi_block_size);
            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                hi_block_base.cast()
            );

            hi_block_size >>= 1;
        }

        Ok(NonNull::new_unchecked(lgr_base))
    }

    /// Deallocate the block of memory.
    /// ### Safety:
    /// `ptr` must have been previously allocated, given `layout`.
    /// 
    /// Or, `ptr` must be completely reserved over the span indicated by
    /// `layout`, and block-size sized and aligned. Do not use this for
    /// releasing memory. Instead use `release`.
    pub unsafe fn dealloc(&mut self, ptr: NonNull<u8>, layout: Layout) {
        let mut ptr = ptr.as_ptr();
        // SAFETY: caller (of dealloc, hence alloc) guaranteed
        let mut size = self.layout_to_size(layout);

        let mut granularity = self.block_granularity(size);
        let mut bitmap_offset = self.bitmap_offset(ptr, size);
        while self.read_bitflag(bitmap_offset) {
            // while buddy was heterogenous - available
            let (buddy_ptr, next_ptr) = if is_lower_buddy(ptr, size) {
                (ptr.wrapping_add(size), ptr)
            } else {
                (ptr.wrapping_sub(size), ptr.wrapping_sub(size))
            };
            
            // SAFETY: buddy has been confirmed to exist here, LlistNodes are not moved
            self.remove_block(granularity, bitmap_offset, buddy_ptr.cast());
            
            size <<= 1;
            ptr = next_ptr;
            granularity -= 1;
            bitmap_offset = self.bitmap_offset(ptr, size);
        }
        
        self.add_block_next(granularity, bitmap_offset, ptr.cast());
    }

    /// Shrink the block of memory provided in-place.
    /// ### Safety:
    /// * `old_layout`'s must be smaller or equal to `new_layout`'s required size and align.
    /// * `ptr` must have been previously acquired, given `old_layout`.
    pub unsafe fn shrink(&mut self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) {
        // SAFETY: caller guaranteed
        let old_size = self.layout_to_size(old_layout);
        let new_size = self.layout_to_size(new_layout);

        if old_size == new_size { return; }
        
        // break up the block until the required size is reached
        let old_granularity = self.block_granularity(old_size);
        let new_granularity = self.block_granularity(new_size);

        let mut hi_block_size = old_size >> 1;
        for hi_granularity in (old_granularity + 1)..=new_granularity {
            let hi_block_base = ptr.as_ptr().wrapping_add(hi_block_size);

            self.add_block_next(
                hi_granularity,
                self.bitmap_offset(hi_block_base, hi_block_size),
                hi_block_base.cast()
            );

            hi_block_size >>= 1;
        }
    }
}


/// Concurrency synchronisation layer on top of `Talloc`, see its documentation for more.
/// 
/// This is just a thin wrapper containing a spin mutex which implements the allocator
/// traits as the underlying allocator is not internally synchronized.
#[derive(Debug)]
pub struct Tallock(pub spin::Mutex<Talloc>);

impl Tallock {
    /// Acquire the lock on the `Talloc`.
    #[inline]
    pub fn lock(&self) -> spin::MutexGuard<Talloc> {
        self.0.lock()
    }
}

unsafe impl GlobalAlloc for Tallock {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        self.lock().alloc(layout).map_or(core::ptr::null_mut(), |nn| nn.as_ptr())
    }

    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        // SAFETY: caller guaranteed that the given ptr was allocated
        // where null means allocation failure, thus ptr is not null
        self.lock().dealloc(NonNull::new_unchecked(ptr), layout);
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        match self.lock().alloc(layout) {
            Ok(ptr) => {
                ptr.as_ptr().write_bytes(0, layout.size());
                ptr.as_ptr()
            },
            Err(_) => ptr::null_mut(),
        }
    }

    unsafe fn realloc(&self, ptr: *mut u8, old_layout: Layout, new_size: usize) -> *mut u8 {
        // SAFETY: see dealloc
        if old_layout.size() < new_size {
            let allocation = Talloc::alloc(
                &mut self.lock(),
                Layout::from_size_align_unchecked(new_size, old_layout.align())
            );
            match allocation {
                Ok(allocd_ptr) => {
                    ptr::copy_nonoverlapping(ptr, allocd_ptr.as_ptr(), old_layout.size());
                    self.dealloc(ptr, old_layout);
                    allocd_ptr.as_ptr()
                },
                Err(_) => ptr::null_mut(),
            }
        } else {
            self.lock().shrink(
                NonNull::new_unchecked(ptr), 
                old_layout, 
                Layout::from_size_align_unchecked(new_size, old_layout.align())
            );
            ptr
        }
    }
}

unsafe impl Allocator for Tallock {
    fn allocate(&self, layout: Layout) -> Result<NonNull<[u8]>, AllocError> {
        if layout.size() != 0 {
            unsafe {
                self.lock().alloc(layout).map(|nn| 
                    NonNull::slice_from_raw_parts(nn, layout.size())
                )
            }
        } else {
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }

    unsafe fn deallocate(&self, ptr: NonNull<u8>, layout: Layout) {
        if ptr != NonNull::dangling() {
            self.lock().dealloc(ptr, layout)
        }
    }

    unsafe fn shrink(&self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout)
    -> Result<NonNull<[u8]>, AllocError> {
        if new_layout.size() != 0 {
            self.lock().shrink(ptr, old_layout, new_layout);
            Ok(NonNull::slice_from_raw_parts(ptr, new_layout.size()))
        } else {
            self.deallocate(ptr, old_layout);
            Ok(NonNull::slice_from_raw_parts(NonNull::dangling(), 0))
        }
    }
}






/* /// Returns a closed range describing the span of memory conservatively 
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
} */


/* /// Reserve released memory against use within half-open `span`.
/// Address-space wraparound is allowed.
/// 
/// `span` is expected to be the result of `bound_available` or `bound_reserved`.
/// 
/// ### Safety:
/// The memory within `bound` must be entirely available for allocation.
/// 
/// ***Note*** this is an almost impossible requirement to guarantee under most 
/// normal circumstances during allocator use.
/// 
/// ### Performance:
/// This function has potentially poor performance where `span`'s fields 
/// are poorly aligned (time complexity 2^n, where n is proportional to 
/// the smallest trailing zero count). Accounting for this is recommended 
/// if this function is to be used in a hotter path.
pub unsafe fn reserve(&mut self, span: Range<isize>) {
    // Strategy:
    // - Loop through all available block nodes to the smallest granularity 
    //   possible given bound alignment
    // - On encountering a fully contained block, reserve it
    // - On encountering a partially contained block, break it down, 
    //   reserving it within the bound

    // validity checks
    debug_assert!(span.start >= self.arena_base);
    debug_assert!(span.end <= (self.arena_base + self.arena_size as isize));
    debug_assert!(span.start as usize & self.smlst_block-1 == 0);
    debug_assert!(span.end as usize & self.smlst_block-1 == 0);

    // nothing to reserve; return early
    if span.start == span.end {
        return;
    }

    // avoid reserving null, as it is never released
    if span.contains(&0) {
        self.reserve(span.start..0);
        self.reserve((self.smlst_block as isize)..span.end);
        return;
    }

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
            let block_base = node.as_ptr() as isize;
            let block_end = block_base + block_size as isize;
            
            if span.start <= block_base && block_end <= span.end {
                // this block is entirely reserved
                self.remove_block(
                    granularity, 
                    self.bitmap_offset(node.cast(), block_size), 
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
                        self.bitmap_offset(node.cast(), block_size), 
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

                        // SAFETY: null is never released or reserved, see above
                        let base_node_ptr = NonNull::new_unchecked(base as *mut _);
                        self.add_block_next(
                            self.block_granularity(block_size),
                            self.bitmap_offset(base_node_ptr.cast(), block_size),
                            base_node_ptr,
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

                        // SAFETY: null is never released or reserved, see above
                        let acme_node_ptr = NonNull::new_unchecked(acme as *mut _);
                        self.add_block_next(
                            self.block_granularity(block_size),
                            self.bitmap_offset(acme_node_ptr.cast(), block_size),
                            acme_node_ptr,
                        );
                    }
                }
            }
        }
        block_size >>= 1;
    }
} */


/* /// Grow the block of memory provided.
/// 
/// Allocations are guaranteed to be a power of two in size, *align-sized*,
/// not smaller than `new_layout.size()`.
/// 
/// Returns `Err` upon memory exhaustion. 
/// May return a *valid* null pointer. See `Talloc` docs for more info.
/// ### Safety:
/// * `old_layout`'s must be smaller or equal to `new_layout`'s required size and align.
/// * `ptr` must have been previously acquired, given `old_layout`.
pub unsafe fn grow(&mut self, ptr: NonNull<u8>, old_layout: Layout, new_layout: Layout) -> Result<NonNull<u8>, AllocError> {
    // SAFETY: caller guaranteed
    let old_size = self.layout_to_size(old_layout);
    let new_size = self.layout_to_size(new_layout);
    
    if old_size == new_size { return Ok(ptr); }

    let old_granularity = self.block_granularity(old_size);
    let new_granularity = self.block_granularity(new_size);
    
    // Check high buddies recursively, if available, reserve them, else realloc.
    // This satisfies the requirement on Allocator::grow that the memory
    // must not be modified or reclaimed if Err is returned.

    let mut size = old_size;
    let mut bitmap_offset = self.bitmap_offset(ptr.as_ptr(), size);
    let mut granularity = old_granularity;

    while granularity > new_granularity {
        // realloc is necessary:
        // * if this is a high buddy and a larger block is required
        // * if the high buddy is not available and a larger block is required
        if !is_lower_buddy(ptr.as_ptr(), size) || !self.read_bitflag(bitmap_offset) {
            let allocation = self.alloc(new_layout);
            if let Ok(alloc_ptr) = allocation {
                ptr::copy_nonoverlapping(
                    ptr.as_ptr(), 
                    alloc_ptr.as_ptr(), 
                    old_layout.size()
                );
                self.dealloc(ptr, old_layout);
            }
            return allocation;
        }
        
        size <<= 1;
        granularity -= 1;
        bitmap_offset = self.bitmap_offset(ptr.as_ptr(), size);
    }

    // reiterate, having confirmed there is sufficient memory available
    // remove all buddy nodes as necessary
    let mut size = old_size;
    let mut granularity = old_granularity;
    while granularity > new_granularity {
        self.remove_block(
            granularity,
            self.bitmap_offset(ptr.as_ptr(), size),
            ptr.as_ptr().wrapping_add(size).cast()
        );

        size <<= 1;
        granularity -= 1;
    }

    println!("re s");
    Ok(ptr)
} */
