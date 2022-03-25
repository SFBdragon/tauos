OUTPUT_FORMAT(elf64-x86-64)
ENTRY(_start)

SECTIONS {
    /* 
     *  Higher half kernel using code-model 'kernel' (see Sys V ABI)
     *  Lower bound address: 0xffffffff80000000 or 0o177777_777_776_000_000_0000
     *  Upper bound address: 0xffffffffff000000 or 0o177777_777_777_770_000_0000
     */

    . = 0xffffffff80000000;
    . += 0x10000;

	.text ALIGN(0x1000) : { *(.text .text.*); }
	.rodata ALIGN(0x1000) : { *(.rodata .rodata.*); }
	.data ALIGN(0x1000) : { *(.data .data.*); }
	.bss ALIGN(0x1000) : { *(.bss .bss.*); }

    /DISCARD/ : {
		*(.eh_frame .note.GNU-stack)
	}
}