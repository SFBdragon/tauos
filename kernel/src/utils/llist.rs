use core::{mem::MaybeUninit, ptr::NonNull, cell::Cell, marker::{PhantomData, PhantomPinned}, pin::Pin};


/// Describes a linked list node.
/// 
/// The linked list is:
///  * **intrusive** to minimize indirection
///  * **circular** to minimize branches
///  * **uses the concept of a 'head' node** which is homogenous, but isn't iterated over
///  * **implicitly non-zero in length** by virtue of the lack of a heterogenous component
///  * **doubly linked** to allow bidirectional traversal and single ref removal
///  * **fairly unsafe** due to inter-referenciality and self-referenciality
/// 
/// # Safety:
/// `LlistNode<T>`s are inherently unsafe due to the referencial dependency between nodes,
/// as well as the self-referencial configuration with linked lists of length 1. This requires
/// that `LlistNode<T>`s are never moved manually, otherwise using the list becomes memory
/// unsafe and may lead to undefined behaviour.
/// 
/// Generally speaking, traversal while holding references to multiple nodes is also potentially
/// undefined behaviour/memory unsafe due to the risk of aliasing mutable pointers. Exclusive
/// access to the list is recommended to be maintained through a sentinel node where possible.
/// See traversal methods' docs for more detail. Miri has been used to test the unsafety thereof,
/// and generally causing undefined bahviour is difficult without holding references to `data`
/// through other references to nodes while traversing with self. Thus making `data` a `Cell` may
/// further mitigate the possiblity of misuse.
/// 
/// This data structure is not thread-safe, use mutexes/locks to mutually exclude data access.
#[derive(Debug)]
pub struct LlistNode<T> {
    pub data: T,
    next: Cell<NonNull<LlistNode<T>>>,
    prev: Cell<NonNull<LlistNode<T>>>,
    _pin: PhantomPinned,
}

impl<T> Drop for LlistNode<T> {
    fn drop(&mut self) {
        // pin is not moved into or out of
        let pin = unsafe { Pin::new_unchecked(self) };
        // `self` may have already been `.remove()`d, however doing so is fine as it is hence semantically a no-op
        // in such a case it may be a needless expense, in which case nodes should instead be overwitten through pointers
        // or forgotten. Talloc does not ever drop nodes, it only overwrites them. Nodes should never enter an invalid
        // state, thus leaving them un-dropped should not decay their states ever, as they are immovable.
        pin.remove();
    }
}

