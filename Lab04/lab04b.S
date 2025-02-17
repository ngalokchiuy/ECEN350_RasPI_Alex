.globl factorial
.section .text
// use my_mult, x0, x1

factorial:
// set up ____________________________
SUB X28, X28, #8 // make room on stack
STUR X30 [X28, #0] // save LR


// do condition for n ________________
CBNZ X0 mult_loop // if n!=0, exit funciton
MOV X0, #1 // return 1



// continue factorial here _____________
mult_loop: 


// clean up ____________________________
Exit:
LDUR  X30 [X28, #0] // get LR
ADD X28, X28, #8

B X30 // leave
