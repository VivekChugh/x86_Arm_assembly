section .data
    num dw 5                  ; Number to calculate factorial for (e.g., 5!)
    msg db "Factorial of "
    len_msg equ $ - msg
    is_msg db " is: "
    len_is equ $ - is_msg
    newline db 0xA

section .bss
    num_str resb 11             ; Buffer for the input number string
    fact_str resb 21            ; Buffer for the factorial result string (can be large)

section .text
    global _start

; Procedure to convert number in EAX to string
; Input: EAX = number, EDI = buffer address
; Output: EDI points to the start of the null-terminated string in the buffer
_number_to_string:
    mov esi, edi              ; Use ESI for buffer pointer
    add edi, 19               ; Point near end of buffer (leave space for null)
    mov byte [edi+1], 0       ; Null terminate
    mov ebx, 10               ; Divisor

convert_loop:
    xor edx, edx              ; Clear EDX for division
    div ebx                   ; EAX = EAX / 10, EDX = EAX % 10
    add dl, '0'               ; Convert remainder (digit) to ASCII
    mov [esi], dl             ; Store digit in buffer
    dec esi                   ; Move to previous byte in buffer
    test eax, eax             ; Check if quotient is zero
    jnz convert_loop          ; If not zero, continue loop
    
    inc esi                   ; Point back to the first digit
    mov edi, esi              ; Return pointer in EDI
    ret

_start:
    ; Convert input number to string for printing
    movzx eax, word [num]     ; Load number into EAX
    mov edi, num_str          ; Point EDI to num_str buffer
    call _number_to_string    ; Convert EAX to string, result pointer in EDI
    mov esi, edi              ; Save pointer to number string
    
    ; Calculate string length
    push esi                  ; Save esi before clobbering it
    mov edi, esi              ; Use edi to find the end of the string
find_num_len_loop:
    cmp byte [edi], 0
    je find_num_len_done
    inc edi
    jmp find_num_len_loop
find_num_len_done:
    sub edi, esi              ; edi now holds the length
    mov edx, edi              ; Length of number string
    pop esi                   ; Restore esi

    ; Print "Factorial of "
    push esi                  ; Save number string pointer
    push edx                  ; Save number string length
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len_msg
    int 0x80

    ; Print the number
    pop edx                   ; Restore number string length
    pop esi                   ; Restore number string pointer
    mov eax, 4
    mov ebx, 1
    mov ecx, esi              ; Address of number string
    ; EDX already has length
    int 0x80

    ; Print " is: "
    mov eax, 4
    mov ebx, 1
    mov ecx, is_msg
    mov edx, len_is
    int 0x80

    ; Calculate factorial
    movzx ecx, word [num]     ; Load number into ECX (loop counter)
    mov eax, 1                ; Initialize factorial result in EAX

factorial_loop:
    mul ecx                   ; EAX = EAX * ECX
    loop factorial_loop       ; Decrement ECX, loop if not zero

    ; Convert factorial result to string
    mov edi, fact_str         ; Point EDI to fact_str buffer
    call _number_to_string    ; Convert EAX to string, result pointer in EDI
    mov esi, edi              ; Save pointer to factorial string

    ; Calculate factorial string length
    push esi                  ; Save esi before clobbering it
    mov edi, esi              ; Use edi to find the end of the string
find_fact_len_loop:
    cmp byte [edi], 0
    je find_fact_len_done
    inc edi
    jmp find_fact_len_loop
find_fact_len_done:
    sub edi, esi              ; edi now holds the length
    mov edx, edi              ; Length of factorial string
    pop esi                   ; Restore esi

    ; Print the factorial result
    mov eax, 4
    mov ebx, 1
    mov ecx, esi              ; Address of factorial string
    ; EDX already has length
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