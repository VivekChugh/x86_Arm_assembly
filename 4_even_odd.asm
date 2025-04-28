section .data
    num dw 7                  ; The number to check (word size)
    even_msg db "Number is Even", 0xA
    even_len equ $ - even_msg
    odd_msg db "Number is Odd", 0xA
    odd_len equ $ - odd_msg

section .text
    global _start

_start:
    mov ax, [num]             ; Load the number into AX
    test ax, 1                ; Check the least significant bit
                              ; If LSB is 0, number is even
                              ; If LSB is 1, number is odd

    jz is_even                ; Jump to is_even if the zero flag is set (LSB is 0)

    ; Number is odd
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, odd_msg
    mov edx, odd_len
    int 0x80
    jmp exit_program          ; Jump to exit

is_even:
    ; Number is even
    mov eax, 4                ; sys_write
    mov ebx, 1                ; stdout
    mov ecx, even_msg
    mov edx, even_len
    int 0x80

exit_program:
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80