OUTPUT_FORMAT(elf64-x86-64)
ENTRY(_start)

/* bootboot data pointer symbols */
mmio        = 0xfffffffff8000000;
fb          = 0xfffffffffc000000;
bootboot    = 0xffffffffffe00000;
environment = 0xffffffffffe01000;
initstack   = 16384;

PHDRS {
    load PT_LOAD;
}

SECTIONS {
    /* See memm/mod.rs for rationale. */
    . = 0xffffffffc0000000;
    . += 0x10000;

	.text : ALIGN(0x1000) { 
        *(.text .text.*);
        *(.rodata .rodata.*);
        *(.data .data.*);
    } : load

    .bss (NOLOAD) : ALIGN(0x1000) {
        *(.bss .bss.*);
    } : load

    /DISCARD/ : {
		*(.eh_frame .eh_frame.*);
        *(.eh_frame_hdr .eh_frame_hdr.*);
        *(.note.GNU-stack);
	}
}