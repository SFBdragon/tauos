//! Physical memory management services.

use core::{slice, ptr};
use uefi::table::boot::{MemoryType, MemoryDescriptor};
use crate::utils::LlistNode;

/// The pattern to check against `MemoryType`s for availability.
macro_rules! avl_mem_types {
    () => {
        MemoryType::LOADER_CODE |
        MemoryType::LOADER_DATA |
        MemoryType::BOOT_SERVICES_CODE |
        MemoryType::BOOT_SERVICES_DATA |
        MemoryType::CONVENTIONAL 
        // MemoryType::PERSISTENT_MEMORY ?
    };
}

/// Available memory map region descriptor accumulator and iterator.
struct AvlMemAcc<'a>(core::slice::Iter<'a, MemoryDescriptor>);

impl<'a> AvlMemAcc<'a> {
    /// Yeilds `(phys_base, virt_base, page_count)` describing unified regions of available memory.
    fn iter(mmap: &'a [MemoryDescriptor]) -> Self {
        Self(mmap.iter())
    }
}
impl<'a> Iterator for AvlMemAcc<'a> {
    type Item = (u64, u64, u64);

    fn next(&mut self) -> Option<Self::Item> {
        // loop until an available memory region is found
        let mut block = loop {
            if let Some(next) = self.0.next() {
                if let avl_mem_types!() = next.ty {
                    break (next.phys_start, next.virt_start, next.page_count);
                } else {
                    continue;
                }
            } else {
                // no more regions
                return None;
            }
        };
        
        // accumulate pages of contiguous available regions
        loop {
            if let Some(next) = self.0.next() {
                if let avl_mem_types!() = next.ty {
                    block.2 += next.page_count;
                }
            } else {
                return Some(block);
            }
        }
    }
}



/// An opaque handle to a contiguous block of memory. Used for reclamation.
#[derive(Debug)]
pub struct PhysMemHandle {
    pub virt_base: u64,
    phys_base: u64,
    page_count: u64,
}

impl PhysMemHandle {
    /// Create a handle to a block of memory which can be freed.
    /// # Safety:
    /// Direct is not recommended. You must guarantee that the block of memory is free, available, not
    /// to be otherwise allocated, usable, that the alignments are correct, and that the size is appropriate.
    pub unsafe fn new(virt_base: u64, phys_base: u64, page_count: u64) -> Self {
        Self {
            virt_base,
            phys_base,
            page_count,
        }
    }

    /// # Safety:
    /// * the provided reference to `self` must be of the current addressing mode
    /// * the address conversion must be accurate
    /// * the address conversion must be identical to that which is employed by the associated memory manager
    pub unsafe fn fix(&mut self, prev_to_curr_offset: isize) {
        // fixme: change to wrapping_add_signed if it shows promise of stabilization/gets stabilized
        self.virt_base = self.phys_base.wrapping_add(prev_to_curr_offset as u64);
    }
}



#[derive(Debug)]
pub struct PhysMemManager {
    pub phys_mem_size: u64,
    pub uefi_mmap: &'static mut [MemoryDescriptor],
    /// `LlistNode`s' data is (physical_base_address, page_count)
    llist_head: LlistNode<(u64, u64)>,
}

impl PhysMemManager {
    /// Creates a new physical memory manager, and prepares the physical address space for allocation.
    /// # Safety:
    /// * the provided reference to `self` must be of the current addressing mode
    /// * the address conversion offset must be accurate
    /// * only one instance should ever be active at once.
    pub unsafe fn new(uefi_mmap: &'static mut [MemoryDescriptor], phys_to_virt_offset: isize) -> Self {
        // calculate total physical memory amount
        let mut total_size = 0;
        // update uefi_mmap virtual addresses for later use
        for desc in uefi_mmap.iter_mut() {
            desc.virt_start = desc.phys_start.wrapping_add(phys_to_virt_offset as u64);
            total_size += desc.page_count;
        }

        // Construct a circular linked list where head is the largest region and all next are subsequently smaller.
        // The circular nature allows insertions and deletions to be done fast and branchlessly.

        let mut llist_head: *mut LlistNode = core::ptr::null_mut();
        for (phys_base, virt_base, page_count) in AvlMemAcc::iter(uefi_mmap) {
            // Safety: base_ptr is on a page boundary, thus it's guaranteed to be aligned for any type.
            // The same applies to all fields subsequently assigned to by base_ptr.
            // The memory at base_ptr is always assigned to immediately at or before use, such that both it
            // and all fields assigned to with base_ptr, are non-null.
            let base_ptr = virt_base as *mut LlistNode;
            
            if llist_head.is_null() {
                (*base_ptr) = LlistNode { prev: base_ptr, next: base_ptr, data: (phys_base, page_count) };
                llist_head = base_ptr;
            } else {
                let mut llist_node = llist_head;
                loop {
                    if (*llist_node).next == llist_head {
                        // end of list reached: seek, then fall through to insert at the end
                        llist_node = (*llist_node).next;
                    } else if (*llist_node).page_count > page_count {
                        // not llist end nor correct position: seek, continue
                        llist_node = (*llist_node).next;
                        continue;
                    }
                    
                    // insert just before llist_node
                    // note: this is not analagous to an else clause, as one of the other branches falls through
                    LlistNode::insert_new(virt_base, (*llist_node).prev, llist_node, phys_base, page_count);
                    break;
                }
            }
        }
        
        Self {
            phys_mem_size: total_size,
            uefi_mmap,
            llist_head,
        }
    }

