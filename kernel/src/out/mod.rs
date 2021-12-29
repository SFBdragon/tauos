
pub mod uart;
pub mod framebuffer;


// print! & println! implementations

#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($crate::out::__print(format_args!($($arg)*)));
}

#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ($crate::print!("\n{}", format_args!($($arg)*)));
}

#[doc(hidden)]
pub fn __print(args: core::fmt::Arguments) {
    use core::fmt::Write;

    // todo: fix for firmware
    uart::UART_COM1.0.lock().write_fmt(args).unwrap_or_else(|_| ());
    // todo: framebuffer output
}
