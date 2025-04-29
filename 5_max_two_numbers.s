.global main

.data
num1:   .word 25
num2:   .word 10
max_msg: .asciz "The maximum of %d and %d is %d.\n"

.text
main:
    push {lr}           @ Save return address

    ldr r1, =num1
    ldr r1, [r1]        @ Load first number into r1
    ldr r2, =num2
    ldr r2, [r2]        @ Load second number into r2

    cmp r1, r2          @ Compare r1 and r2
    movgt r3, r1        @ If r1 > r2, mov r1 to r3 (max)
    movle r3, r2        @ If r1 <= r2, mov r2 to r3 (max)

    @ Print the result using printf
    ldr r0, =max_msg    @ Load address of the format string
    @ r1 already contains num1
    @ r2 already contains num2
    @ r3 contains the maximum
    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
