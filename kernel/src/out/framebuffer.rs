// use core::marker::PhantomData;




pub const PIXEL_WIDTH: usize = 4;

/// Guarantees as per UEFI specification (EFI_PIXEL_BITMASK):
/// 
/// Bits in red, green, blue, and alpha masks must:
/// * not overlap bit positions
/// * represent the respective color intensities in an increasing fashion
///     * no bits in mask set = lowest intensity
///     * all bits in mask set = highest intensity
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FrameBufferBitmask {
    red: u32,
    green: u32,
    blue: u32,
    alpha: u32,
}

impl FrameBufferBitmask {
    pub const RGBA_COLOR_MASK: FrameBufferBitmask = FrameBufferBitmask {
        red: 0x000000ff,
        green: 0x0000ff00,
        blue: 0x00ff0000,
        alpha: 0xff000000,
    };
    
    pub const BGRA_COLOR_MASK: FrameBufferBitmask = FrameBufferBitmask {
        blue: 0x000000ff,
        green: 0x0000ff00,
        red: 0x00ff0000,
        alpha: 0xff000000,
    };
}



/* /// The possible pixel formats that may be used by a [`FrameBuffer`]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum BufferPixelFormat {
    /// 32-bit red-green-blue-alpha 8888 pixel, bytes ordered respectively.
    Rgba,
    /// 32-bit blue-green-red-alpha 8888 pixel, bytes ordered respectively.
    Bgra,
    /// 32-bit custom red, green, blue, alpha non-overlapping colour masks.
    Bitmask,
} */

/* impl From<uefi::proto::console::gop::PixelFormat> for BufferPixelFormat {
    fn from(format: uefi::proto::console::gop::PixelFormat) -> Self {
        match format {
            uefi::proto::console::gop::PixelFormat::Bgr => BufferPixelFormat::Bgra,
            uefi::proto::console::gop::PixelFormat::Rgb => BufferPixelFormat::Rgba,
            uefi::proto::console::gop::PixelFormat::Bitmask => BufferPixelFormat::Bitmask,
            uefi::proto::console::gop::PixelFormat::BltOnly => panic!("Cannot use BltOnly pixel format!"),
        }
    }
} */


/* #[derive(Debug)]
struct FrameBuffer<'a> {
    //base: *mut u8,
    //slice: &'a mut [u32], // TODO: fix and settle
    //mem: Option<alloc::boxed::Box<[u8]>>, // ?

    /// Horizontal resolution in pixels
    width: usize,
    /// Vertical resolution in pixels
    heigh: usize,
    /// Scanline width in pixels - equal to or larger than `width`
    stride: usize,

    format: BufferPixelFormat,
    bitmask: FrameBufferBitmask,
    _temp: PhantomData<&'a mut u8>
}

impl<'a> FrameBuffer<'a> {
    /// Create a [`FrameBuffer`] from the `base` pointer and current `ModeInfo` as per the UEFI specification
    /// as a GRAPHICS_OUTPUT_PROTOCOL raw frame buffer.
    pub fn from_uefi(base: *mut u8, info: uefi::proto::console::gop::ModeInfo) -> Self {
        FrameBuffer { 
            //slice: unsafe { core::mem::transmute(base) },
            //mem: None,
            width: info.resolution().0, 
            heigh: info.resolution().1, 
            stride: info.stride(), 
            format: info.pixel_format().into(),
            bitmask: match info.pixel_format().into() {
                BufferPixelFormat::Rgba => FrameBufferBitmask::RGBA_COLOR_MASK,
                BufferPixelFormat::Bgra => FrameBufferBitmask::BGRA_COLOR_MASK,
                BufferPixelFormat::Bitmask => FrameBufferBitmask {
                    red: info.pixel_bitmask().unwrap().red,
                    green: info.pixel_bitmask().unwrap().green,
                    blue: info.pixel_bitmask().unwrap().blue,
                    alpha: info.pixel_bitmask().unwrap().reserved,
                },
            },
            _temp: PhantomData,
        }
    }

    // TODO

    ///// Create a new [`FrameBuffer`] that can act as a double-/triple-buffer by matching
    ///// the source buffer's dimensions and pixel format. 
    //pub fn double_buffer(&self) -> Self { }

    //pub fn blt_entire(&self, other: &mut Self) { }

    //pub fn blt(&mut self, block: ) { }

    //pub fn write() {}
    //pub fn read() {}
} */




