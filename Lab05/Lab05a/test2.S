// X1 - X0
// will use print later, so not leaf function, must save regs

.globl test2

.section .text
test2:
  ADD SP, [SP, #16] // create space on stack
  STUR SP
  