    /// Fixes up the references and pointers within. Does not support decreasing the offset.
    /// # Safety:
    /// * the provided reference to `self` must be of the current addressing mode
    /// * the address conversion offset must be accurate
    /// * all currently active memory block handles must be fixed before they are used for reclamation
    pub unsafe fn fix(&mut self, prev_to_curr_offset: isize) {
        // fix up uefi_mmap reference
        self.uefi_mmap = slice::from_raw_parts_mut(
            self.uefi_mmap.as_mut_ptr().cast::<u8>().wrapping_offset(prev_to_curr_offset).cast(),
            core::ptr::metadata(self.uefi_mmap));

        // fix up internal virtual addresses
        for desc in self.uefi_mmap.iter_mut() {
            desc.virt_start = desc.virt_start.wrapping_add(prev_to_curr_offset as u64);
        }

        // fix up llist pointers
        self.llist_head = self.llist_head.cast::<u8>().wrapping_offset(prev_to_curr_offset).cast();
        let mut llist_node = self.llist_head;
        loop {
            (*llist_node).prev = (*llist_node).prev.cast::<u8>().wrapping_offset(prev_to_curr_offset).cast();
            (*llist_node).next = (*llist_node).next.cast::<u8>().wrapping_offset(prev_to_curr_offset).cast();

            if (*llist_node).next == self.llist_head {
                break;
            }

            llist_node = (*llist_node).next;
        }
    }
    
