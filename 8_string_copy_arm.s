.global main

.data
source_str: .asciz "Hello ARM!"
dest_str:   .space 20       @ Destination buffer, ensure it's large enough
copied_msg: .asciz "Copied string: %s\n"

.text
main:
    push {lr}           @ Save return address

    ldr r1, =source_str @ r1 = address of source string
    ldr r2, =dest_str   @ r2 = address of destination buffer
    mov r3, #0          @ r3 = index/offset

copy_loop:
    ldrb r4, [r1, r3]   @ Load byte from source string into r4
    strb r4, [r2, r3]   @ Store byte into destination buffer

    cmp r4, #0          @ Check if it's the null terminator
    beq copy_end        @ If null terminator, end loop

    add r3, r3, #1      @ Increment index
    b copy_loop         @ Branch back to loop start

copy_end:
    @ Print the copied string using printf
    ldr r0, =copied_msg @ Load address of the format string
    ldr r1, =dest_str   @ Argument (address of the copied string)
    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
