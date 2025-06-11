[org 0x7C00]
[bits 16]

CODE_SEG equ 0x08
DATA_SEG equ 0x10

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

    call print_version           
    call enter_protected_mode

.hang:
    jmp .hang

print_version:
    mov si, version_str
.print_char:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07                
    int 0x10
    jmp .print_char
.done:
    ret

version_str db "Carl Kernel version 0.0.1-dev build 100625.2027 NASM", 0

enter_protected_mode:
    cli
    lgdt [gdt_descriptor]        

    mov eax, cr0
    or eax, 1                    
    mov cr0, eax

    jmp CODE_SEG:init_pm         


[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000             

    mov si, string_pm
    call print_string_pm

    call read_key_pm

.pm_hang:
    cli
    hlt
    jmp .pm_hang

print_string_pm:
    pusha
    mov edi, 0xB8000
.next_char:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0F                
    stosw
    jmp .next_char
.done:
    popa
    ret

string_pm db "Carl has entered protected mode.", 0

read_key_pm:
.wait:
    in al, 0x64
    test al, 1
    jz .wait
    in al, 0x60
    ret

panic:
    pusha
    mov si, panic_msg
    call print_string_pm
.panic_hang:
    cli
    hlt
    jmp .panic_hang

panic_msg db "panic: critical failure", 0


gdt_start:
gdt_null:   dq 0x0000000000000000
gdt_code:   dq 0x00CF9A000000FFFF
gdt_data:   dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510 - ($ - $$) db 0
dw 0xAA55
