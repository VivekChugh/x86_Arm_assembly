.global main // Changed from _start
.global add_two_numbers @ Make the function visible globally

.data
num_a:  .word 12
num_b:  .word 30
result_msg: .asciz "Result of adding %d and %d is %d.\n"

.text

@ Function to add two numbers
@ Input: r0 = first number, r1 = second number
@ Output: r0 = sum
add_two_numbers:
    push {lr}           @ Save link register (return address)
    add r0, r0, r1      @ Perform addition: r0 = r0 + r1
    pop {pc}            @ Restore link register and return

main: // Changed from _start
    push {lr}           @ Save return address for main

    @ Load numbers to pass to the function
    ldr r4, =num_a
    ldr r0, [r4]        @ Load first number into r0 for function arg 1
    ldr r5, =num_b
    ldr r1, [r5]        @ Load second number into r1 for function arg 2

    @ Call the function
    bl add_two_numbers  @ Branch and link to the function
                        @ Result will be in r0

    @ Prepare arguments for printf
    mov r3, r0          @ Save the result (sum) in r3
    ldr r0, =result_msg @ Load address of the format string
    ldr r1, =num_a      @ Reload num_a address
    ldr r1, [r1]        @ Load num_a value for printf arg 1
    ldr r2, =num_b      @ Reload num_b address
    ldr r2, [r2]        @ Load num_b value for printf arg 2
    @ r3 already holds the sum for printf arg 3

    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    // mov r7, #1          @ syscall number for exit - REMOVED
    // mov r0, #0          @ exit code 0 - REMOVED
    // svc 0               @ make syscall - REMOVED
    pop {pc}            @ Return to caller (C library)
