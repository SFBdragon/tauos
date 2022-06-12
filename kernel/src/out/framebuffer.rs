

pub const RGBA: [usize; 4] = [0, 1, 2, 3];
pub const BGRA: [usize; 4] = [2, 1, 0, 3];
pub const ARGB: [usize; 4] = [3, 0, 1, 2];
pub const ABGR: [usize; 4] = [3, 2, 1, 0];

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PixelFormat {
    RGBA,
    BGRA,
    ARGB,
    ABGR,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Color {
    pub red: u8,
    pub green: u8,
    pub blue: u8,
    pub alpha: u8,
}
impl Color {
    pub const WHITE: Self = Self::new(255, 255, 255, 255);
    pub const BLACK: Self = Self::new(0, 0, 0, 0);

    pub const fn new(red: u8, green: u8, blue: u8, alpha: u8) -> Self {
        Self { red, green, blue, alpha }
    }
}

fn color_to_pixel(color: Color, format: PixelFormat) -> [u8; 4] {
    match format {
        PixelFormat::RGBA => [color.red, color.green, color.blue, color.alpha],
        PixelFormat::BGRA => [color.blue, color.green, color.red, color.alpha],
        PixelFormat::ARGB => [color.alpha, color.red, color.green, color.blue],
        PixelFormat::ABGR => [color.alpha, color.blue, color.green, color.red],
    }
}

pub struct FrameBuffer {
    /// Frame buffer pointer.
    pub buffer: *mut [u8],
    /// Horizontal resolution in pixels.
    pub width: usize,
    /// Vertical resolution in pixels.
    pub height: usize,
    /// Scanline width in bytes.
    pub stride: usize,
    /// Internal pixel format.
    pub format: PixelFormat,
}

impl FrameBuffer {
    pub const unsafe fn new(base: *mut u8, width: usize, height: usize, stride: usize, format: PixelFormat) -> Self {
        Self { buffer: core::ptr::slice_from_raw_parts_mut(base, stride * height), width, height, stride, format }
    }


    pub unsafe fn blt(&mut self, src: *const [u8], width: usize, height: usize, stride: usize, dst_x: usize, dst_y: usize) {
        // todo fixme
        for row in 0..height {
            for col in 0..width {
                let src_ptr = src.get_unchecked(col * 4 + row * stride);
                let dst_ptr = self.buffer.get_unchecked_mut((dst_x + col) * 4 + (dst_y + row) * self.stride);
                dst_ptr.cast::<[u8; 4]>().write(src_ptr.cast::<[u8; 4]>().read());
            }
        }
    }
    pub unsafe fn internal_blt(&mut self, src_x: usize, src_y: usize, width: usize, height: usize, dst_x: usize, dst_y: usize) {
        // todo fixme for left/right/top/bottom cases
        for row in 0..height {
            for col in 0..width {
                let src_ptr = self.buffer.get_unchecked_mut((src_x + col) * 4 + (src_y + row) * self.stride);
                let dst_ptr = self.buffer.get_unchecked_mut((dst_x + col) * 4 + (dst_y + row) * self.stride);
                dst_ptr.cast::<[u8; 4]>().write(src_ptr.cast::<[u8; 4]>().read());
            }
        }
    }

    /// ### Arguments:
    /// * `offset` in bits from `src` to begin copy.
    /// * `width` in bits of source bitmap; bits per row.
    /// * `height` in rows.
    /// * `stride` in bits of source bitmap; bits between rows.
    /// * `dst_x` and `dst_y` the coordinates at which to write the bitmap to the framebuffer.
    pub unsafe fn write_bitmap(&mut self, src: *const [u8], offset: usize, width: usize, height: usize, stride: usize,
    dst_x: usize, dst_y: usize, dst_zero_color: Color, dst_one_color: Color) {
        assert!(src.len() * 8 >= offset + stride * height - (stride - width));
        assert!(dst_x + (width / 8) <= self.width);
        assert!(dst_y + height <= self.height);
        
        let zero_pixel = color_to_pixel(dst_zero_color, self.format);
        let one_pixel = color_to_pixel(dst_one_color, self.format);

        for row in 0..height {
            //let mut byte = *src.get_unchecked(offset / 8 + row * stride);
            for col in 0..width {
                let bit_offset = col + offset;
                //if bit_offset % 8 == 0 { byte = *src.get_unchecked(bit_offset / 8 + row * stride); }
                let pixel_ptr = self.buffer.get_unchecked_mut((dst_x + col) * 4 + (dst_y + row) * self.stride);
                if *src.get_unchecked((bit_offset + row * stride) / 8) & 1 << (7 - bit_offset % 8) != 0 {
                    pixel_ptr.cast::<[u8; 4]>().write(one_pixel);
                } else {
                    pixel_ptr.cast::<[u8; 4]>().write(zero_pixel);
                }
            }
        }
    }

    pub unsafe fn fill_rect(&mut self, x: usize, y: usize, width: usize, height: usize, color: Color) {
        assert!(x + width <= self.width);
        assert!(y + height <= self.height);

        let pixel = color_to_pixel(color, self.format);

        for row in y..(y + height) {
            for col in 0..width {
                self.buffer.get_unchecked_mut((x + col) * 4 + self.stride * row).cast::<[u8; 4]>().write(pixel);
            }
        }
    }
}



/* 
// --------------- PIXEL FORMAT CONVERSIONS ---------------- //


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
} */
