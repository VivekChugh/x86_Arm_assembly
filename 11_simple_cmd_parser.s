.global main

.data
usage_msg: .asciz "Usage: %s <arg1> <arg2> ...\n"
arg_msg:   .asciz "Argument %d: %s\n"

.text
main:
    push {lr}           @ Save return address
    mov r5, r0          @ Save argc (passed in r0) to r5
    mov r6, r1          @ Save argv (passed in r1) to r6

    cmp r5, #1          @ Check if argc (in r5) <= 1
    ble print_usage     @ If argc <= 1, print usage message

    mov r7, #1          @ r7 = argument index counter (start from 1)

print_loop:
    cmp r7, r5          @ Compare index (r7) with argc (r5)
    bge loop_end        @ If index >= argc, exit loop

    @ Prepare arguments for printf to print one argument
    ldr r4, [r6, r7, LSL #2] @ r4 = argv[index] (address of the argument string) using argv base in r6
    ldr r0, =arg_msg    @ Arg 0: format string address
    mov r1, r7          @ Arg 1: index (r7)
    mov r2, r4          @ Arg 2: argument string address (r4)
    bl printf           @ Call printf (requires linking with C library)
    // r7 is callee-saved, so printf should not modify it. No need to restore.

    add r7, r7, #1      @ Increment index
    b print_loop

loop_end:
    mov r0, #0          @ Set return code to 0 (success)
    b end_main          @ Branch to common exit point

print_usage:
    @ Prepare arguments for printf usage message
    ldr r4, [r6]        @ r4 = argv[0] (program name) from saved argv (r6)
    ldr r0, =usage_msg  @ Arg 0: format string address
    mov r1, r4          @ Arg 1: program name address
    bl printf
    mov r0, #1          @ Set return code to 1 (error)
    // Fall through to end_main

end_main:
    pop {pc}            @ Return to caller (C library)
