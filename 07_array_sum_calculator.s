.global main

.data
array:  .word 10, 20, 30, 40, 50 @ The array of numbers
array_len: .word 5              @ Length of the array
sum_msg: .asciz "Sum of the array elements is: %d\n"
sum_val: .space 4               @ Space to store the sum

.text
main:
    push {lr}           @ Save return address

    ldr r1, =array      @ r1 = address of the start of the array
    ldr r2, =array_len
    ldr r2, [r2]        @ r2 = length of the array (loop counter)
    mov r3, #0          @ r3 = sum, initialize to 0
    mov r4, #0          @ r4 = array index, initialize to 0

sum_loop:
    cmp r4, r2          @ Compare index with length
    bge loop_end        @ If index >= length, exit loop

    @ Load the current array element
    @ r1 is base address, r4 is index, 4 is element size (word)
    ldr r5, [r1, r4, LSL #2] @ r5 = array[index]

    add r3, r3, r5      @ sum = sum + array[index]
    add r4, r4, #1      @ Increment index

    b sum_loop          @ Branch back to loop start

loop_end:
    @ Store the sum (optional)
    ldr r6, =sum_val
    str r3, [r6]

    @ Print the sum using printf
    ldr r0, =sum_msg    @ Load address of the format string
    mov r1, r3          @ Argument (the sum)
    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
