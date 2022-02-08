use core::{slice::SliceIndex, pin::Pin};


pub trait PinSliceUtils<T> {
    fn get_pin<'a, I: SliceIndex<Self>>(self: Pin<&'a Self>, index: I) -> Option<Pin<&'a I::Output>>;
    unsafe fn get_pin_unchecked<'a, I: SliceIndex<Self>>(self: Pin<&'a Self>, index: I) -> Pin<&'a I::Output>;
    fn get_pin_mut<'a, I: SliceIndex<Self>>(self: Pin<&'a mut Self>, index: I) -> Option<Pin<&'a mut I::Output>>;
    unsafe fn get_pin_unchecked_mut<'a, I: SliceIndex<Self>>(self: Pin<&'a mut Self>, index: I) -> Pin<&'a mut I::Output>;
}

impl<T> PinSliceUtils<T> for [T] {
    fn get_pin<'a, I: SliceIndex<Self>>(self: Pin<&'a Self>, index: I) -> Option<Pin<&'a I::Output>> {
        self.get_ref().get(index).map(|output| unsafe {
            // SAFETY: output's pinning guarantee is upheld through self's pin
            Pin::new_unchecked(output) 
        })
    }
    unsafe fn get_pin_unchecked<'a, I: SliceIndex<Self>>(self: Pin<&'a Self>, index: I) -> Pin<&'a I::Output> {
        // SAFETY: output pinning guarantee is upheld through self's pin
        Pin::new_unchecked(self.get_ref().get_unchecked(index))
    }
    fn get_pin_mut<'a, I: SliceIndex<Self>>(self: Pin<&'a mut Self>, index: I) -> Option<Pin<&'a mut I::Output>> {
        // SAFETY: slice does not implement have a malicious Deref/DerefMut impl, the value is otherwise not moved
        unsafe { self.get_unchecked_mut() }.get_mut(index).map(|output| unsafe {
            // SAFETY: output's pinning guarantee is upheld through self's pin
            Pin::new_unchecked(output) 
        })
    }
    unsafe fn get_pin_unchecked_mut<'a, I: SliceIndex<Self>>(self: Pin<&'a mut Self>, index: I) -> Pin<&'a mut I::Output> {
        // SAFETY: output pinning guarantee is upheld through self's pin
        Pin::new_unchecked(
            // SAFETY: slice does not implement have a malicious Deref/DerefMut impl, the value is otherwise not moved
            self.get_unchecked_mut().get_unchecked_mut(index)
        )
    }
}

pub fn iter_pin<T>(slice: Pin<&[T]>) -> impl Iterator<Item = Pin<&T>> {
    // SAFETY: output pinning guarantee is upheld through self's pin
    // SAFETY: slice does not implement have a malicious Deref/DerefMut impl, the value is otherwise not moved
    slice.get_ref().iter().map(|r| unsafe { Pin::new_unchecked(r) })
}

pub fn iter_pin_mut<T>(slice: Pin<&mut [T]>) -> impl Iterator<Item = Pin<&mut T>> {
    // SAFETY: output pinning guarantee is upheld through self's pin
    // SAFETY: slice does not implement have a malicious Deref/DerefMut impl, the value is otherwise not moved
    unsafe { slice.get_unchecked_mut() }.iter_mut().map(|r| unsafe { Pin::new_unchecked(r) })
}