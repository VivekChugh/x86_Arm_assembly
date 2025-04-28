section .data
    num1 dw 10      ; First number
    num2 dw 20      ; Second number
    msg1 db "The maximum number is: "
    len1 equ $ - msg1
    max_num dw 0    ; To store the maximum number
    newline db "", 10 ; Newline character

section .bss
    num_str resb 6  ; Buffer to store number as string (up to 5 digits + null)

section .text
    global _start

_start:
    ; Load the two numbers into registers
    mov ax, [num1]
    mov bx, [num2]

    ; Compare the numbers
    cmp ax, bx
    jge num1_is_max ; Jump if ax >= bx

    ; If bx > ax, bx is max
    mov [max_num], bx
    jmp print_max

num1_is_max:
    ; If ax >= bx, ax is max
    mov [max_num], ax

print_max:
    ; Print the message
    mov eax, 4          ; system call number (sys_write)
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, msg1       ; message to write
    mov edx, len1       ; message length
    int 0x80            ; invoke kernel

    ; Convert the maximum number to string and print it
    mov ax, [max_num]
    call _printRAX      ; Call function to print AX (max number)

    ; Print a newline
    mov eax, 4          ; system call number (sys_write)
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, newline    ; message to write
    mov edx, 1          ; message length
    int 0x80            ; invoke kernel

    ; Exit program
    mov eax, 1          ; system call number (sys_exit)
    xor ebx, ebx        ; exit code 0
    int 0x80

; Function to print the value in AX register (unsigned short)
_printRAX:
    mov edi, num_str + 4 ; Point to the end of the buffer (5th byte)
    mov byte [edi+1], 0  ; Null terminate the string
    mov cx, 10           ; Divisor

.loop:
    xor dx, dx           ; Clear dx for division
    div cx               ; ax = ax / 10, dx = ax % 10
    add dl, '0'          ; Convert remainder to ASCII digit
    mov [edi], dl        ; Store digit in buffer
    dec edi              ; Move to previous byte in buffer
    test ax, ax          ; Is quotient zero?
    jnz .loop            ; If not zero, loop again

    ; Now edi points to the first digit
    inc edi              ; Move to the first digit's position

    ; Print the number string
    mov eax, 4           ; system call number (sys_write)
    mov ebx, 1           ; file descriptor 1 (stdout)
    mov ecx, edi         ; address of string to write
    mov edx, num_str + 5 ; Calculate length: (end_buffer + 1) - start_of_digits
    sub edx, edi
    int 0x80             ; invoke kernel
    ret
