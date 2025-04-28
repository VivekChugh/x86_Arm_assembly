section .data
    msg1 db "Value stored in memory: " ; Removed null terminator
    len1 equ $ - msg1
    msg2 db 0xA, "Value retrieved from memory: " ; Removed null terminator
    len2 equ $ - msg2
    newline db 0xA

section .bss
    value resb 1    ; Reserve 1 byte for storing our value
    stored_num resb 1  ; Reserve 1 byte for displaying the stored number

section .text
    global _start

_start:
    ; Store value 5 in memory
    mov al, 5       ; Value to store
    add al, '0'     ; Convert to ASCII
    mov [value], al ; Store in memory location 'value'

    ; Print first message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Print stored value
    mov eax, 4
    mov ebx, 1
    mov ecx, value
    mov edx, 1
    int 0x80

    ; Print second message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; Retrieve and store value in another location
    mov al, [value]     ; Get value from memory
    mov [stored_num], al ; Store in another location

    ; Print retrieved value
    mov eax, 4
    mov ebx, 1
    mov ecx, stored_num
    mov edx, 1
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80