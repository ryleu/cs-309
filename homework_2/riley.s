@ Homework 2
@ Filename: homework_2/riley.s
@ Author: Riley McLain
@ Purpose: Count from 1 to 10, and then output "Happily Finished"

.global main

main:
    mov r5, #1      @ prep our register with a 1

loop:
    cmp r5, #10     @ check if we're over 10 yet
    bhi end         @ jump to the end if we are

    ldr r0, =count  @ put the address of the format string into r0
    mov r1, r5
    bl printf       @ call printf. will use r0 as the string and r1 as the data

    add r5, r5, #1

    b loop          @ loop

end:
    ldr r0, =done   @ put the address of the "done" string into r0
    bl printf       @ print it

    mov r7, #0x01   @ value for exit system call
    svc 0           @ make the syscall, exiting gracefully

.data

@ format string for printing a number
.balign 4
count: .asciz "%d\n"

@ end of code string
.balign 4
done: .asciz "happily finished\n"

@ declare this so as won't explode (gcc will take care of these during the linking phase)
.global printf
