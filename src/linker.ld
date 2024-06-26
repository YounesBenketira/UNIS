/* linker.ld - Linker script for the kernel */

OUTPUT_FORMAT(elf32-i386)
ENTRY(kernel_main)

SECTIONS {
    . = 0x200;
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}

