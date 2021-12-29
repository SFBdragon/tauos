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
            self.prev.get().as_mut().next.set(self.next.get());
            self.next.get().as_mut().prev.set(self.prev.get());
        }
    }
}

impl<T> LlistNode<T> {
    /// Create a new invalid node.
    /// # Safety:
    /// Initialize using `init_llist` before use.
    #[inline]
    pub const unsafe fn new_llist_invalid(data: T) -> Self {
        Self {
            next: Cell::new(NonNull::dangling()),
            prev: Cell::new(NonNull::dangling()),
            data,
        }
    }
    /// Use to initialize nodes produced by `new_llist_invalid`.
    #[inline]
    pub fn init_llist(&mut self) {
        let ptr = self as *mut _;
        unsafe { // Safety: ptr is safe to deref because self is safe
            self.next.set(NonNull::new_unchecked(ptr));
            self.next.set(NonNull::new_unchecked(ptr));
        }
    }

    
    /// Create a new independent node in place.
    /// # Safety:
    /// `self.data` must *not* rely upon being dropped - it will be overwritten.
    #[inline]
    pub unsafe fn new_llist(node: &mut MaybeUninit<Self>, data: T) {
        *node = MaybeUninit::new(Self {
            prev: Cell::new(ptr),
            next: Cell::new(ptr),
            data,
        });
    }

    /// Create a new node as a member of an existing linked list in place of `ptr`.
    /// 
    /// `ptr`'s value is not expected to be initialized.
    /// # Safety:
    /// * `prev` and `next` must be initialized
    /// * `prev` and `next` must belong to the same linked list.
    #[inline]
    pub unsafe fn new(mut ptr: NonNull<Self>, prev: NonNull<Self>, next: NonNull<Self>, data: T) {
        *ptr.as_uninit_mut() = MaybeUninit::new(Self { 
            prev: Cell::new(prev.into()),
            next: Cell::new(next.into()),
            data,
        });

        next.as_ref().prev.set(ptr);
        prev.as_ref().next.set(ptr);
    }

    /// Remove `node` from its linked list.
    #[inline]
    pub fn remove(node: NonNull<Self>) {
        unsafe {
            core::ptr::drop_in_place(node.as_ptr());
        }
    }


    /// Removes a chain of nodes from `start` to `end` inclusive from it's current list and inserts the
    /// chain between `prev` and `next`. Can be used to move a chain within a single list.
    /// 
    /// # Arguments
    /// 
    /// * `start` and `end` can be identical (chain-to-move contains only 1 node).
    /// * `prev` and `next` can be identical (chain-to-move will be linked around a 'head' (`prev`/`next`)).
    /// * All 4 arguments can be identical (orphans a single node as its own linked list).
    /// 
    /// # Safety:
    /// 
    /// * `start` and `end` must be initialized
    /// * `start` and `end` must belong to the same linked list.
    /// * `prev` and `next` must be initialized
    /// * `prev` and `next` must belong to the same linked list.
    pub unsafe fn change_list(start: NonNull<Self>, end: NonNull<Self>, prev: NonNull<Self>, next: NonNull<Self>) {
        // link up old list
        start.as_ref().prev.get().as_mut().next.set(end.as_ref().next.get());
        end.as_ref().next.get().as_mut().prev.set(start.as_ref().prev.get());

        // link up new list
        start.as_ref().prev.set(prev);
        end.as_ref().next.set(next);
        prev.as_ref().next.set(start);
        next.as_ref().prev.set(end);
    }
}

pub struct LlistNodeIter<'llist, T> {
    forward: NonNull<LlistNode<T>>,
    backward: NonNull<LlistNode<T>>,
    _phantom: PhantomData<&'llist ()>,
}

impl<'llist, T: 'llist> Iterator for LlistNodeIter<'llist, T> {
    type Item = &'llist mut LlistNode<T>;

    fn next(&mut self) -> Option<Self::Item> {
        let mut next_forward = unsafe { self.forward.as_ref() }.next.get();
        if next_forward == self.backward {
            None
        } else {
            self.forward = next_forward;
            Some(unsafe { next_forward.as_mut() })
        }
    }
}

impl<'llist, T: 'llist> DoubleEndedIterator for LlistNodeIter<'llist, T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        let mut next_backward = unsafe { self.backward.as_ref() }.prev.get();
        if next_backward == self.forward {
            None
        } else {
            self.backward = next_backward;
            Some(unsafe { next_backward.as_mut() })
        }
    }
}

impl<'llist, T: 'llist> LlistNodeIter<'llist, T> {
    pub fn new(head: NonNull<LlistNode<T>>) -> Self {
        Self {
            forward: head,
            backward: head,
            _phantom: PhantomData,
        }
    }
}

