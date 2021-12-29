//! Module to create a safer representation of data access to x86 I/O ports.

use core::{marker::PhantomData, fmt};


/// # Safety:
/// Writing to random I/O ports can harm the system. 
/// Caller must ensure that the port is valid and available.
/// Caller must ensure not to write to reserved data.
pub unsafe fn outb(port: u16, data: u8) {
    asm!("out dx, al", in("dx") port, in("al") data, options(nomem, nostack, preserves_flags));
}
/// # Safety:
/// Caller must ensure that the port is valid.
pub unsafe fn inb(port: u16) -> u8 {
    let value: u8;
    asm!("in al, dx", out("al") value, in("dx") port, options(nomem, nostack, preserves_flags));
    value
}
/// # Safety:
/// Writing to random I/O ports can harm the system. 
/// Caller must ensure that the port is valid and available.
/// Caller must ensure not to write to reserved data.
pub unsafe fn outs(port: u16, data: u16) {
    asm!("out dx, ax", in("dx") port, in("ax") data, options(nomem, nostack, preserves_flags));
}
/// # Safety:
/// Caller must ensure that the port is valid.
pub unsafe fn ins(port: u16) -> u16 {
    let value: u16;
    asm!("in ax, dx", out("ax") value, in("dx") port, options(nomem, nostack, preserves_flags));
    value
}
/// # Safety:
/// Writing to random I/O ports can harm the system. 
/// Caller must ensure that the port is valid and available.
/// Caller must ensure not to write to reserved data.
pub unsafe fn outi(port: u16, data: u32) {
    asm!("out dx, eax", in("dx") port, in("eax") data, options(nomem, nostack, preserves_flags));
}
/// # Safety:
/// Caller must ensure that the port is valid.
pub unsafe fn ini(port: u16) -> u32 {
    let value: u32;
    asm!("in eax, dx", out("eax") value, in("dx") port, options(nomem, nostack, preserves_flags));
    value
}



pub trait PortData {
    /// Reads data from the I/O port into first returned value,
    /// masking out bits as per `mask` into second returned value.
    /// 
    /// # Safety: 
    /// 
    /// Writing to random I/O ports can harm the system. 
    /// Caller must ensure that the port is valid and available.
    /// Caller must ensure not to write to reserved data.
    /// 
    /// Caller may use a mask to help guarantee expected behaviour.
    unsafe fn port_read(port: u16, mask: Self) -> (Self, Self) where Self : Sized;
    /// Writes data to the I/O port, masking out bits from `data` per `mask` into returned value.
    /// 
    /// # Safety: 
    /// 
    /// Writing to random I/O ports can harm the system. 
    /// Caller must ensure that the port is valid and available.
    /// Caller must ensure not to write to reserved data.
    /// 
    /// Caller should use a mask to help guarantee protection of reserved data.
    unsafe fn port_write(port: u16, data: Self, mask: Self) -> Self where Self : Sized;
}

impl PortData for u8 {
    #[inline]
    unsafe fn port_read(port: u16, mask: Self) -> (Self, Self) {
        let value = inb(port);
        (value & mask, value & !mask)
    }

    #[inline]
    unsafe fn port_write(port: u16, data: Self, mask: Self) -> Self {
        outb(port, data & mask);
        data & !mask
    }
}
impl PortData for u16 {
    #[inline]
    unsafe fn port_read(port: u16, mask: Self) -> (Self, Self) {
        let value = ins(port);
        (value & mask, value & !mask)
    }

    #[inline]
    unsafe fn port_write(port: u16, data: Self, mask: Self) -> Self {
        outs(port, data & mask);
        data & !mask
    }
}
impl PortData for u32 {
    #[inline]
    unsafe fn port_read(port: u16, mask: Self) -> (Self, Self) {
        let value = ini(port);
        (value & mask, value & !mask)
    }

    #[inline]
    unsafe fn port_write(port: u16, data: Self, mask: Self) -> Self {
        outi(port, data & mask);
        data & !mask
    }
}

// marker traits
pub trait PortReadAccessTrait { }
pub trait PortWriteAccessTrait { }

// marker structs implementing marker traits
pub struct ReadOnlyPortAccess;
impl PortWriteAccessTrait for ReadOnlyPortAccess { }

pub struct WriteOnlyPortAccess;
impl PortWriteAccessTrait for WriteOnlyPortAccess { }

pub struct ReadWritePortAccess;
impl PortReadAccessTrait for ReadWritePortAccess { }
impl PortWriteAccessTrait for ReadWritePortAccess { }

/// A data width-generic I/O port
/// 
/// Use the marker or aliased types for read/write configuration:
/// * `Port<T>` = `IoPort<T, ReadWritePortAccess>`
/// * `ReadOnlyPort<T>` = `IoPort<T, ReadOnlyPortAccess>`
/// * `WriteOnlyPort<T>` = `IoPort<T, WriteOnlyPortAccess>`
pub struct IoPort<T, RW>
where T : Sized {
    port: u16,
    mask: T,
    phantom: PhantomData<(T, RW)>,
}

/// A read/write data width-generic I/O port
pub type Port<T> = IoPort<T, ReadWritePortAccess>;
/// A readonly data width-generic I/O port
pub type ReadOnlyPort<T> = IoPort<T, ReadOnlyPortAccess>;
/// A writeonly data width-generic I/O port
pub type WriteOnlyPort<T> = IoPort<T, WriteOnlyPortAccess>;

impl<T : Sized, RW> IoPort<T, RW> {
    /// Create a representation of an x86-64 I/O port.
    /// 
    /// # Safety:
    /// 
    /// While this function cannot cause undefined behaviour itself, the caller must guarantee that `port`
    /// is a valid I/O port with the correct permissions, access, and data size, allowing read accesses to be safe.
    /// 
    /// `mask` can be used to protect reserved bits, but cannot be used to guarantee valid writes
    /// for all I/O registers even if correctly configured, thus write access remains `unsafe` regardless.
    pub const unsafe fn new(port: u16, mask: T) -> Self {
        Self {
            port,
            mask,
            phantom: PhantomData
        }
    }
}

impl<T : PortData + Copy, RW : PortWriteAccessTrait> IoPort<T, RW> {
    /// Reads data from the I/O port into first returned value,
    /// masking out bits as per `mask` into second returned value.
    pub fn read(&mut self) -> (T, T) {
        unsafe {
            T::port_read(self.port, self.mask)
        }
    }
}
impl<T : PortData + Copy, RW : PortWriteAccessTrait> IoPort<T, RW> {
    /// Writes data to the I/O port, masking out bits from `data` per internal mask into returned value.
    /// 
    /// # Safety:
    /// 
    /// Even if the `IoPort` has been properly addressed and masked, this can still cause undefined behaviour for
    /// combinations of bits that are not seen to be valid by the receiving port.
    /// 
    /// Ensure the data being written complies to the port's specification.
    pub unsafe fn write(&mut self, data: T) -> T {
        T::port_write(self.port, data, self.mask)
    }
}

impl<T, RW> fmt::Debug for IoPort<T, RW> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("IoPort")
            .field("port", &self.port)
            .field("byte(s)", &core::mem::size_of::<T>())
            .finish()
    }
}

impl<T: Copy, RW> Clone for IoPort<T, RW> {
    fn clone(&self) -> Self {
        Self {
            port: self.port,
            mask: self.mask,
            phantom: PhantomData,
        }
    }
}

