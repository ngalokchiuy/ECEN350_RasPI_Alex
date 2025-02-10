//for( i =0; i <10; i ++) {
//   UIN = UIN−1;
//}

.globl lab03b

.section .text
lab03b:
//load address for UIN
ADRP X3, UIN
ADD X3, X3 :lo12:UIN

LDUR X2, [X3, #0] // get value of UIN

MOV X9, #0 // initialize i = 0
Loop:SUB X8, X9, #10 // X8 is condition reg
  CBZ X8, Exit // if i == 10, leave
  SUB X2, X2, #1 // UIN = UIN -1
  ADD X9, X9, #1 // ++ i
  B Loop // unconditional loop

// clean up
Exit: STUR X2, [X3, #0]

//return to main
BR X30


.section .data
UIN: .quad 37 // sum of 633008296