    /// Reserve the given amount of contiguous pages. The memory at the returned address is uninitialized/garbage.
    pub fn claim(&mut self, page_count: u64) -> PhysMemHandle {
        // Due to a lack of fast defragmentation for linked list allocators, the strategy chosen here is attempt 
        // to find best-fit, without wasting much memory. If there is no suitably-fitting regions, take out a 
        // chunk from the biggest region, as that should minimize the total external fragmentation the greatest.

        // extracted to avoid significant code duplication
        #[inline(always)]
        unsafe fn chomp_on_largest(manager: &mut PhysMemManager, page_count: u64) -> PhysMemHandle {
            // no 'ideal' regions available; use the largest region
            // note that this will not be reached if the first region is too small

            let largest_page_count = (*manager.llist_head).page_count - page_count;
            (*manager.llist_head).page_count = largest_page_count;

            let ret = PhysMemHandle {
                phys_base: (*manager.llist_head).phys_base + largest_page_count,
                virt_base: manager.llist_head as u64 + largest_page_count,
                page_count,
            };

            // however, there is a small possibility that the largest region may no longer be
            let next = (*manager.llist_head).next;
            if largest_page_count > (*(*manager.llist_head).next).page_count {
                // swap the head and next
                (*(*next).next).prev = manager.llist_head;
                (*(*manager.llist_head).prev).next = next;
                (*next).prev = (*manager.llist_head).prev;
                (*manager.llist_head).prev = (*next).next;
            }

            return ret;
        }
        
        // describes the fraction of the page_count, in powers of two, of extra pages, that is 'acceptable'
        // for instance: 0 allows double-sized regions to be used, 2 allows 1.25 times size, etc.
        const MAX_SUITABILITY_FACTOR: u32 = 2;
        assert!(page_count != 0);

        let max_accept_page_count = page_count + (page_count >> MAX_SUITABILITY_FACTOR);

        unsafe {
            // handle the case where no region will ever be found,
            // i.e. where the smallest region is bigger than required
            let smallest = (*self.llist_head).prev;
            let smallest_page_count = (*smallest).page_count;
            if smallest_page_count < page_count {
                if smallest_page_count <= max_accept_page_count {
                    // return the smallest
                    LlistNode::remove(smallest);
                    return PhysMemHandle {
                        phys_base: (*smallest).phys_base,
                        virt_base: smallest as u64,
                        page_count: smallest_page_count,
                    };
                } else {
                    // split largest
                    // requested is smaller than smallest, thus largest is definitely bigger
                    return chomp_on_largest(self, page_count);
                }
            }

            let mut curr_node = self.llist_head;
            let mut curr_page_count = (*curr_node).page_count;

            loop {
                let next_node = (*curr_node).next;
                let next_page_count = (*next_node).page_count;

                match next_page_count.cmp(&page_count) {
                    core::cmp::Ordering::Greater => {
                        // continue
                        curr_node = next_node;
                        curr_page_count = next_page_count;
                    },
                    core::cmp::Ordering::Equal => {
                        // use next region
                        LlistNode::remove(next_node);
                        return PhysMemHandle {
                            phys_base: (*next_node).phys_base,
                            virt_base: next_node as u64,
                            page_count: next_page_count,
                        };
                    },
                    core::cmp::Ordering::Less => {
                        if curr_page_count > max_accept_page_count {
                            // split largest
                            // current page is larger than page count, thus largest definitely is
                            return chomp_on_largest(self, page_count);
                        } else if curr_page_count > page_count { // eq case handled in previous iter
                            // it's 'ideal', and the next isn't usable; use the current region
                            LlistNode::remove(curr_node);
                            return PhysMemHandle {
                                phys_base: (*curr_node).phys_base,
                                virt_base: curr_node as u64,
                                page_count: curr_page_count,
                            };
                        } else {
                            // reached if first region is too small
                            panic!("No memory region large enough!");
                            // defrag/Result/other?
                        }
                    },
                }
            }
        }
    }
    /// Reclaim claimed contiguous memory.
    /// # Safety:
    /// * the handle must be unmodified from the form it was provided in
    /// * the handle must come from the same instance
    /// * the handle must only be provided to `relcaim` once
    pub unsafe fn reclaim(&mut self, mem_handle: PhysMemHandle) {
        // From the initial state, fragmentation only occurs from the largest page as a result of claims.
        // While the largest region may in fact change, this is rare as memory maps tend to have a single
        // region of free space much larger than the rest, thus it's only worth looking at the first or
        // second largest to try and defragment on reclaim.

        // try region one
        if self.llist_head as u64 + (*self.llist_head).page_count * amd64::paging::PTE_MAPPED_SIZE == mem_handle.virt_base {
            (*self.llist_head).page_count += mem_handle.page_count;
        }
        // implement region two check if it's seen to be worthwhile
        // note however that doing so may require flipping the llist order thereafter

        let mut curr_node = self.llist_head;
        loop {
            if (*curr_node).next == self.llist_head {
                // end of list reached: seek, then fall through to insert at the end
                curr_node = (*curr_node).next;
            } else if (*curr_node).page_count > mem_handle.page_count {
                // not llist end nor correct position: seek, continue
                curr_node = (*curr_node).next;
                continue;
            }
            
            // insert just before llist_node
            // note: this is not analagous to an else clause, as one of the other branches falls through
            LlistNode::insert_new(
                mem_handle.virt_base,
                (*curr_node).prev,
                curr_node,
                mem_handle.phys_base,
                mem_handle.page_count);
            break;
        }
    }

