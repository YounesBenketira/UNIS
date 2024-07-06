[BITS 16]
[ORG 0x7C00]

start:
    ; Set up stack
    cli
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti

    ; Print "Hello World"
    mov si, hello_string
    call print_string

    ; Prepare for protected mode
    cli
    lgdt [gdt_descriptor]

    ; Enable A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Switch to protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to 32-bit code
    jmp 0x08:init_pm

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string
done:
    ret

[BITS 32]
init_pm:
    ; Set up segment registers
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Your 32-bit code here
    ; This is where you'd continue with 64-bit transition and kernel loading

    ; For now, just halt
    cli
    hlt

; Data
hello_string db 'Hello World', 0

; GDT
gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; Boot sector padding
times 510-($-$$) db 0
dw 0xAA55
