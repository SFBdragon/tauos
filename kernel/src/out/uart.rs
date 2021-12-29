//! Module for semi-safe chip agnostic UART interface.

// references & sources:
// https://en.wikibooks.org/wiki/Serial_Programming/8250_UART_Programming#Introduction
// https://www.lammertbies.nl/comm/info/serial-uart
// https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
// https://bochs.sourceforge.io/techspec/PORTS.LST


use core::fmt::Write;
use spin::{Lazy, Mutex};
use amd64::ports::{ReadOnlyPort, WriteOnlyPort, Port, PortData, outb, inb};


// standard x86_64 port-mapped UART devices
pub const COM1: u16 = 0x3f8;
pub const COM2: u16 = 0x2f8;
pub const COM3: u16 = 0x3e8;
pub const COM4: u16 = 0x2e8;

#[allow(dead_code)]
pub static UART_COM1: Lazy<(Mutex<UartPort>, UartChipVersion)> = Lazy::new(|| {
    let (port, ver) = unsafe { UartPort::new(COM1) }.expect("UART COM1 initialization failed!");
    (Mutex::new(port), ver)
});
#[allow(dead_code)]
pub static UART_COM2: Lazy<(Mutex<UartPort>, UartChipVersion)> = Lazy::new(|| {
    let (port, ver) = unsafe { UartPort::new(COM2) }.expect("UART COM2 initialization failed!");
    (Mutex::new(port), ver)
});
#[allow(dead_code)]
pub static UART_COM3: Lazy<(Mutex<UartPort>, UartChipVersion)> = Lazy::new(|| {
    let (port, ver) = unsafe { UartPort::new(COM3) }.expect("UART COM3 initialization failed!");
    (Mutex::new(port), ver)
});
#[allow(dead_code)]
pub static UART_COM4: Lazy<(Mutex<UartPort>, UartChipVersion)> = Lazy::new(|| {
    let (port, ver) = unsafe { UartPort::new(COM4) }.expect("UART COM4 initialization failed!");
    (Mutex::new(port), ver)
});


// register offsets
const THBR_OFFSET: u16 = 0;
const RBR_OFFSET: u16 = 0;
const DLL_OFFSET: u16 = 0;
const IER_OFFSET: u16 = 1;
const DLH_OFFSET: u16 = 1;
const IIR_OFFSET: u16 = 2;
const FCR_OFFSET: u16 = 2;
const LCR_OFFSET: u16 = 3;
const MCR_OFFSET: u16 = 4;
const LSR_OFFSET: u16 = 5;
const MSR_OFFSET: u16 = 6;
const SCR_OFFSET: u16 = 7;

/// UART chip versions that are differentiated by this implementation, which automatically 
/// protects against writing to reserved data on older chips, such that you can treat every chip
/// like a UART 16750 safely.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum UartChipVersion {
    V8250   = 8250,
    V16450  = 16450,
    V16550  = 16550,
    V16550A = 16551,
    V16750  = 16750,
}

/// Standard UART-supported baud rates.
#[allow(dead_code)]
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum BaudRate {
    BR50 = 50,
    BR110 = 110,
    BR220 = 220,
    BR300 = 300,
    BR600 = 600,
    BR1200 = 1200,
    BR2400 = 2400,
    BR4800 = 4800,
    BR9600 = 9600,
    BR19200 = 19200,
    BR38400 = 38400,
    BR57600 = 57600,
    BR115200 = 115200,
}


macro_rules! impl_u8_portdata_for_bitflags {
    ($name:ident) => {
        impl PortData for $name {
            unsafe fn port_read(port: u16, mask: Self) -> (Self, Self) where Self : Sized {
                let (val, msk) = u8::port_read(port, mask.bits);
                ($name::from_bits_unchecked(val), $name::from_bits_unchecked(msk))
            }
        
            unsafe fn port_write(port: u16, data: Self, mask: Self) -> Self where Self : Sized {
                $name::from_bits_unchecked(u8::port_write(port, data.bits, mask.bits))
            }
        }
    };
}

bitflags::bitflags! {
    /// Interrupt Enable Register (IER) flags.
    /// 
    /// This register allows interrupt condition configuration.
    #[repr(transparent)]
    pub struct IER: u8 {
        const RECEIVED_DATA_AVAILABLE_INTERRUPT            = 1 << 0;
        const TRANSMITTER_HOLDING_REGISTER_EMPTY_INTERRUPT = 1 << 1;
        const RECEIVER_LINE_STATUS_INTERRUPT               = 1 << 2;
        const MODEM_STATUS_INTERRUPT                       = 1 << 3;
        
        /// UART 16750 only
        const ENABLE_SLEEP_MODE                            = 1 << 4;
        /// UART 16750 only
        const ENABLE_LOW_POWER_MODE                        = 1 << 5;
    }
}
impl_u8_portdata_for_bitflags!(IER);


