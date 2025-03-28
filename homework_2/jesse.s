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

@.equ READERROR, 0 @Used to check for scanf read error. 
.equ COUNT_MAX, 10 @ Constant to check against during the counting loop.

.global main @ Have to use main because of C library uses. 

main:

@ Count function will increment the count_start variable until it is equivalent to 
count:
  ldr r0, =str_iteration @ Put the address of the iteration string into register #0.
  ldr r1, =counter	 @ Put the address of the counter variable into register #1.
  ldr r4, [r1]           @ Must load the actual value at the memory location of register #1 into a register before we can perform arithmetic on it. I'm selecting register #4 because printf does not preserve r0 - r3.
  add r4, r4, #1	 @ Increment our counter variable by a constant value of 1.
  str r4, [r1]		 @ Store the result of the addition in register #2 back into the memory of register #1.
  mov r1, r4		 @ Copy the value of register #4 into register #2 because printf expects register #1 to contain the variable to insert into the string held in register #1.	
  bl  printf		 @ Call to C-library's printf.
  cmp r4, #COUNT_MAX	 @ Comparison operation between the value in r1 and the constant #COUNT_MAX which is 10.
  blt count		 @ Branch to the beginning of the loop if the value is less than 10.

output:
  ldr r0, =str_output	 @ Ending output that corresponds to requirement number 3. I.E. output: "happily finished".
  bl printf		 @ Another call to C-library's printf to actually write the string to console.	
  b myexit		 @ Exit the program.

@*******************
@prompt:
@*******************

@ Ask the user to enter a number.
 
@   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter
@   bl  printf              @ Call the C printf to display input prompt. 

@*******************
@get_input:
@*******************

@ Set up r0 with the address of input pattern
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which in this
@ case will be intInput. 

@   ldr r0, =numInputPattern @ Setup to read in one number.
@   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
@   bl  scanf                @ scan the keyboard.
@   cmp r0, #READERROR       @ Check for a read error.
@   beq readerror            @ If there was a read error go handle it. 
@   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
@   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

@ Print the input out as a number.
@ r1 contains the value input to keyboard. 

@   ldr r0, =strOutputNum
@   bl  printf
@   b   myexit @ leave the code. 

@***********
@readerror:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

@   ldr r0, =strInputPattern
@   ldr r1, =strInputError   @ Put address into r1 for read.
@   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

@   b prompt


@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

   mov r7, #0x01 @SVC call to exit
   svc 0         @Make the system call. 

.data

.balign 4
counter: .word 0 @ 32-bit or 4-byte word variable to hold our integer couner. In armv6, the word size is 32-bit.

.balign 4
str_iteration: .asciz "Count: %d\n" @ ASCII string (array of byte characters) to fulfill the 2nd requirement.

.balign 4
str_output: .asciz "happily finished\n" @ ASCII string (array of byte characters) to fulfill the 3rd requirement.

@ Declare the strings and data needed

@.balign 4
@strInputPrompt: .asciz "Input the number: \n "

@.balign 4
@strOutputNum: .asciz "The number value is: %d \n"

@ Format pattern for scanf call.

@.balign 4
@numInputPattern: .asciz "%d"  @ integer format for read. 

@.balign 4
@strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

@.balign 4
@strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

@.balign 4
@intInput: .word 0   @ Location used to store the user input. 

@ Let the assembler know these are the C library functions. 

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

@.global scanf
@  To use scanf:
@      r0 - Contains the address of the input format string used to read the user
@           input value. In this example it is numInputPattern.  
@      r1 - Must contain the address where the input value is going to be stored.
@           In this example memory location intInput declared in the .data section
@           is being used.  
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.
@ Important Notes about scanf:
@   If the user entered an input that does NOT conform to the input pattern, 
@   then register r0 will contain a 0. If it is a valid format
@   then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@   input so that needs to be cleared out before attempting anything else. 
@

@end of code and end of file. Leave a blank line after this.
