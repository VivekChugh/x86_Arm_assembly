section .data
    add_msg db "Addition: " ; Removed null terminator
    add_len equ $ - add_msg
    sub_msg db 0xA, "Subtraction: " ; Removed null terminator
    sub_len equ $ - sub_msg
    mul_msg db 0xA, "Multiplication: " ; Removed null terminator
    mul_len equ $ - mul_msg
    div_msg db 0xA, "Division: " ; Removed null terminator
    div_len equ $ - div_msg
    newline db 0xA
    
section .bss
    result resb 1

section .text
    global _start

_start:
    ; Addition (5 + 3)
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, add_msg           ; message
    mov edx, add_len          ; length
    int 0x80

    mov eax, 5
    mov ebx, 3
    add eax, ebx              ; eax = 5 + 3
    add eax, '0'              ; Convert to ASCII
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Subtraction (7 - 2)
    mov eax, 4
    mov ebx, 1
    mov ecx, sub_msg
    mov edx, sub_len
    int 0x80

    mov eax, 7
    mov ebx, 2
    sub eax, ebx              ; eax = 7 - 2
    add eax, '0'              ; Convert to ASCII
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Multiplication (4 * 2)
    mov eax, 4
    mov ebx, 1
    mov ecx, mul_msg
    mov edx, mul_len
    int 0x80

    mov eax, 4
    mov ebx, 2
    mul ebx                   ; eax = 4 * 2
    add eax, '0'              ; Convert to ASCII
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Division (8 / 2)
    mov eax, 4
    mov ebx, 1
    mov ecx, div_msg
    mov edx, div_len
    int 0x80

    mov eax, 8
    mov ebx, 2
    mov edx, 0               ; Clear EDX for division
    div ebx                  ; eax = 8 / 2
    add eax, '0'            ; Convert to ASCII
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
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