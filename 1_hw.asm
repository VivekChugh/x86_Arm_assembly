; filepath: /home/vchugh-local/Templates/repos/x86/hw.asm
section .data
    msg db "Hello, World!", 0xA  ; The message to print, followed by a newline
    len equ $ - msg              ; Calculate the length of the message

    msg2 db "OK, Good!", 0xA  ; The message to print, followed by a newline
    len2 equ $ - msg2              ; Calculate the length of the message


section .text
    global _start                ; Entry point for the program

_start:
    ; Write system call
    mov eax, 4                   ; System call number for sys_write
    mov ebx, 1                   ; File descriptor 1 (stdout)
    mov ecx, msg                 ; Address of the message
    mov edx, len                 ; Length of the message
    int 0x80                     ; Trigger the system call

    ; Write system call
    mov eax, 4                   ; System call number for sys_write
    mov ebx, 1                   ; File descriptor 1 (stdout)
    mov ecx, msg2                 ; Address of the message
    mov edx, len2                 ; Length of the message
    int 0x80                     ; Trigger the system call


    ; Exit system call
    mov eax, 1                   ; System call number for sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80                     ; Trigger the system call