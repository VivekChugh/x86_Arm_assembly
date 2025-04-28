section .data
    msg db "Sum of array elements: "
    len equ $ - msg
    array db 1, 2, 3, 4, 5      ; Array of 5 numbers
    array_size equ 5            ; Size of array
    newline db 0xA

section .bss
    sum_str resb 11             ; Reserve space for sum string (up to 10 digits + null)

section .text
    global _start

; Procedure to convert number in EAX to string at sum_str
_number_to_string:
    mov edi, sum_str + 9      ; Point to end of buffer (leave space for null)
    mov byte [edi+1], 0       ; Null terminate
    mov ebx, 10               ; Divisor

convert_loop:
    xor edx, edx              ; Clear EDX for division
    div ebx                   ; EAX = EAX / 10, EDX = EAX % 10
    add dl, '0'               ; Convert remainder (digit) to ASCII
    mov [edi], dl             ; Store digit in buffer
    dec edi                   ; Move to previous byte in buffer
    test eax, eax             ; Check if quotient is zero
    jnz convert_loop          ; If not zero, continue loop
    
    inc edi                   ; Point back to the first digit
    ret

_start:
    ; Calculate sum
    xor eax, eax              ; Clear EAX (will hold sum)
    mov ecx, array_size       ; Counter for loop
    mov esi, 0                ; Array index

sum_loop:
    movzx ebx, byte [array + esi] ; Get current array element with zero extension
    add eax, ebx              ; Add to sum
    inc esi                   ; Move to next element
    loop sum_loop             ; Decrement ECX and continue if not zero

    ; Convert sum to string
    call _number_to_string    ; EAX has sum, EDI will point to start of string

    ; Print message
    mov eax, 4               ; sys_write
    mov ebx, 1               ; stdout
    mov ecx, msg             ; message
    mov edx, len             ; length
    int 0x80

    ; Print the sum string
    ; Calculate string length (simple way for now)
    mov esi, edi             ; Start of string
    mov ecx, sum_str + 10    ; End of buffer
    sub ecx, esi             ; Calculate length
    
    mov eax, 4
    mov ebx, 1
    mov edx, ecx             ; Length of the sum string
    mov ecx, edi             ; Address of the sum string
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80