.global main // Changed from _start
.global getenv          @ Declare external getenv function

.data
var_name:   .asciz "PATH"   @ Environment variable to read
found_msg:  .asciz "Value of %s: %s\n"
not_found_msg: .asciz "Environment variable %s not found.\n"

.text
main: // Changed from _start
    push {lr}           @ Save return address

    @ Call getenv(var_name)
    ldr r0, =var_name   @ Argument 0: address of the variable name string
    bl getenv           @ Call getenv (requires linking with C library)
                        @ Result (address of value or NULL) will be in r0

    cmp r0, #0          @ Check if the result is NULL (0)
    beq var_not_found   @ If NULL, variable not found

var_found:
    @ Variable found, r0 contains the address of the value string
    mov r2, r0          @ Save the value address in r2
    ldr r0, =found_msg  @ Arg 0 for printf: format string
    ldr r1, =var_name   @ Arg 1 for printf: variable name
    @ r2 already holds the value address (Arg 2 for printf)
    bl printf           @ Call printf
    mov r0, #0          @ Set return code to 0 (success)
    b end_main          @ Branch to common exit point

var_not_found:
    @ Variable not found
    ldr r0, =not_found_msg @ Arg 0 for printf: format string
    ldr r1, =var_name      @ Arg 1 for printf: variable name
    bl printf              @ Call printf
    mov r0, #1             @ Set return code to 1 (optional, indicates not found)
    // Fall through to end_main

end_main:
    pop {pc}            @ Return to caller (C library)