    /// Provides an `Iterator`-based interface for reserving discontinuous physical pages of amount `page_count`
    /// without allocating.
    /// 
    /// Pages are returned as continuously as possible, and retaining the ordering is highly recommended to
    /// be able to free them with minimal added fragmentation. Note that the iterator provided is a transparent 
    /// key for deallocation, such that calling `feed` on the return value of this function will restore the 
    /// state the memory manager was previously in, provided no intermediate operations.
    pub fn barf(&mut self, page_count: u64) -> impl Iterator<Item = u64> {
        // Strategy employed is to scan the llist backward until the quota specified as page_count has been met.
        // The node is then either spilt or taken as is, the previous node is found, and it is linked to the 
        // llist_head. This leaves the original last nodes detatched from the list, and can be iterated over
        // by the callee when convenient.
        unsafe {
            let mut pages_to_claim = page_count;
            let mut curr_node = (*self.llist_head).prev;

            loop {
                let curr_page_count = (*curr_node).page_count;
                if curr_page_count < pages_to_claim {
                    if curr_node == self.llist_head {
                        // total available memory didn't amount to enough
                        // todo: Result?
                        panic!("Requested pages ({}) > available pages ({}).", page_count - pages_to_claim, page_count);
                    } else {
                        pages_to_claim -= curr_page_count;
                        curr_node = (*curr_node).prev;
                        continue;
                    }
                } else if curr_page_count > pages_to_claim {
                    // split the current node
                    (*curr_node).page_count -= pages_to_claim;

                    let base_ptr = curr_node.cast::<u8>().wrapping_add(pages_to_claim as usize).cast();
                    (*base_ptr) = LlistNode {
                        prev: ptr::null_mut(),
                        next: (*curr_node).next,
                        phys_base: (*curr_node).phys_base + (*curr_node).page_count,
                        page_count: pages_to_claim,
                    };
                    // fallthrough
                } else {
                    // curr_node will be part of reserved; advance back
                    curr_node = (*curr_node).prev;
                }

                // set the last node's next to a terminator value
                (*(*self.llist_head).prev).next = ptr::null_mut();
                
                // link up the internal list to exclude the reserved nodes
                (*curr_node).next = self.llist_head;
                (*self.llist_head).prev = curr_node;

                
                // create an iterator over the pages
                return LlistIter { next: curr_node, terminator: ptr::null_mut() }
                    .flat_map(|(base, count)| 
                        (base as u64..(base as u64 + count * 0x1000)).step_by(0x1000))
            }
        }
    }

    /// Provides an `Iterator`-based interface for reserving discontinuous physical pages of amount `page_count`
    /// without allocating.
    /// 
    /// Pages must be yielded as continuously as possible. 
    /// # Safety:
    /// At the very least, size of groups of conitnuous iterated pages must be from
    /// high to low, terminating at the lowest. Using the iterator provided by `barf` is **not** valid unless the
    /// memory in those pages has not been written to.
    pub unsafe fn feed(&mut self, pages: impl Iterator<Item = u64>) {
        // Strategy: pages may have been added since the pages were allocated, so trusting that the pages
        // can be appended to the end of the list is woefully incorrect to maintain order. However, due to the
        // guarantee the the page clusters are continuous and ordered, they can be filtered into the map in O(n) time.
        // Seek the start of list append from the bottom, as it was taken from the bottom.

        //let mut curr_node
        todo!()
    }
}

struct LlistIter {
    pub next: *mut LlistNode<(u64, u64)>,
    pub terminator: *mut LlistNode<(u64, u64)>,
}

impl Iterator for LlistIter {
    type Item = (*mut LlistNode<(u64, u64)>, u64);

    fn next(&mut self) -> Option<Self::Item> {
        unsafe {
            if self.next == self.terminator {
                None
            } else {
                let curr_virt_addr = self.next;
                let curr_page_count = (*self.next).data.1;
                self.next = (*self.next).next;
                Some((curr_virt_addr, curr_page_count))
            }
        }
    }
}

/* 
/// Returns the handles to the regions occupied by `mmap` and `bin` respectively, allowing them to be freed when necessary.
pub fn claim_payload_data(mem_man: &mut PhysMemManager, payload: &mut crate::BootPayload) -> [PhysMemHandle; 2] {
    let mut handles = [
        PhysMemHandle { phys_base: 0, virt_base: 0, page_count: 0 }, 
        PhysMemHandle { phys_base: 0, virt_base: 0, page_count: 0 }];

    mem_man.uefi_mmap.iter_mut()
        .filter(|desc| desc.ty == crate::PAYLOAD_DATA_MEMORY_TYPE)
        .for_each(|desc| {
            let handles_index = 
                if desc.virt_start == payload.mmap.as_ptr() as u64 { 0 } 
                else if desc.virt_start == payload.bin.as_ptr() as u64 { 1 } 
                else { panic!("Unrecognised PAYLOAD_DATA_MEMORY_TYPE memory region!") };

            handles[handles_index] = PhysMemHandle {
                virt_base: desc.virt_start,
                phys_base: desc.phys_start,
                page_count: desc.page_count,
            };
            desc.ty = MemoryType::CONVENTIONAL;
        });
    
    if handles[0].page_count == 0 {
        panic!("Memory map region not found!")
    } else if handles[1].page_count == 0 {
        panic!("Kernal binary data region not found!")
    } else {
        handles
    }
} */
