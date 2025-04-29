.global main

.data
value:  .word 42          @ Value to store in memory
storage: .space 4         @ Reserve 4 bytes for storage
message: .asciz "Stored value: %d, Retrieved value: %d\\n" @ Message for printf

.text
main:
    push {lr}           @ Save return address

    ldr r1, =value      @ Load address of 'value' into r1
    ldr r2, [r1]        @ Load the value (42) from memory address in r1 into r2

    ldr r1, =storage    @ Load address of 'storage' into r1
    str r2, [r1]        @ Store the value from r2 into memory address in r1

    @ Now retrieve the value
    ldr r3, [r1]        @ Load the value from 'storage' back into r3

    @ Prepare for printf (optional, for verification)
    ldr r0, =message    @ Load address of the format string
    mov r1, r2          @ First argument for printf (original value)
    mov r2, r3          @ Second argument for printf (retrieved value)
    bl printf           @ Call printf (requires linking with C library)

    @ Exit program - Handled by C library return
    pop {pc}            @ Return to caller (C library)
