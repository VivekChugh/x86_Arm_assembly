.global main

.data
number: .word 7         @ The number to check
even_msg: .asciz "The number %d is even.\n"
odd_msg:  .asciz "The number %d is odd.\n"

.text
main:
    push {lr}           @ Save return address

    ldr r1, =number
    ldr r1, [r1]        @ Load the number into r1

    @ Check if the number is even or odd
    @ We can check the least significant bit (LSB)
    @ If LSB is 0, the number is even. If LSB is 1, the number is odd.
    and r2, r1, #1      @ r2 = r1 & 1 (isolate the LSB)

    cmp r2, #0          @ Compare LSB with 0
    beq is_even         @ If LSB is 0, branch to is_even

is_odd:
    @ Number is odd
    ldr r0, =odd_msg    @ Load address of odd message format string
    @ r1 already contains the number
    bl printf           @ Call printf (requires linking with C library)
    b end_check         @ Branch to end

is_even:
    @ Number is even
    ldr r0, =even_msg   @ Load address of even message format string
    @ r1 already contains the number
    bl printf           @ Call printf
    // Fall through to end_check

end_check:
    // Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
