BITS 16              ; We are in real mode, so use 16-bit code
ORG 0x7C00           ; The BIOS loads the bootloader at address 0x7C00

start:
    mov ah, 0x0E     ; BIOS teletype function
    mov al, 'B'      ; Print 'B' to indicate bootloader started
    int 0x10         ; Call BIOS interrupt to print character

    ; Set up the stack
    mov ax, 0x07C0   ; Base address of bootloader segment
    add ax, 0x0200   ; Adjust stack pointer to end of bootloader
    mov ss, ax
    mov sp, 0x7BFF   ; Stack grows downwards from 0x7C00

    ; Load the second stage bootloader (kernel.bin)
    mov bx, 0x0000    ; Segment where to load
    mov dh, 0x02      ; Number of sectors to read
    mov dl, 0x00      ; Drive number (0x00 = first floppy)
    mov ch, 0x00      ; Cylinder
    mov cl, 0x02      ; Sector (starting from 1)
    mov ah, 0x02      ; BIOS function: read sectors
    int 0x13          ; BIOS interrupt

    ; Check if the read operation succeeded
    jc read_error     ; Jump to read_error label if carry flag is set

    ; Print success message
    mov ah, 0x0E     ; BIOS teletype function
    mov al, 'K'      ; Print 'K' to indicate kernel loaded successfully
    int 0x10         ; Call BIOS interrupt to print character

    ; Jump to the second stage bootloader
    jmp 0x0000:0x0200

read_error:
    ; Print error message
    mov ah, 0x0E     ; BIOS teletype function
    mov al, 'E'      ; Print 'E' to indicate read error
    int 0x10         ; Call BIOS interrupt to print character

    ; Loop indefinitely
    jmp $

times 510-($-$$) db 0  ; Fill the rest of the 512-byte sector with 0
dw 0xAA55              ; Boot sector signature