bitflags::bitflags! {
    /// Interrupt Identification Register (IIR) flags.
    /// 
    /// This register has the dual purpose of interrupt identification as well as UART chip feature detection.
    #[repr(transparent)]
    pub struct IIR: u8 {
        /// Bit one not set means an interrupt is pending
        const INTERRUPT_NOT_PENDING                        = 0b00000001;

        /// Use as a mask to subsequently derive the pending interrupt identity
        const PENDING_INTERRUPT_MASK                       = 0b00001110;

        /// Reset method: reading Receive Buffer Register
        /// 
        /// Interrupt priority: First
        /// 
        /// UART 16550 and later
        const TIME_OUT_INTERRUPT                           = 0b00001100;
        /// Reset method: reading Line Status Register
        /// 
        /// Interrupt priority: Second
        const LINE_STATUS_CHANGE                           = 0b00000110;
        /// Reset method: reading Receive Buffer Register
        const RECEIVED_DATA_AVAILABLE                      = 0b00000100;
        /// Reset method: reading Interrupt Identification Register or writing to Transmit Holding Buffer
        /// 
        /// Interrupt priority: Third
        const TRANSMITTER_HOLDING_REGISTER_EMPTY_INTERRUPT = 0b00000010;
        /// Reset method: reading Modem Status Register
        /// 
        /// Interrupt priority: Fourth
        const MODEM_STATUS_INTERRUPT                       = 0b00000000;

        /// UART 16750 only
        const FIFO_64_BYTES_ENABLED                        = 0b00100000;

        /// Use as a mask to subsequently derive the FIFO state
        const FIFO_STATE_MASK                              = 0b11000000;

        const FIFO_ENABLED                                 = 0b11000000;
        /// UART 16550 only
        const FIFO_NONFUNCTIONAL                           = 0b10000000;
        const NO_FIFO                                      = 0b00000000;
    }
}
impl_u8_portdata_for_bitflags!(IIR);

bitflags::bitflags! {
    /// FIFO Control Register (FCR) flags.
    /// 
    /// This register allows control and configuration of FIFO. 
    /// 
    /// This register is not available for pre-16550 UART chips.
    #[repr(transparent)]
    pub struct FCR: u8 {
        /// If not set, the rest of the FCR is effectively ignored.
        const ENABLE_FIFOS        = 1 << 0;
        const CLEAR_RECEIVE_FIFO  = 1 << 1;
        const CLEAR_TRANSMIT_FIFO = 1 << 2;

        // UART 16750 only
        const ENABLE_64_BYTE_FIFO = 1 << 5;

        /// Use as a mask to subsequently derive the RDAI interrupt trigger level
        const INTERRUPT_TRIGGER_LEVEL_MASK  = 0b11000000;
        /// The threshhold at which to trigger a Received Data Available interrupt, in 16 and 64 bit FIFO modes respectively.
        const INTERRUPT_TRIGGER_LEVEL_1_1   = 0b00000000;
        /// The threshhold at which to trigger a Received Data Available interrupt, in 16 and 64 bit FIFO modes respectively.
        const INTERRUPT_TRIGGER_LEVEL_4_16  = 0b01000000;
        /// The threshhold at which to trigger a Received Data Available interrupt, in 16 and 64 bit FIFO modes respectively.
        const INTERRUPT_TRIGGER_LEVEL_8_32  = 0b10000000;
        /// The threshhold at which to trigger a Received Data Available interrupt, in 16 and 64 bit FIFO modes respectively.
        const INTERRUPT_TRIGGER_LEVEL_14_56 = 0b11000000;
    }
}
impl_u8_portdata_for_bitflags!(FCR);

