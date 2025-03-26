@ Filename: student_inputB.s
@ Author:   Kevin Preston
@ Purpose:  Show CS309 and CS413 students how to read user inputs from KB. 
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@   4-Jul-2019  Changed this code from using the stack pointer to a 
@               locally declared variable. 
@  15-Sep-2019  Moved some code around to make it clearer on how to 
@               get the input value into a register. 
@   1-Oct-2019  Added code to check for user input errors from the 
@               scanf call.            
@
@ Use these commands to assemble, link, run and debug this program:
@    as -o student_inputB.o student_inputB.s
@    gcc -o student_inputB student_inputB.o
@    ./student_inputB ;echo $?
@    gdb --args ./student_inputB 

@ ****************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ****************************************************

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

 @ Initialize counter to 1
    mov r4, #1  @ r4 will be our loop counter

loop:
    cmp r4, #11   @ Check if counter > 10
    beq finished  @ If yes, exit loop

    @ Print the current count
    ldr r0, =strOutputNum  @ Load format string
    mov r1, r4            @ Move counter value to r1 for printf
    bl printf             @ Call printf
    
    add r4, r4, #1        @ Increment counter
    b loop                @ Repeat loop

finished:
    ldr r0, =strFinished  @ Load completion message
    bl printf             @ Print "happily finished"

    mov r7, #0x01  @ Exit syscall
    svc 0

.data
.balign 4
strOutputNum: .asciz "Count: %d\n"
.balign 4
strFinished: .asciz "Happily finished\n"
