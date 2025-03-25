@ Filename: counter.s
@ Author:   Jake Thompson
@ Purpose:  Practice ARM assembly programing by devloping a basic loop.
@ History:  Based on student_inputB written by Mr. Kevin Preston
@
@ Use these commands to assemble, link, run and debug this program:
@    as -o counter.o counter.s
@    gcc -o counter counter.o
@    ./counter
@    gdb --args ./counter

@ ****************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ****************************************************

.global main @ Have to use main because of C library uses.

main:
    mov r4, #1 @ initialize the first number in r4 as 1

loop:
    cmp r4, #10 @ compare counter (r4) to #10
    bhi done @ exit loop and branch to done if counter is higher than to 10
    
    ldr r0, =strCountDisplay @ load the address of the count display message
    mov r1, r4 @ copy value of r4 to r1 for printing
    bl printf @ call the C printf function to print the number

    add r4, r4, #1 @ increment the counter by 1
    b loop @ repeat the loop

done:
    ldr r0, =strDoneDisplay @ load the address of the finished display message
    bl printf @ call the C printf function to print the number

    mov r7, #0x01 @ SVC call to exit
    svc 0         @ make the system call

@ Declare the strings and data needed
.data

.balign 4
strCountDisplay: .asciz "%d\n"

.balign 4
strDoneDisplay: .asciz "happily finished\n"

@ Let the assembler know these are the C library functions. 

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.

@ end of code and end of file. Leave a blank line after this.
