

#[repr(C, packed)]
#[derive(Debug, Clone, Copy)]
pub struct PsfFontHeader {
    /// Should equal `PSF_FONT_MAGIC`.
    pub magic: u32,
    /// Should be zero.
    pub version: u32,
    /// Size of header in bytes.
    pub header_size: u32,
    /// When zero, no UTF-8 table is present.
    pub flags: u32,
    /// Number of glyphs.
    pub glyph_count: u32,
    /// Bytes per glyph.
    pub glyph_size: u32,
    /// Glyph height in pixels/bits.
    pub height: u32,
    /// Glyph width in pixels/bits.
    pub width: u32,
}

pub struct PsfFont<'a> {
    pub header: PsfFontHeader,
    pub data: &'a [u8],
}

impl<'a> PsfFont<'a> {
    pub const PSF_FONT_MAGIC: u32 = 0x864ab572;

    pub const fn new(data: &'a [u8]) -> Self {
        const fn slice_to_u32(i: usize, data: &[u8]) -> u32 {
            let mut array = [0u8; 4];
            array[0] = data[i + 0];
            array[1] = data[i + 1];
            array[2] = data[i + 2];
            array[3] = data[i + 3];
            u32::from_le_bytes(array)
        }
        
        let magic = slice_to_u32(0, data);
        if magic != Self::PSF_FONT_MAGIC { panic!() }

        let header = PsfFontHeader {
            magic,
            version:     slice_to_u32(4, data),
            header_size: slice_to_u32(8, data),
            flags:       slice_to_u32(12, data),
            glyph_count: slice_to_u32(16, data),
            glyph_size:  slice_to_u32(20, data),
            height:      slice_to_u32(24, data),
            width:       slice_to_u32(28, data)
        };
        
        Self {
            header,
            data,
        }
    }

    pub fn get_glyph(&self, i: usize) -> Option<&'a [u8]> {
        let offset = self.header.header_size as usize + self.header.glyph_size as usize * i;
        self.data.get(offset..(offset + self.header.glyph_size as usize))
    }
}

pub const PSF_FONT: &[u8; 29728] = include_bytes!("../../../dev/font.psf");