impl<T> LlistNode<T> {
    /// Get a mutable reference to the next node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the next node. The memory the resulting reference
    /// references must not be read or written to through any other pointer. This is relevant when holding
    /// a reference to a node's `data`, for instance.
    #[inline]
    pub unsafe fn next_mut(self: Pin<&mut Self>) -> Pin<&mut Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_mut`'s aliasing requirements are upheld, API enforeces the rest
        Pin::new_unchecked(self.as_ref().next.get().as_mut())
    }
    /// Get a mutable reference to the previous node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the next node. The memory the resulting reference
    /// references must not be read or written to through any other pointer. This is relevant when holding
    /// a reference to a node's `data`, for instance.
    #[inline]
    pub unsafe fn prev_mut(self: Pin<&mut Self>) -> Pin<&mut Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_mut`'s aliasing requirements are upheld, API enforeces the rest
        Pin::new_unchecked(self.as_ref().prev.get().as_mut())
    }

    /// Get a reference to the next node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the next node. The memory the resulting reference
    /// references must not be written to through any other pointer. This is relevant when holding
    /// a reference to a node's `data`, for instance.
    #[inline]
    pub unsafe fn next(self: Pin<&Self>) -> Pin<&Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_ref`'s aliasing requirements are upheld, API enforces the rest
        Pin::new_unchecked(self.as_ref().next.get().as_ref())
    }
    /// Get a reference to the previous node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the next node. The memory the resulting reference
    /// references must not be written to through any other pointer. This is relevant when holding
    /// a reference to a node's `data`, for instance.
    #[inline]
    pub unsafe fn prev(self: Pin<&Self>) -> Pin<&Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_ref`'s aliasing requirements are upheld, API enforces the rest
        Pin::new_unchecked(self.as_ref().prev.get().as_ref())
    }

    /// Returns whether the previous and next nodes are identical, essentially detecting if the list is
    /// of length 1 (previous and next are self) **or** 2 (previous and next are other) else more.
    #[inline]
    pub fn is_neighbours_equal(self: Pin<&Self>) -> bool {
        self.prev.get() == self.next.get()
    }



    /// Create a new independent node in place.
    /// 
    /// Warning: This will not call `node`'s drop code, regardless of initialization. 
    /// It is your responsibility to make sure `node` gets removed/dropped if/as necessary.
    /// Failing to do so when is not undefined behaviour or memory unsafe, but may cause unexpected behaviour:
    /// `node` will become a 'sink' node, trapping traversal from its previous linked list. This is often not desirable.
    #[inline]
    pub const fn new_llist(node: Pin<&'_ mut MaybeUninit<Self>>, data: T) -> Pin<&'_ mut Self> {
        let node_ref = unsafe {
            // SAFETY: node is not moved
            node.get_unchecked_mut()
        };

        let node_ptr = unsafe { 
            // SAFETY: node is a valid reference, thus the resulting pointer is valid and dereferencable
            NonNull::new_unchecked(
                // SAFETY: node_ptr is not dereferenced before it is initialized
                node_ref as *mut _ as *mut Self
            )
        };

        let initd_node = node_ref.write(Self {
            data,
            prev: Cell::new(node_ptr),
            next: Cell::new(node_ptr),
            _pin: PhantomPinned,
        });

        unsafe {
            // SAFETY: node arg is contractually pinned, thus pinning guarantee is maintained
            Pin::new_unchecked(initd_node)
        }
    }

    /// Create a new node as a member of an existing linked list in place of `node`.
    /// 
    /// `prev` and `next` may belong to different linked lists,
    /// doing do may however cause complex and unexpected linkages.
    /// 
    /// Warning: This will not call `node`'s drop code, regardless of initialization. 
    /// It is your responsibility to make sure `node` gets removed/dropped if/as necessary.
    /// Failing to do so when is not undefined behaviour or memory unsafe, but may cause unexpected behaviour:
    /// a figure 8 pattern will form between two circular linked lists. This is often not desirable.
    pub fn new<'s, 'p, 'n>(node: Pin<&'s mut MaybeUninit<Self>>, prev: &'p Self, next: &'n Self, data: T)
    -> Pin<&'s mut Self> {
        // SAFETY: node is not moved
        let initd_node = unsafe { node.get_unchecked_mut() }.write(Self { 
            data,
            prev: Cell::new(prev.into()),
            next: Cell::new(next.into()),
            _pin: PhantomPinned,
        });

        next.prev.set(initd_node.into());
        prev.next.set(initd_node.into());

        unsafe {
            // SAFETY: node arg is contractually pinned, thus pinning guarantee is maintained
            Pin::new_unchecked(initd_node)
        }
    }

    /// Move `self` into a new location, leaving `self` as an isolated linked list with `replacement_data` while
    /// the result of the function is identical to `self` as of calling but in a different memory location.
    pub fn mov<'a>(mut self: Pin<&mut Self>, dest: Pin<&'a mut MaybeUninit<Self>>, replacement_data: T) -> Pin<&'a mut Self> {
        // SAFETY: node is not moved
        let initd_node = unsafe { dest.get_unchecked_mut() }.write(Self { 
            // SAFETY: moving data does not invalidate the pinning which is inteded for `prev` and `next`
            data: core::mem::replace(&mut unsafe { self.as_mut().get_unchecked_mut() }.data, replacement_data),
            prev: Cell::new(self.prev.get()),
            next: Cell::new(self.next.get()),
            _pin: PhantomPinned,
        });
        
        unsafe {
            // SAFETY: `prev` and `next` are not publicly exposed, and are not set to be non-dereferenceable internally
            (*self.prev.get().as_ptr()).prev.set(initd_node.into());
            (*self.next.get().as_ptr()).next.set(initd_node.into());
        }

        // SAFETY: self is not moved
        let self_ptr = unsafe { self.as_mut().get_unchecked_mut().into() };
        self.prev.set(self_ptr);
        self.next.set(self_ptr);

        unsafe {
            Pin::new_unchecked(initd_node)
        }
    }

    /// Isolate `node`, removing it from its linked list, and effectively making a new linked list of only `node`.
    pub fn remove(mut self: Pin<&mut Self>) {
        // the linked list is circular, which always has an element that isn't removed
        // thus in the case that this is the last element, this is still safe, and there is no case of zero elements

        unsafe {
            // SAFETY: `prev` and `next` are not publicly exposed, and are not set to be non-dereferenceable internally
            (*self.prev.get().as_ptr()).next.set(self.next.get());
            (*self.next.get().as_ptr()).prev.set(self.prev.get());
        }

        unsafe {
            // SAFETY: Deref/DerefMut are not malicious, 
            // `prev` and `next` are not publicly exposed, and the pointer is neither moved out of or into internally
            let self_ptr = NonNull::from(self.as_mut().get_unchecked_mut());
            self.prev.set(self_ptr);
            self.next.set(self_ptr);
        }
    }


    /// Removes a chain of nodes from `start` to `end` inclusive from it's current list and inserts the
    /// chain between `prev` and `next`. Can be used to move a chain within a single list.
    /// 
    /// # Arguments
    /// * `start` and `end` can be identical (relink 1 node).
    /// * `prev` and `next` can be identical (relink around a 'head' - `prev`/`next`).
    /// * All 4 arguments can be identical (orphans a single node as its own linked list).
    /// 
    /// While `start`/`end` and `prev`/`next` should belong to the same lists respectively, this is not required.
    /// Not doing so may create complex or nonsensical links.
    pub fn relink(start: &Self, end: &Self, prev: &Self, next: &Self) {
        // link up old list
        unsafe {
            // SAFETY: a reference is not created to neighbouring nodes to avoid aliasing refereces
            // modification occurs through a Cell (UnsafeCell), thus mut refs' rules are not violated
            (*start.prev.get().as_ptr()).next.set(end.next.get());
            (*end.next.get().as_ptr()).prev.set(start.prev.get());
        }

        // link up new list
        start.prev.set(prev.into());
        end.next.set(next.into());
        prev.next.set(start.into());
        next.prev.set(end.into());
    }


    /// Creates an iterator over the circular linked list using `self` as the sentinel item.
    /// 
    /// Note that this iterator is both `DoubleEndedIterator` and allows the modification and
    /// deletion of the current node without effecting iteration.
    /// 
    /// # Safety:
    /// Caller must guarantee that their are no active references to the linked lists' nodes besides `node`,
    /// and the references that will be returned from the iterator, until the iterator is dropped.
    pub unsafe fn iter_mut<'llist>(mut self: Pin<&mut Self>) -> IterMut<'llist, T> {
        IterMut {
            // SAFETY: Iter does not move sentinel
            sentinel: self.as_mut().get_unchecked_mut().into(),
            next_backward: self.as_ref().prev.get(),
            next_forward: self.as_ref().next.get(),
            prior_overlap: false,
            _phantom: PhantomData,
        }
    }
}


