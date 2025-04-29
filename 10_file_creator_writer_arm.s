.global main

.data
filename:   .asciz "output.txt" @ Name of the file to create/write
content:    .asciz "This content will be written to the file.\n"
content_len_val: .word 41          @ Explicit length (41 bytes)

@ Error messages (optional, but good practice)
open_err_msg: .asciz "Error opening file\n"
open_err_len: .word . - open_err_msg -1
write_err_msg: .asciz "Error writing to file\n"
write_err_len: .word . - write_err_msg -1
close_err_msg: .asciz "Error closing file\n"
close_err_len: .word . - close_err_msg -1

.text
main:
    push {lr}           @ Save return address
    mov r8, #0          @ Use r8 to store potential exit code (0 success, 1 error)

    @ --- Open File ---
    mov r7, #5          @ syscall number for open
    ldr r0, =filename   @ address of filename string
    mov r1, #01101      @ flags: O_WRONLY | O_CREAT | O_TRUNC (01 | 0100 | 01000 = 01101)
    mov r2, #0644       @ mode: permissions (rw-r--r--)
    svc 0               @ make syscall
                        @ r0 will contain the file descriptor or -1 on error

    cmp r0, #0          @ Check if file descriptor is valid (>= 0)
    blt open_error      @ If less than 0, branch to open_error
    mov r4, r0          @ Save the file descriptor in r4

    @ --- Write to File ---
    mov r7, #4          @ syscall number for write
    mov r0, r4          @ file descriptor (from r4)
    ldr r1, =content    @ address of content string
    ldr r2, =content_len_val // Use label for explicit length
    ldr r2, [r2]        @ length of content (41)
    svc 0               @ make syscall
                        @ r0 will contain bytes written or -1 on error

    cmp r0, #0          @ Check if write was successful (>= 0 bytes written)
    blt write_error     @ If less than 0, branch to write_error

    @ --- Close File ---
    mov r7, #6          @ syscall number for close
    mov r0, r4          @ file descriptor to close
    svc 0               @ make syscall
                        @ r0 will be 0 on success, -1 on error

    cmp r0, #0          @ Check if close was successful
    blt close_error     @ If less than 0, branch to close_error

    b end_main          @ If all successful, branch to end

open_error:
    @ Print open error message to stderr
    mov r7, #4
    mov r0, #2          @ file descriptor 2 (stderr)
    ldr r1, =open_err_msg
    ldr r2, =open_err_len
    ldr r2, [r2]
    svc 0
    mov r8, #1          @ Set exit code to 1 (error)
    b end_main          @ Branch to common exit point

write_error:
    @ Print write error message to stderr
    mov r7, #4
    mov r0, #2
    ldr r1, =write_err_msg
    ldr r2, =write_err_len
    ldr r2, [r2]
    svc 0
    @ Attempt to close the file even if write failed
    mov r7, #6
    mov r0, r4
    svc 0
    mov r8, #1          @ Set exit code to 1 (error)
    b end_main          @ Branch to common exit point

close_error:
    @ Print close error message to stderr
    mov r7, #4
    mov r0, #2
    ldr r1, =close_err_msg
    ldr r2, =close_err_len
    ldr r2, [r2]
    svc 0
    mov r8, #1          @ Set exit code to 1 (error)
    @ Fall through to end_main

end_main:
    mov r0, r8          @ Set return code from r8
    pop {pc}            @ Return to caller (C library)