bitflags::bitflags! {
    /// Line Control Register (LCR) flags.
    /// 
    /// This register allows configuration of data transmission.
    /// 
    /// Flagging of DLAB is reserved. Use `UartPort::set_baud_rate( ... )` instead.
    #[repr(transparent)]
    pub struct LCR: u8 {
        /// Use as a mask to subsequently derive the data transmission word length
        const WORD_LENGTH_MASK    = 0b00000011;

        const WORD_LENGTH_5_BITS  = 0b00000000;
        const WORD_LENGTH_6_BITS  = 0b00000001;
        const WORD_LENGTH_7_BITS  = 0b00000010;
        const WORD_LENGTH_8_BITS  = 0b00000011;

        /// When enabled, the stop bit is either of length 2 bits or 1.5 (transmitted at 1/1.5 baud rate) in the case of 
        /// a data word legnth of 5 bits. Else a stop bit of length 1 bits.
        const STOP_BIT_LEN_2      = 1 << 2;

        const PARITY_ENABLED      = 1 << 3;

        const PARITY_TYPE_MASK    = 0b00111000;

        const NO_PARITY           = 0b00000000;
        const ODD_PARITY          = 0b00001000;
        const EVEN_PARITY         = 0b00011000;
        /// Parity bit is always 1.
        const MARK_PARITY         = 0b00101000;
        /// Parity bit is always 0.
        const SPACE_PARITY        = 0b00111000;

        const ENABLE_BREAK_SIGNAL = 1 << 6;

        /// Note: while this flag is included in `LineControlRegisterFlags`, this implmentation treats the bit as reserved
        /// for added API safety. Use `UartPort::set_baud_rate( ... )` instead.
        const DIVISOR_LATCH_ACCESS_BIT = 1 << 7;
    }
}
impl_u8_portdata_for_bitflags!(LCR);

bitflags::bitflags! {
    /// Modem Control Register (MCR) flags.
    /// 
    /// This register allows manipulation of "hardware" flow control from software.
    #[repr(transparent)]
    pub struct MCR: u8 {
        const DATA_TERMINAL_READY      = 1 << 0;
        const REQUEST_TO_SEND          = 1 << 1;
        /// Used to control the selection of a second oscillator for MIDI on few I/O cards.
        const AUXILLARY_OUTPUT_1       = 1 << 2;
        /// Required to enable interrupts on come chips.
        const AUXILLARY_OUTPUT_2       = 1 << 3;
        const LOOPBACK_ENABLED         = 1 << 4;

        /// UART 16750 only
        const AUTOFLOW_CONTROL_ENABLED = 1 << 5;
    }
}
impl_u8_portdata_for_bitflags!(MCR);

bitflags::bitflags! {
    /// Line Status Register (LSR) flags.
    /// 
    /// This register allows determination of communication status and errors, inluding
    /// receive and transmit buffer status.
    #[repr(transparent)]
    pub struct LSR: u8 {
        /// Indicates to read from Received Buffer Register. Remains set until FIFO is empty.
        const DATA_READY                         = 1 << 0;
        /// Shift buffer attempted to move next received value into Received Buffer Register
        /// while a value was already waiting to be read. When FIFO is enabled, this could also mean
        /// that FIFO buffer is full.
        /// 
        /// Indicates poor programming of received data handling.
        const OVERRUN_ERROR                      = 1 << 1;
        /// Parity check error. Potentially as a result of a misconfiguration (e.g. different baud rates).
        const PARITY_ERROR                       = 1 << 2;
        /// Stop bit is not 1. Potentially as a result of a misconfiguration (e.g. different baud rates).
        const FRAMING_ERROR                      = 1 << 3;
        /// Set after a period of receiving only zeroes. (Other LCR has ENABLE_BREAK_SIGNAL set)
        const BREAK_INTERRUPT                    = 1 << 4;

        /// Indicates THR is available, or that the transmission FIFO is available.
        const EMPTY_TRANSMITTER_HOLDING_REGISTER = 1 << 5;
        /// Indicates that both THR and the shift register which outputs the bits on the line is empty.
        const EMPTY_DATA_HOLDING_REGISTERS       = 1 << 6;

        /// Indicates the FIFO needs to be cleared due to an error in a value therein (parity, framing, etc.).
        const FIFO_RECEIVED_ERRONEOUS_DATA       = 1 << 7;
    }
}
impl_u8_portdata_for_bitflags!(LSR);

