.global main // Changed from _start

.data
message:
    .asciz "Hello, ARM World!\\n" @ The string to print
msg_len = . - message           @ Calculate the length of the message

.text
main: // Changed from _start
    push {lr}           @ Save return address

    @ syscall write(int fd, const void *buf, size_t count)
    mov r0, #1          @ fd = 1 (stdout)
    ldr r1, =message    @ buf = address of message
    ldr r2, =msg_len    @ count = length of message
    mov r7, #4          @ syscall number for write
    svc 0               @ make syscall

    @ Exit program - Handled by C library return
    mov r0, #0          @ Return 0 from main
    pop {pc}            @ Return to caller (C library)

// _start label and exit syscall removed
