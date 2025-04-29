.global main

.data
number: .word 5         @ Calculate factorial of this number
result_msg: .asciz "Factorial of %d is %d.\n"
result: .space 4        @ Space to store the result

.text
main:
    push {lr}           @ Save return address

    ldr r1, =number
    ldr r1, [r1]        @ r1 = number (n)
    mov r2, #1          @ r2 = factorial result, initialize to 1
    mov r3, r1          @ r3 = loop counter, initialize to n

factorial_loop:
    cmp r3, #0          @ Compare counter with 0
    ble loop_end        @ If counter <= 0, exit loop

    mul r2, r2, r3      @ result = result * counter
    sub r3, r3, #1      @ Decrement counter

    b factorial_loop    @ Branch back to loop start

loop_end:
    @ Store the result (optional, could just use r2 for printf)
    ldr r4, =result
    str r2, [r4]

    @ Print the result using printf
    ldr r0, =result_msg @ Load address of the format string
    @ r1 still holds the original number n
    @ r2 holds the factorial result
    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
