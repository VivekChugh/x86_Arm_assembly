.global main

.data
num1:   .word 15
num2:   .word 7
add_msg: .asciz "Addition Result: %d\n"
sub_msg: .asciz "Subtraction Result: %d\n"

.text
main:
    push {lr}           @ Save return address

    @ Load numbers
    ldr r1, =num1
    ldr r1, [r1]        @ r1 = 15
    ldr r2, =num2
    ldr r2, [r2]        @ r2 = 7

    @ Perform Addition
    add r3, r1, r2      @ r3 = r1 + r2 (15 + 7 = 22)

    @ Print Addition Result (using printf)
    ldr r0, =add_msg    @ Format string
    mov r1, r3          @ Argument (result)
    bl printf           @ Call printf (requires linking with C library)

    @ Perform Subtraction
    ldr r1, =num1       @ Reload r1 because printf might have changed it
    ldr r1, [r1]        @ r1 = 15
    ldr r2, =num2       @ Reload r2 because printf might have changed it
    ldr r2, [r2]        @ r2 = 7
    sub r4, r1, r2      @ r4 = r1 - r2 (15 - 7 = 8)

    @ Print Subtraction Result (using printf)
    ldr r0, =sub_msg    @ Format string
    mov r1, r4          @ Argument (result)
    bl printf           @ Call printf

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
