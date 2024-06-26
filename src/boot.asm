ORG 0x7C00
BITS 16

%define ENDL 0x0D, 0x0A

;
; Prints a string to the screen.
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb                ; loads next character in al from ds:si
    or al, al
    jz .done
    ; jmp .loop

    mov ah, 0x0e         ; teletype function of BIOS
    int 0x10             ; BIOS video interrupt

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:
    ; setup data segments
    xor ax, ax           ; zero out ax
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00       ; stack grows downwards from where we are loaded in memory

    ; print message
    mov si, msg_hello_world
    call puts

    hlt

.halt:
    jmp .halt

msg_hello_world: db 'Hello World!', ENDL, 0

; Padding to make the boot sector 512 bytes
times 510-($-$$) db 0
dw 0AA55h

