.globl factorial
.section .text
// use my_mult, x0, x1

factorial:
// set up ____________________________
SUB X28, X28, #8 // make room on stack
STUR X30 [X28, #0] // save LR

// do condition for n ________________
CBNZ X0 mult_loop // if n!=0, do factorial
MOV X0, #1 // otherwise return 1 and leave
B Exit // skip to end

// continue factorial here _____________
mult_loop: 
ADD X1, X0, #0 // move n to X1 to save
SUB X0, X0, #1 // (n-1)
BL factorial // factorial(n-1) = X0
BL my_mult // X0 = factorial(n-1), X1 = n --> now X0 = X1*X0
// returns X0, now we proced to exit

// clean up ____________________________
Exit:
LDUR  X30 [X28, #0] // get LR
ADD X28, X28, #8 // restore SP

B X30 // leave
