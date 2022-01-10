use core::{mem::MaybeUninit, ptr::NonNull, cell::Cell, marker::PhantomData};


/// Describes a linked list node.
/// 
/// WARNING: Nodes can both be self-referencial and/or depend on the location of other nodes.
/// Do not move nodes after initialization.
/// 
/// The linked list is:
///  * **intrusive** to minimize indirection
///  * **circular** to minimize branches
///  * **uses the concept of a 'head' node** which is homogenous, but isn't iterated over
///  * **implicitly non-zero in length** by virtue of the lack of a heterogenous component
///  * **doubly linked** to allow bidirectional traversal and single ref removal
///  * **fairly unsafe** so handle with care
/// 
/// Notes: Nodes remove themselves from the list when they are dropped. This has the side
/// effect of upsetting dropck in certain use cases, such as trying to move a non-copy 
/// value out of data. It is recommended to use `mem::replace()` to get around this.
#[derive(Debug)]
pub struct LlistNode<T> {
    pub next: Cell<NonNull<LlistNode<T>>>,
    pub prev: Cell<NonNull<LlistNode<T>>>,
    pub data: T,
}

impl<T> Drop for LlistNode<T> {
    fn drop(&mut self) {
        // assume a circular list, which always has an element that isn't removed
        // in the case that this is the last element, this is still safe, as the list is now 'gone'
        unsafe { // Safety: next and prev are both initialized and of the same linked list
            self.prev.get().as_ref().next.set(self.next.get());
            self.next.get().as_mut().prev.set(self.prev.get());
        }
    }
}

impl<T> LlistNode<T> {
    /// Create a new independent node in place.
    /// 
    /// Note that this will not call `data`'s drop code. 
    /// It is your responsibility to make sure `node`'s `data` gets dropped if necessary.
    #[inline]
    pub const fn new_llist(node: &'_ mut MaybeUninit<Self>, data: T) -> &'_ mut Self {
        // SAFETY: node is a valid reference, thus the resulting pointer is valid and dereferencable
        let node_ptr = unsafe { NonNull::new_unchecked(node as *mut _ as *mut Self) };

        let initd_node = node.write(Self {
            prev: Cell::new(node_ptr),
            next: Cell::new(node_ptr),
            data,
        });

        initd_node
    }

    /// Create a new node as a member of an existing linked list in place of `node`.
    /// 
    /// `prev` and `next` should belong to the same linked list, 
    /// as not doing do may cause complex and unexpected linkages.
    /// 
    /// Note that this will not call `data`'s drop code. 
    /// It is your responsibility to make sure `data` gets dropped if necessary.
    /// # Safety:
    /// * `next` and `prev` must be dereferencable and initialized
    #[inline]
    pub unsafe fn new(node: &'_ mut MaybeUninit<Self>, prev: NonNull<Self>, next: NonNull<Self>, data: T)
    -> &'_ mut Self {
        let initd_node = node.write(Self { 
            prev: Cell::new(prev),
            next: Cell::new(next),
            data,
        });

        (*next.as_ptr()).prev.set(initd_node.into());
        (*prev.as_ptr()).next.set(initd_node.into());

        initd_node
    }

    /// Remove `node` from its linked list.
    #[inline]
    pub fn remove(node: NonNull<LlistNode<T>>) {
        unsafe {
            core::ptr::drop_in_place(node.as_ptr());
        }
    }


    /// Removes a chain of nodes from `start` to `end` inclusive from it's current list and inserts the
    /// chain between `prev` and `next`. Can be used to move a chain within a single list.
    /// 
    /// # Arguments
    /// 
    /// * `start` and `end` can be identical (relink 1 node).
    /// * `prev` and `next` can be identical (relink around a 'head' - `prev`/`next`).
    /// * All 4 arguments can be identical (orphans a single node as its own linked list).
    /// 
    /// While `start`/`end` and `prev`/`next` should belong to the same lists respectively, this is not required.
    /// Not doing so is implementation defined, and may create complex or nonsensical links.
    /// 
    /// # Safety:
    /// 
    /// * `start` and `end` must be initialized
    /// * `prev` and `next` must be initialized
    pub unsafe fn relink(start: NonNull<Self>, end: NonNull<Self>, prev: NonNull<Self>, next: NonNull<Self>) {
        // link up old list
        start.as_ref().prev.get().as_mut().next.set(end.as_ref().next.get());
        end.as_ref().next.get().as_mut().prev.set(start.as_ref().prev.get());

        // link up new list
        start.as_ref().prev.set(prev);
        end.as_ref().next.set(next);
        prev.as_ref().next.set(start);
        next.as_ref().prev.set(end);
    }

    pub fn iter<'llist>(&mut self) -> Iter<'llist, T> {
        Iter::new(self.into())
    }
}


/// An iterator over the circular linked list `LlistNode`s, excluding the 'head'.
///
/// This `struct` is created by [`LinkedList::iter()`]. See its
/// documentation for more.
#[derive(Debug, Clone, Copy)]
#[must_use = "iterators are lazy and do nothing unless consumed"]
pub struct Iter<'llist, T: 'llist> {
    sentinel: NonNull<LlistNode<T>>,
    next_forward: NonNull<LlistNode<T>>,
    next_backward: NonNull<LlistNode<T>>,
    prior_overlap: bool,
    _phantom: PhantomData<&'llist ()>,
}

impl<'llist, T> Iterator for Iter<'llist, T> {
    type Item = &'llist mut LlistNode<T>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.prior_overlap || self.next_forward == self.sentinel {
            None
        } else if self.next_forward == self.next_backward {
            self.prior_overlap = true;
            Some(unsafe { self.next_forward.as_mut() })
        } else {
            let next_forward = unsafe { self.next_forward.as_mut() };
            self.next_forward = unsafe { self.next_forward.as_ref() }.next.get();
            Some(next_forward)
        }
    }
}

impl<'llist, T> DoubleEndedIterator for Iter<'llist, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        if self.prior_overlap || self.next_backward == self.sentinel {
            None
        } else if self.next_forward == self.next_backward {
            self.prior_overlap = true;
            Some(unsafe { self.next_backward.as_mut() })
        } else {
            let next_backward = unsafe { self.next_backward.as_mut() };
            self.next_backward = unsafe { self.next_backward.as_ref() }.prev.get();
            Some(next_backward)
        }
    }
}

impl<'llist, T> Iter<'llist, T> {
    fn new(sentinel: NonNull<LlistNode<T>>) -> Self {
        Iter {
            sentinel,
            next_backward: unsafe { sentinel.as_ref() }.prev.get(),
            next_forward: unsafe { sentinel.as_ref() }.next.get(),
            prior_overlap: false,
            _phantom: PhantomData,
        }
    }
}
