use core::{mem::MaybeUninit, ptr::NonNull, cell::Cell, marker::{PhantomData, PhantomPinned}, pin::Pin};


/// Describes a linked list node.
/// 
/// The linked list is:
///  * **intrusive** to minimize indirection
///  * **circular** to minimize branches
///  * **uses the concept of a 'head' node** which is homogenous, but isn't iterated over
///  * **implicitly non-zero in length** by virtue of the lack of a heterogenous component
///  * **doubly linked** to allow bidirectional traversal and single ref removal
///  * **fairly unsafe** due to self-referenciality
/// 
/// Notes: Nodes remove themselves from the list when they are dropped. This has the side
/// effect of upsetting dropck in certain use cases, such as trying to move a non-copy 
/// value out of data. It is recommended to use `mem::replace()` to get around this.
/// 
/// # Safety:
/// `LlistNode<T>`s are inherently unsafe due to the referencial dependency between nodes,
/// as well as the self-referencial configuration with linked lists of length 1.
/// This requires that `LlistNode<T>`s are never moved manually, otherwise using the list
/// becomes memory unsafe and may lead to undefined behaviour.
/// 
/// Dropping cannot be safe as long as mutable references exist to neighbouring nodes,
/// thus dropping is not allowed; use `LlistNode::remove(self)` instead.
#[derive(Debug)]
pub struct LlistNode<T> {
    pub data: T,
    next: Cell<NonNull<LlistNode<T>>>,
    prev: Cell<NonNull<LlistNode<T>>>,
    _pin: PhantomPinned,
}

impl<T> Drop for LlistNode<T> {
    fn drop(&mut self) {
        panic!("Dropping LlistNodes is not allowed, use LlistNode::remove(...) instead.");
    }
}

impl<T> LlistNode<T> {
    /// Get a reference to the next node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the next node. The memory the resulting reference
    /// references must not be read or written to through any other pointer.
    pub unsafe fn next(self: Pin<&'_ mut Self>) -> Pin<&'_ mut Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_mut`'s aliasing requirements are upheld, API enforeces the rest
        Pin::new_unchecked(self.as_ref().next.get().as_mut())
    }
    /// Get a reference to the previous node.
    /// # Safety:
    /// You must enfore Rust's aliasing rules for the previous node. The memory the resulting reference
    /// references must not be read or written to through any other pointer.
    pub unsafe fn prev(self: Pin<&mut Self>) -> Pin<&mut Self> {
        // SAFETY: LlistNode does not have malicious Deref/DerefMut impls
        // SAFETY: Caller guarantees that `as_mut`'s aliasing requirements are upheld, API enforeces the rest
        Pin::new_unchecked(self.as_ref().prev.get().as_mut())
    }



    /// Create a new independent node in place.
    /// 
    /// Note that this will not call `data`'s drop code. 
    /// It is your responsibility to make sure `node`'s `data` gets dropped if necessary.
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
    /// Note that this will not call `data`'s drop code. 
    /// It is your responsibility to make sure `data` gets dropped if necessary.
    #[inline]
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

    /// Remove `node` from its linked list and drop. To isolate the node, conider using `relink` instead.
    /// # Safety:
    /// Caller must not have a mutable reference to `node`'s previous or next node.
    #[inline]
    pub unsafe fn remove(self: Pin<&mut LlistNode<T>>) {
        // SAFETY: drop impl does not move node
        core::ptr::drop_in_place(self.get_unchecked_mut());

        // the linked list is circular, which always has an element that isn't removed
        // in the case that this is the last element, this is still safe
        unsafe {
            // SAFETY: next and prev are never set to invalid pointers or moved
            self.as_ref().prev.get().as_ref().next.set(self.as_ref().next.get());
            self.as_ref().next.get().as_ref().prev.set(self.as_ref().prev.get());
        }

        core::mem::forget(self)
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
    /// 
    /// # Safety:
    /// Caller must not have a mutable reference to `start`'s previous node or `end`'s next node.
    pub unsafe fn relink(start: &Self, end: &Self, prev: &Self, next: &Self) {
        // link up old list
        // SAFETY: Caller guarantees that start.prev.get() and end.next.get() does not alias existing mut refs
        start.prev.get().as_ref().next.set(end.next.get());
        end.next.get().as_ref().prev.set(start.prev.get());

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
    /// Caller must guarantee that their are no references to the linked lists' nodes besides `node`,
    /// and the references that will be returned from the iterator, until the iterator is dropped.
    pub unsafe fn iter_mut<'llist>(self: Pin<&mut Self>) -> IterMut<'llist, T> {
        IterMut {
            // SAFETY: Iter does not move sentinel
            sentinel: self.get_unchecked_mut().into(),
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
            let next_forward = unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias,
                // implmentation guarantees that mutable references do not internally alias
                Pin::new_unchecked(self.next_forward.as_mut())
            };
            self.next_forward = unsafe { next_forward.next().get_unchecked_mut() }.into();
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
            let next_backward = unsafe {
                // SAFETY: self.next_forward is never moved out of or into
                // SAFETY: iter_mut(...)'s caller guarantees nodes do not alias,
                // implmentation guarantees that mutable references do not internally alias
                Pin::new_unchecked(self.next_backward.as_mut())
            };
            self.next_backward = unsafe { next_backward.prev().get_unchecked_mut() }.into();
            Some(next_backward)
        }
    }
}

