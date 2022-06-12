use core::fmt::Write;

use crate::out::framebuffer;
use crate::utils::psf;

pub struct Term1 {
    pub fb: framebuffer::FrameBuffer,
    pub font: psf::PsfFont<'static>,
    pub char_col: usize,
}

unsafe impl Send for Term1 {}
unsafe impl Sync for Term1 {}

pub static TERM1: spin::Mutex<Term1> = spin::Mutex::new(Term1 {
    fb: unsafe { framebuffer::FrameBuffer::new(core::ptr::null_mut(), 0, 0, 0, framebuffer::PixelFormat::ABGR) },
    font: psf::PsfFont::new(psf::PSF_FONT),
    char_col: 0
});

impl Term1 {
    pub fn new_line(&mut self) {
        unsafe {
            self.fb.internal_blt(0, self.font.header.height as usize, self.fb.width, self.fb.height - self.font.header.height as usize, 0, 0);
            self.fb.fill_rect(0, self.fb.height - self.font.header.height as usize, self.fb.width, self.font.header.height as usize, framebuffer::Color::BLACK);
            self.char_col = 0;
        }
    }

    pub fn write_char(&mut self, c: usize) {
        if c == b'\n' as usize {
            self.new_line();
            return;
        }

        // wrap if necessary
        if (self.char_col + 1) * self.font.header.width as usize > self.fb.width {
            self.new_line();
        }

        unsafe {
            self.fb.write_bitmap(
                self.font.get_glyph(c as usize).unwrap(), 0, 
                self.font.header.width as usize, 
                self.font.header.height as usize, 
                self.font.header.width as usize + 7 & !7, 
                self.char_col * self.font.header.width as usize,
                self.fb.height - self.font.header.height as usize,
                framebuffer::Color::BLACK, framebuffer::Color::WHITE
            );
        }

        self.char_col += 1;
    }
}

impl Write for Term1 {
    fn write_str(&mut self, s: &str) -> core::fmt::Result {
        for c in s.chars() {
            let c = c as usize;
            if c > self.font.header.glyph_count as usize {
                self.write_char(0);
            } else {
                self.write_char(c);
            }
        }
        core::fmt::Result::Ok(())
    }
}


