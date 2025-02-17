.globl factorial
.section .text
// use my_mul, x0, x1

factorial:
// set up ____________________________
SUB SP, SP, #16 // make room on stack
STUR X1, [SP, #8] // save X1
STUR X30, [SP, #0] // save LR

// do condition for n ________________
CBNZ X0, mult_loop // if n!=0, do factorial
MOV X0, #1 // otherwise return 1 and leave
B Exit // skip to end

// continue factorial here _____________
mult_loop: 
ADD X1, X0, #0 // move n to X1 to save
SUB X0, X0, #1 // (n-1)
BL factorial // factorial(n-1) = X0
BL my_mul // X0 = factorial(n-1), X1 = n --> now X0 = X1*X0
// returns X0, now we proced to exit

// clean up ____________________________
Exit:
LDUR  X30, [SP, #0] // get LR
LDUR X1, [SP, #8] // save X1
ADD SP, SP, #16 // restore SP

BR X30 // leave