/// An iterator over the circular linked list `LlistNode`s, excluding the 'head'.
///
/// This `struct` is created by `LlistNode<T>::iter_mut(self)`. See its documentation for more.
#[derive(Debug, Clone, Copy)]
#[must_use = "iterators are lazy and do nothing unless consumed"]
pub struct IterMut<'llist, T: 'llist> {
    sentinel: NonNull<LlistNode<T>>,
    next_forward: NonNull<LlistNode<T>>,
    next_backward: NonNull<LlistNode<T>>,
    prior_overlap: bool,
    _phantom: PhantomData<&'llist ()>,
}

impl<'llist, T> Iterator for IterMut<'llist, T> {
    type Item = Pin<&'llist mut LlistNode<T>>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.prior_overlap || self.next_forward == self.sentinel {
            None
        } else if self.next_forward == self.next_backward {
            self.prior_overlap = true;
            Some(unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias
                Pin::new_unchecked(self.next_forward.as_mut())
            })
        } else {
            let mut next_forward = unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias,
                // implmentation guarantees that mutable references do not internally alias
                Pin::new_unchecked(self.next_forward.as_mut())
            };
            // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias
            self.next_forward = unsafe { next_forward.as_mut().next_mut().get_unchecked_mut() }.into();
            Some(next_forward)
        }
    }
}

impl<'llist, T> DoubleEndedIterator for IterMut<'llist, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        if self.prior_overlap || self.next_backward == self.sentinel {
            None
        } else if self.next_forward == self.next_backward {
            self.prior_overlap = true;
            Some(unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias
                Pin::new_unchecked(self.next_backward.as_mut())
            })
        } else {
            let mut next_backward = unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias,
                // implmentation guarantees that mutable references do not internally alias
                Pin::new_unchecked(self.next_backward.as_mut())
            };
            // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias
            self.next_backward = unsafe { next_backward.as_mut().prev_mut().get_unchecked_mut() }.into();
            Some(next_backward)
        }
    }
}
