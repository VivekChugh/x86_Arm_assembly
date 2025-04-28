section .data
    usage_msg db "Usage: program <arg1> <arg2> ...", 10, 0
    len_usage equ $ - usage_msg - 1
    arg_prefix db "Argument ", 0
    len_arg_prefix equ $ - arg_prefix - 1
    colon_space db ": ", 0
    len_colon_space equ $ - colon_space - 1
    newline db "", 10

section .bss
    arg_num_str resb 4 ; Buffer for argument number string (up to 3 digits + null)

section .text
    global _start

_start:
    pop ecx             ; Get argc (argument count) from stack
    pop edx             ; Get argv[0] (program name) from stack

    ; Check if there are any arguments besides the program name
    cmp ecx, 1
    jle no_args         ; If argc <= 1, jump to no_args

    ; Loop through arguments (starting from argv[1])
    mov esi, 1          ; Argument index (starts at 1)

print_arg_loop:
    ; Print "Argument " prefix
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, arg_prefix
    mov edx, len_arg_prefix
    int 0x80

    ; Convert argument index (esi) to string and print it
    mov eax, esi
    call _printDec      ; Call function to print EAX as decimal

    ; Print ": "
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, colon_space
    mov edx, len_colon_space
    int 0x80

    ; Get the current argument pointer (argv[esi])
    pop eax             ; Get argv[esi] from stack

    ; Print the argument string
    mov ecx, eax        ; Address of the argument string
    ; Calculate length of the argument string
    mov edx, 0
find_len_loop:
    cmp byte [ecx+edx], 0
    je found_len
    inc edx
    jmp find_len_loop
found_len:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    ; ecx already holds the address
    ; edx already holds the length
    int 0x80

    ; Print newline
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Increment argument index and check if done
    inc esi
    cmp esi, [esp-4]    ; Compare esi with argc (original value on stack)
    jl print_arg_loop   ; If esi < argc, loop again

    jmp exit_program    ; All arguments printed

no_args:
    ; Print usage message if no arguments provided
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, usage_msg
    mov edx, len_usage
    int 0x80
    jmp exit_program

; Function to print EAX as an unsigned decimal number
_printDec:
    pusha               ; Save all general purpose registers
    mov edi, arg_num_str + 2 ; Point near end of buffer
    mov byte [edi+1], 0 ; Null terminate
    mov ecx, 10         ; Divisor

.loop:
    xor edx, edx        ; Clear edx for division
    div ecx             ; eax = eax / 10, edx = eax % 10
    add dl, '0'         ; Convert remainder to ASCII
    mov [edi], dl       ; Store digit
    dec edi             ; Move to previous byte
    test eax, eax       ; Is quotient zero?
    jnz .loop           ; If not, loop

    inc edi             ; Point to the first digit

    ; Print the number string
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, edi        ; Address of string
    mov edx, arg_num_str + 3 ; Calculate length
    sub edx, edi
    int 0x80

    popa                ; Restore registers
    ret

exit_program:
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80