bitflags::bitflags! {
    /// Modem Status Register (MSR) flags.
    /// 
    /// This register allows determination of the status of the modem.
    /// Modem in this case can mean externel, or an internal interface to the computer.
    #[repr(transparent)]
    pub struct MSR: u8 {
        /// Indicates a change in the respective flag. Reset when MSR is read.
        const DELTA_CLEAR_TO_SEND         = 1 << 0;
        /// Indicates a change in the respective flag. Reset when MSR is read.
        const DELTA_DATA_SET_READY        = 1 << 1;
        /// Indicates a change in the `RING_INDICATOR` flag. Reset when MSR is read.
        const TRAILING_EDGE_RING_DETECTOR = 1 << 2;
        /// Indicates a change in the respective flag. Reset when MSR is read.
        const DELTA_CARRIER_DETECT        = 1 << 3;

        // `ModemControlRegisterFlags::REQUEST_TO_SEND` when loopback is enabled.
        const CLEAR_TO_SEND               = 1 << 4;
        // `ModemControlRegisterFlags::DATA_TERMINAL_READY` when loopback is enabled.
        const DATA_SET_READY              = 1 << 5;

        /// Generally can be ignored.
        /// Being set indicates 'ring voltage' - the phone is being rung, indicating someone is trying to call.
        /// 
        /// `ModemControlRegisterFlags::AUXILLARY_OUTPUT_1` when loopback is enabled.
        const RING_INDICATOR              = 1 << 6;
        /// Generally can be ignored.
        /// Remains set until "connection" with other modem is lost - the phone connection has been lost or closed.
        /// 
        /// `ModemControlRegisterFlags::AUXILLARY_OUTPUT_2` when loopback is enabled.
        const CARRIER_DETECT              = 1 << 7;
    }
}
impl_u8_portdata_for_bitflags!(MSR);





/// # Safety:
/// Caller must ensure `port` is a valid UART serial port.
unsafe fn identify_uart(port: u16) -> UartChipVersion {
    // https://en.wikibooks.org/wiki/Serial_Programming/8250_UART_Programming#Software_Identification_of_the_UART

    outb(port + FCR_OFFSET, 0xE7);
    let iir = inb(port + IIR_OFFSET);
    if iir & (1 << 6) != 0 {
        if iir & (1 << 7) != 0 {
            if iir & (1 << 5) != 0 {
                UartChipVersion::V16750
            } else {
                UartChipVersion::V16550A
            }
        } else {
            UartChipVersion::V16550
        }
    } else {
        outb(port + SCR_OFFSET, 0x2A);
        let scr = inb(port + SCR_OFFSET);
        if scr == 0x2A {
            UartChipVersion::V16450
        } else {
            UartChipVersion::V8250
        }
    }
}


// todo: UART read data and async UART impl?

/// A port-mapped UART chip.
/// 
/// Note that reads from and writes to reserved flags are masked out and returned seperately.
/// Checking these return values are not required, but may be helpful for ensuring your code 
/// is configuring the UART as expected.
pub struct UartPort {
    // port_addr: u16,

    /// Transmission Holding Buffer register
    pub thbr: WriteOnlyPort<u8>,
    /// Receiver Buffer register
    pub rbr: ReadOnlyPort<u8>,

    /// Divisor Latch Low byte
    dll: Port<u8>,

    /// Interrupt Enable Register
    pub ier: Port<IER>,

    /// Divisor Latch High byte
    dlh: Port<u8>,

    /// Interrupt Identification Register
    pub iir: ReadOnlyPort<IIR>,
    /// FIFO Control Register
    pub fcr: WriteOnlyPort<FCR>,

    /// Line Control Register
    pub lcr: Port<LCR>,
    /// Modem Control Register
    pub mcr: Port<MCR>,

    /// Line Status Register
    pub lsr: ReadOnlyPort<LSR>,
    /// Modem Status Register
    pub msr: ReadOnlyPort<MSR>,

    /// Scratch Register
    pub scr: Port<u8>,
}

impl UartPort {
    /// Initialize a serial port connection. Returns `Err` variant when UART loopback 
    /// read/write chip test fails.
    /// 
    /// # Safety: 
    /// Caller should guarantee `port_addr` is a valid serial port.
    pub unsafe fn new(port_addr: u16) -> Result<(Self, UartChipVersion), &'static str> {
        // get UART version
        let ver = identify_uart(port_addr);

        // configure port masks for version

        let ier_mask = if ver >= UartChipVersion::V16750 {
            IER::all()
        } else {
            IER::all() & !(IER::ENABLE_SLEEP_MODE | IER::ENABLE_LOW_POWER_MODE)
        };

        let iir_mask = if ver >= UartChipVersion::V16750 {
            IIR::all()
        } else {
            IIR::all() & !IIR::FIFO_64_BYTES_ENABLED
        };

        // https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter#UART_models
        // V16550's FIFO is broken, and cannot be safely used
        let fcr_mask = if ver >= UartChipVersion::V16550A {
            FCR::all()
        } else {
            FCR::empty()
        };

