// kernel.c - Second stage bootloader

void kernel_main() {
    // Early debug output
    const char *debug_msg = "Kernel loaded successfully!";
    char *vidptr = (char*)0xb8000;  // Video memory address
    unsigned int i = 0;

    // Print debug message to the screen
    while (debug_msg[i] != '\0') {
        vidptr[i * 2] = debug_msg[i];        // Character
        vidptr[i * 2 + 1] = 0x07;            // Attribute-byte: white on black
        i++;
    }

    // Infinite loop to halt the CPU
    while (1) {
        // Halt CPU
        asm volatile ("hlt");
    }
}

