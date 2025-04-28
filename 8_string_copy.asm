section .data
    source_string db "Hello, World!", 0 ; Source string with null terminator
    dest_string times 20 db 0       ; Destination buffer, initialized to 0
    msg db "Copied string: ", 0
    len_msg equ $ - msg
    newline db "", 10

section .text
    global _start

_start:
    ; Copy the string
    mov esi, source_string  ; ESI points to source
    mov edi, dest_string    ; EDI points to destination

copy_loop:
    mov al, [esi]           ; Load byte from source
    mov [edi], al           ; Store byte in destination
    inc esi                 ; Move to next source char
    inc edi                 ; Move to next dest char
    cmp al, 0               ; Check if it was the null terminator
    jne copy_loop           ; If not null, continue copying

    ; Print the "Copied string: " message
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg            ; message address
    mov edx, len_msg -1     ; message length (excluding null)
    int 0x80

    ; Print the copied string (destination)
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, dest_string    ; address of copied string
    ; Calculate length of copied string (find null terminator)
    mov edx, 0
    mov esi, dest_string
find_len_loop:
    cmp byte [esi+edx], 0
    je found_len
    inc edx
    jmp find_len_loop
found_len:
    int 0x80                ; invoke kernel

    ; Print a newline
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; exit code 0
    int 0x80
