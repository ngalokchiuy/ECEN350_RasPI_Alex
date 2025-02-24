// X1 - X0
// will use print later, so not leaf function, must save regs

.globl test2

.section .text
test2:
  SUB SP, SP, 16 // create space on stack
  STUR X30, [SP, 0] // save return address
  STUR X1, [SP, 8] // save second arg just incase

  SUB X0, X0, X1
  
  
