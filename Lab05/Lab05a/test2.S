// X0 - x1
// will use print later, so not leaf function, must save regs

.globl test2

.section .text
test2:
  SUB SP, SP, 16 // create space on stack
  STUR X30, [SP, 0] // save return address
  STUR X1, [SP, 8] // save second arg just incase

  SUB X0, X0, X1

  // print
  // get string into x0, and c into x1
  //MOV X1, X0 // get result from test to X1 for print
  //ADRP X0, my_string
  //ADD X0, X0, :lo12:my_string
  //bl printf // call print
  // after print restore X0 with result from test 2
  // MOV X0, X1

  // clean up
  LDUR X30, [SP, 0]
  LDUR X1, [SP, 8]
  ADD SP, SP, 16 // restore

  // leave
  BR X30

.section .data
my_string:
  .asciz "Result of test2(6, 5) = %lld\n"
  
