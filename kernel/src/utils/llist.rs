use core::{ptr::NonNull, cell::Cell};


/// Describes a linked list node.
/// 
/// The linked list is:
///  * **intrusive** to minimize indirection
///  * **circular** to minimize branches
///  * **uses the concept of a 'head' node** which is homogenous, but isn't iterated over
///  * **implicitly non-zero in length** by virtue of the lack of a heterogenous component
///  * **doubly linked** to allow bidirectional traversal and single ref removal
///  * **very unsafe** due to pointer usage, inter-referenciality, and self-referenciality
/// 
/// ### Safety:
/// `LlistNode`s are inherently unsafe due to the referencial dependency between nodes,
/// as well as the self-referencial configuration with linked lists of length 1. This requires
/// that `LlistNode`s are never moved manually, otherwise using the list becomes memory
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
    pub next: Cell<NonNull<LlistNode<T>>>,
    pub prev: Cell<NonNull<LlistNode<T>>>,
}

impl<T> LlistNode<T> {
    /// Create a new independent node in place.
    /// 
    /// Warning: This will not call `remove` on `node`, regardless of initialization. 
    /// It is your responsibility to make sure `node` gets `remove`d if necessary.
    /// Failing to do so when is not undefined behaviour or memory unsafe, but 
    /// may cause complex and unexpected linkages.
    /// 
    /// ### Safety:
    /// * `node` must be `ptr::write`-able.
    #[inline]
    pub fn new_llist(node: NonNull<Self>, data: T) {
        unsafe {
            node.as_ptr().write(Self {
                data,
                prev: Cell::new(node),
                next: Cell::new(node),
            });
        }
    }

    /// Create a new node as a member of an existing linked list in place of `node`.
    /// 
    /// `prev` and `next` may belong to different linked lists,
    /// doing do may however cause complex and unexpected linkages.
    /// 
    /// Warning: This will not call `remove` on `node`, regardless of initialization. 
    /// It is your responsibility to make sure `node` gets `remove`d if necessary.
    /// Failing to do so when is not undefined behaviour or memory unsafe, but 
    /// may cause complex and unexpected linkages.
    /// 
    /// ### Safety:
    /// * `node` must be `ptr::write`-able.
    /// * `prev` and `next` must be dereferencable and valid.
    pub unsafe fn new(node: NonNull<Self>, prev: NonNull<Self>, next: NonNull<Self>, data: T) {
        node.as_ptr().write(Self { 
            data,
            prev: Cell::new(prev),
            next: Cell::new(next),
        });

        (*next.as_ptr()).prev.set(node);
        (*prev.as_ptr()).next.set(node);
    }
    
    /// Move `self` into a new location, leaving `self` as an isolated node.
    /// ### Safety:
    /// * `dest` must be `ptr::write`-able.
    /// * `self` must be dereferencable and valid.
    pub unsafe fn mov(src: NonNull<Self>, dest: NonNull<Self>) {
        dest.as_ptr().write(src.as_ptr().read());

        (*src.as_ptr()).prev.set(src);
        (*src.as_ptr()).next.set(src);
    }

    /// Remove `self` from it's linked list, leaving `self` as an isolated node.
    /// If `self` is linked only to itself, this is effectively a no-op.
    /// ### Safety:
    /// * `self` must be dereferencable and valid.
    pub unsafe fn remove(node: NonNull<Self>) {
        let prev = (*node.as_ptr()).prev.get();
        let next = (*node.as_ptr()).next.get();
        (*prev.as_ptr()).next.set(next);
        (*next.as_ptr()).prev.set(prev);

        (*node.as_ptr()).prev.set(node);
        (*node.as_ptr()).next.set(node);
    }


    /// Removes a chain of nodes from `start` to `end` inclusive from it's current list and inserts the
    /// chain between `prev` and `next`. This can also be used to move a chain within a single list.
    /// 
    /// # Arguments
    /// * `start` and `end` can be identical (relink 1 node).
    /// * `prev` and `next` can be identical (relink around a 'head').
    /// * All 4 arguments can be identical (orphans a single node as its own linked list).
    /// 
    /// While `start`/`end` and `prev`/`next` should belong to the same lists respectively, this is not required.
    /// Not doing so may cause complex and unexpected linkages.
    /// ### Safety:
    /// * All arguments must be dereferencable and valid.
    pub unsafe fn relink(start: NonNull<Self>, end: NonNull<Self>, 
    prev: NonNull<Self>, next: NonNull<Self>) {
        // link up old list
        let start_prev = (*start.as_ptr()).prev.get();
        let end_next   = (*end  .as_ptr()).next.get();
        (*start_prev.as_ptr()).next.set(end_next);
        (*end_next  .as_ptr()).prev.set(start_prev);

        // link up new list
        (*(start.as_ptr())).prev.set(prev);
        (*(end  .as_ptr())).next.set(next);
        (*(prev .as_ptr())).next.set(start);
        (*(next .as_ptr())).prev.set(end);
    }


    /// Creates an iterator over the circular linked list, exclusive of
    /// the sentinel.
    /// ### Safety:
    /// `start`'s linked list must remain in a valid state during iteration.
    /// Modifying `LlistNode`s already returned by the iterator is okay.
    pub unsafe fn iter_mut(sentinel: NonNull<Self>) -> IterMut<T> {
        IterMut::new(
            (*sentinel.as_ptr()).next.get(), 
            (*sentinel.as_ptr()).prev.get()
        )
    }
}


/// An iterator over the circular linked list `LlistNode`s, excluding the 'head'.
///
/// This `struct` is created by `LlistNode::iter_mut`. See its documentation for more.
#[derive(Debug, Clone, Copy)]
#[must_use = "iterators are lazy and do nothing unless consumed"]
pub struct IterMut<T> {
    forward: NonNull<LlistNode<T>>,
    backward: NonNull<LlistNode<T>>,
    ongoing: bool,
}
impl<T> IterMut<T> {
    /// Create a new iterator over a linked list.
    /// ### Arguments:
    /// * In the typical case of full list iteration, `start.prev` = `end`.
    /// * `start` and `end` may be identical, in which case it will be yielded once.
    /// * `start` and `end` may belong to different linked lists, this will result 
    /// in an infinite iteration from both sides.
    /// ### Safety:
    /// `start`'s linked list must remain in a valid state during iteration.
    /// Modifying `LlistNode`s already returned by the iterator is okay.
    pub unsafe fn new(start: NonNull<LlistNode<T>>, end: NonNull<LlistNode<T>>) -> Self {
        Self {
            forward: start,
            backward: end,
            ongoing: true,
        }
    }
}

impl<T> Iterator for IterMut<T> {
    type Item = NonNull<LlistNode<T>>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.ongoing {
            let ret = self.forward;
            if self.forward == self.backward {
                self.ongoing = false;
            }
            self.forward = unsafe { (*self.forward.as_ptr()).next.get() };
            Some(ret)
        } else {
            None
        }
    }
}

impl<T> DoubleEndedIterator for IterMut<T> {
    fn next_back(&mut self) -> Option<Self::Item> {
        if self.ongoing {
            let ret = self.backward;
            if self.forward == self.backward {
                self.ongoing = false;
            }
            self.backward = unsafe { (*self.backward.as_ptr()).prev.get() };
            Some(ret)
        } else {
            None
        }
    }
}