// --------------- PIXEL FORMAT CONVERSIONS ----------------


/// Convert pixel format bidirectionally between RGBA8888 and BGRA8888.
#[inline]
pub fn convert_rgba_bgra(pixels: &mut [[u8; 4]]) {
    for pixel in pixels {
        *pixel = [pixel[2], pixel[1], pixel[0], pixel[3]];
    }
}
pub fn rgba_to_bgra(pixels: &mut [u32]) {
    let pixels = unsafe {
        core::mem::transmute::<&mut [u32], &mut [[u8; 4]]>(pixels)
    };
    convert_rgba_bgra(pixels);
}
pub fn bgra_to_rgba(pixels: &mut [u32]) {
    let pixels = unsafe {
        core::mem::transmute::<&mut [u32], &mut [[u8; 4]]>(pixels)
    };
    convert_rgba_bgra(pixels);
}

macro_rules! mask_format_conversion {
    ($pixels_u32:expr, $from_mask:expr, $to_mask:expr) => {
        // amount to shift left to align the most significant bits of from_mask onto to_mask
        let red_shl =   $from_mask.red.leading_zeros() as isize   - $to_mask.red.leading_zeros() as isize;
        let green_shl = $from_mask.green.leading_zeros() as isize - $to_mask.red.leading_zeros() as isize;
        let blue_shl =  $from_mask.blue.leading_zeros() as isize  - $to_mask.red.leading_zeros() as isize;
        let alpha_shl = $from_mask.alpha.leading_zeros() as isize - $to_mask.red.leading_zeros() as isize;

        // mask with the bit width of the lowest resolution mask, aligned to from_mask's masks
        let red_mask =   $from_mask.red   & $to_mask.red   >> red_shl;
        let green_mask = $from_mask.green & $to_mask.green >> green_shl;
        let blue_mask =  $from_mask.blue  & $to_mask.blue  >> blue_shl;
        let alpha_mask = $from_mask.alpha & $to_mask.alpha >> red_shl;

        for pixel in $pixels_u32 {
            *pixel 
                = ((*pixel & red_mask)   << red_shl)
                | ((*pixel & green_mask) << green_shl)
                | ((*pixel & blue_mask)  << green_shl)
                | ((*pixel & alpha_mask) << alpha_shl);
        }
    };
}

pub fn rgba_to_mask(pixels: &mut [u32], mask: FrameBufferBitmask) {
    mask_format_conversion!(pixels, FrameBufferBitmask::RGBA_COLOR_MASK, mask);
}
pub fn mask_to_rgba(pixels: &mut [u32], mask: FrameBufferBitmask) {
    mask_format_conversion!(pixels, mask, FrameBufferBitmask::RGBA_COLOR_MASK);
}
pub fn bgra_to_mask(pixels: &mut [u32], mask: FrameBufferBitmask) {
    mask_format_conversion!(pixels, FrameBufferBitmask::BGRA_COLOR_MASK, mask);
}
pub fn mask_to_bgra(pixels: &mut [u32], mask: FrameBufferBitmask) {
    mask_format_conversion!(pixels, mask, FrameBufferBitmask::BGRA_COLOR_MASK);
}
pub fn mask_to_mask(pixels: &mut [u32], from_mask: FrameBufferBitmask, to_mask: FrameBufferBitmask) {
    mask_format_conversion!(pixels, from_mask, to_mask);
}