        let mcr_mask = if ver >= UartChipVersion::V16750 {
            MCR::all()
        } else {
            MCR::all() & !MCR::AUTOFLOW_CONTROL_ENABLED
        };

        let mut uart = UartPort { 
            // port_addr,

            thbr: WriteOnlyPort::new(port_addr + THBR_OFFSET, u8::MAX),
            rbr: ReadOnlyPort::new(port_addr + RBR_OFFSET, u8::MAX),
            dll: Port::new(port_addr + DLL_OFFSET, u8::MAX),

            ier: Port::new(port_addr + IER_OFFSET, ier_mask),
            dlh: Port::new(port_addr + DLH_OFFSET, u8::MAX),

            iir: ReadOnlyPort::new(port_addr + IIR_OFFSET, iir_mask),
            fcr: WriteOnlyPort::new(port_addr + FCR_OFFSET, fcr_mask),

            lcr: Port::new(port_addr + LCR_OFFSET, LCR::all()),
            mcr: Port::new(port_addr + MCR_OFFSET, mcr_mask),
            lsr: ReadOnlyPort::new(port_addr + LSR_OFFSET, LSR::all()),
            msr: ReadOnlyPort::new(port_addr + MSR_OFFSET, MSR::all()),
            scr: Port::new(port_addr + SCR_OFFSET, u8::MAX),
        };
        
        uart.reset_to_default();
        uart.test()?; // ensure UART chip is functional

        Ok((uart, ver))
    }

    pub fn reset_to_default(&mut self) {
        unsafe {
            self.set_baud_rate(BaudRate::BR57600);

            self.ier.write(IER::empty()); // Disable all interrupts
            self.lcr.write(LCR::WORD_LENGTH_8_BITS | LCR::NO_PARITY);
            self.mcr.write(MCR::DATA_TERMINAL_READY | MCR::REQUEST_TO_SEND | MCR::AUXILLARY_OUTPUT_1
                | MCR::AUXILLARY_OUTPUT_2);
            self.fcr.write(FCR::ENABLE_FIFOS | FCR::CLEAR_RECEIVE_FIFO | FCR::CLEAR_TRANSMIT_FIFO 
                | FCR::ENABLE_64_BYTE_FIFO | FCR::INTERRUPT_TRIGGER_LEVEL_1_1);
        }
    }

    fn test(&mut self) -> Result<(), &'static str> {
        unsafe {
            let mcr = self.mcr.read().0;
            self.mcr.write(mcr | MCR::LOOPBACK_ENABLED); // ensure loopback mode enable

            // test if byte sent equals byte received
            self.rbr.write(0x2B);
            if self.thbr.read().0 != 0x2B {
                return Result::Err("Port R/W test failed!");
            }

            self.mcr.write(mcr); // reset mcr to original value
            Result::Ok(())
        }
    }

    fn set_baud_rate(&mut self, baud_rate: BaudRate) {
        const UART_FREQUENCY: u32 = 115200;

        let devisor_latch_value: u16 = (UART_FREQUENCY / baud_rate as u32) as u16;
        unsafe {
            let lcr = self.lcr.read().0;
            self.lcr.write(lcr | LCR::DIVISOR_LATCH_ACCESS_BIT);

            self.dll.write((devisor_latch_value & 255) as u8);
            self.dlh.write((devisor_latch_value >> 8) as u8);

            self.lcr.write(lcr);
        }
    }

    pub fn write_byte(&mut self, byte: u8) {
        while !self.lsr.read().0.contains(LSR::EMPTY_TRANSMITTER_HOLDING_REGISTER) {
            core::hint::spin_loop();
        }
        
        unsafe {
            self.thbr.write(byte);
        }
    }

    #[allow(dead_code)]
    pub fn read_byte(&mut self) {
        while !self.lsr.read().0.contains(LSR::DATA_READY) {
            core::hint::spin_loop();
        }
        
        self.rbr.read();
    }
}


impl Write for UartPort {
    fn write_str(&mut self, s: &str) -> core::fmt::Result {
        for byte in s.bytes() {
            self.write_byte(byte);
        }

        core::fmt::Result::Ok(())
    }

    fn write_char(&mut self, c: char) -> core::fmt::Result {
        self.write_str(c.encode_utf8(&mut [0; 4]))
    }

    fn write_fmt(mut self: &mut Self, args: core::fmt::Arguments<'_>) -> core::fmt::Result {
        core::fmt::write(&mut self, args)
    }
}
