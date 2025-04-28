; Note: Accessing environment variables directly with standard Linux syscalls
; in pure assembly is complex as it involves parsing the stack layout
; setup by the kernel/loader (specifically finding the environ pointer).
; A common approach involves using the C library (e.g., getenv) or
; parsing /proc/self/environ.
; This example demonstrates parsing /proc/self/environ.

section .data
    proc_environ_path db "/proc/self/environ", 0
    target_var db "PATH=", 0 ; Example: Look for the PATH variable
    len_target_var equ $ - target_var -1

    var_found_msg db "Found variable: ", 0
    len_var_found equ $ - var_found_msg -1
    var_not_found_msg db "Variable not found.", 10, 0
    len_var_not_found equ $ - var_not_found_msg -1
    error_open_msg db "Error opening /proc/self/environ", 10, 0
    len_error_open equ $ - error_open_msg -1
    error_read_msg db "Error reading /proc/self/environ", 10, 0
    len_error_read equ $ - error_read_msg -1
    newline db "", 10

section .bss
    file_descriptor resd 1
    buffer resb 4096       ; Buffer to read environment variables
    bytes_read resd 1

section .text
    global _start

_start:
    ; Open /proc/self/environ for reading
    mov eax, 5              ; sys_open
    mov ebx, proc_environ_path
    mov ecx, 0              ; O_RDONLY
    mov edx, 0              ; mode (not needed for O_RDONLY)
    int 0x80

    cmp eax, 0
    jl handle_error_open    ; Error if EAX < 0
    mov [file_descriptor], eax

    ; Read the environment variables into the buffer
    mov eax, 3              ; sys_read
    mov ebx, [file_descriptor]
    mov ecx, buffer
    mov edx, 4096           ; Max bytes to read
    int 0x80

    cmp eax, 0
    jle handle_error_read   ; Error if EAX <= 0 (0 means EOF before reading anything)
    mov [bytes_read], eax

    ; Close the file
    mov eax, 6              ; sys_close
    mov ebx, [file_descriptor]
    int 0x80
    ; Ignore close errors for this example

    ; Search for the target variable in the buffer
    mov esi, buffer         ; Pointer to the start of the buffer
    mov edi, buffer
    add edi, [bytes_read]   ; Pointer to the end of the buffer data

search_loop:
    cmp esi, edi            ; Reached end of buffer?
    jge var_not_found       ; If yes, variable not found

    ; Compare current position with target_var
    push esi                ; Save current position
    push edi                ; Save end pointer
    mov ecx, len_target_var ; Length to compare
    mov edi, target_var     ; String to compare against
    repe cmpsb              ; Compare ECX bytes from ESI and EDI
    pop edi                 ; Restore end pointer
    pop esi                 ; Restore current position

    je found_var            ; If equal (ZF=1), we found the variable prefix

    ; If not equal, find the next null terminator (end of current var)
find_next_var:
    cmp esi, edi            ; Check bounds
    jge var_not_found
    cmp byte [esi], 0       ; Is it the null terminator?
    je next_var_start
    inc esi                 ; Move to next character
    jmp find_next_var

next_var_start:
    inc esi                 ; Move past the null terminator to the start of the next var
    jmp search_loop         ; Continue searching

found_var:
    ; Variable prefix found at ESI
    ; Print the "Found variable: " message
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, var_found_msg
    mov edx, len_var_found
    int 0x80

    ; Print the variable value (from ESI until the next null)
    mov ecx, esi            ; Start of the variable string (e.g., "PATH=...")
    ; Find the end of the variable string (null terminator)
    mov edx, 0
find_val_end:
    cmp byte [esi+edx], 0
    je print_val
    inc edx
    jmp find_val_end

print_val:
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    ; ecx already has the start address
    ; edx has the length
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp exit_program

var_not_found:
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, var_not_found_msg
    mov edx, len_var_not_found
    int 0x80
    jmp exit_program

handle_error_open:
    mov eax, 4              ; sys_write
    mov ebx, 2              ; stderr
    mov ecx, error_open_msg
    mov edx, len_error_open
    int 0x80
    jmp exit_error

handle_error_read:
    ; Close the file first
    mov eax, 6              ; sys_close
    mov ebx, [file_descriptor]
    int 0x80
    ; Print error message
    mov eax, 4              ; sys_write
    mov ebx, 2              ; stderr
    mov ecx, error_read_msg
    mov edx, len_error_read
    int 0x80
    jmp exit_error

exit_error:
    mov eax, 1              ; sys_exit
    mov ebx, 1              ; Exit code 1 (error)
    int 0x80

exit_program:
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; Exit code 0 (success)
    int 0x80
