section .data
    filename db "output.txt", 0 ; File name to create/write
    content db "This is the content to write into the file.", 10, 0 ; Content to write (with newline and null)
    len_content equ $ - content - 1 ; Length of the content (excluding null)

    ; Error messages
    err_open db "Error opening/creating file.", 10, 0
    len_err_open equ $ - err_open - 1
    err_write db "Error writing to file.", 10, 0
    len_err_write equ $ - err_write - 1
    err_close db "Error closing file.", 10, 0
    len_err_close equ $ - err_close - 1

    ; Success message
    success_msg db "File created and written successfully.", 10, 0
    len_success equ $ - success_msg - 1

section .bss
    file_descriptor resd 1 ; Reserve space for file descriptor (4 bytes)

section .text
    global _start

_start:
    ; Create/Open the file (sys_creat or sys_open with O_CREAT | O_WRONLY)
    ; Using sys_creat for simplicity
    mov eax, 8              ; system call number (sys_creat)
    mov ebx, filename       ; address of filename string
    mov ecx, 0644o          ; file permissions (rw-r--r--)
    int 0x80

    ; Check for errors during file creation/opening
    cmp eax, 0
    jl handle_error_open    ; If EAX < 0, there was an error
    mov [file_descriptor], eax ; Store the file descriptor

    ; Write content to the file
    mov eax, 4              ; system call number (sys_write)
    mov ebx, [file_descriptor] ; file descriptor
    mov ecx, content        ; address of content to write
    mov edx, len_content    ; length of content
    int 0x80

    ; Check for errors during writing
    cmp eax, 0
    jl handle_error_write   ; If EAX < 0, there was an error
    cmp eax, len_content    ; Did it write the expected number of bytes?
    jne handle_error_write  ; If not, consider it an error

    ; Close the file
    mov eax, 6              ; system call number (sys_close)
    mov ebx, [file_descriptor] ; file descriptor
    int 0x80

    ; Check for errors during closing
    cmp eax, 0
    jl handle_error_close   ; If EAX < 0, there was an error

    ; Print success message
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, success_msg
    mov edx, len_success
    int 0x80
    jmp exit_program

handle_error_open:
    ; Print open error message to stderr
    mov eax, 4              ; sys_write
    mov ebx, 2              ; stderr
    mov ecx, err_open
    mov edx, len_err_open
    int 0x80
    jmp exit_error

handle_error_write:
    ; Print write error message to stderr
    mov eax, 4              ; sys_write
    mov ebx, 2              ; stderr
    mov ecx, err_write
    mov edx, len_err_write
    int 0x80
    ; Attempt to close the file even if write failed
    mov eax, 6              ; sys_close
    mov ebx, [file_descriptor]
    int 0x80
    jmp exit_error

handle_error_close:
    ; Print close error message to stderr
    mov eax, 4              ; sys_write
    mov ebx, 2              ; stderr
    mov ecx, err_close
    mov edx, len_err_close
    int 0x80
    jmp exit_error

exit_error:
    mov eax, 1              ; sys_exit
    mov ebx, 1              ; exit code 1 (error)
    int 0x80

exit_program:
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; exit code 0 (success)
    int 0x80
