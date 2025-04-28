section .data
    num1 dd 12
    num2 dd 23
    msg db "The sum is: " ; Removed null terminator
    len equ $ - msg
    newline db 0xA

section .bss
    sum_str resb 11             ; Buffer for the sum string

section .text
    global _start

; Procedure to convert number in EAX to string
; Input: EAX = number, EDI = buffer address
; Output: EDI points to the start of the null-terminated string in the buffer
_number_to_string:
    mov esi, edi              ; Save original buffer pointer
    add edi, 9                ; Point to end of buffer (leave space for null)
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

; Procedure to add two numbers
; Expects two dword arguments on the stack
; Returns the sum in EAX
add_numbers:
    push ebp                  ; Save old base pointer
    mov ebp, esp              ; Set up new stack frame

    mov eax, [ebp + 8]        ; Get first argument from stack
    mov ebx, [ebp + 12]       ; Get second argument from stack
    add eax, ebx              ; Add the numbers, result in EAX

    mov esp, ebp              ; Restore stack pointer
    pop ebp                   ; Restore old base pointer
    ret                       ; Return to caller

_start:
    ; Push arguments onto the stack (in reverse order)
    push dword [num2]
    push dword [num1]

    ; Call the add_numbers procedure
    call add_numbers
    add esp, 8                ; Clean up stack (2 dword arguments * 4 bytes/dword)

    ; EAX now contains the sum

    ; Convert the sum (in EAX) to a string
    mov edi, sum_str          ; Point EDI to the result buffer
    call _number_to_string    ; Convert EAX to string, result pointer in EDI
    mov esi, edi              ; Save pointer to the sum string

    ; Calculate the length of the sum string
    mov ecx, sum_str + 10     ; End of buffer
    sub ecx, esi              ; Calculate length
    mov edx, ecx              ; Length of the sum string

    ; Print the message "The sum is: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Print the sum string
    mov eax, 4
    mov ebx, 1
    mov ecx, esi              ; Address of the sum string
    ; Need to recalculate length as ECX was overwritten
    mov esi, edi
    mov edx, sum_str + 10
    sub edx, esi
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