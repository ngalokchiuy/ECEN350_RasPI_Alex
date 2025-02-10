// long long int j = initial_value;

//for ( i=0; i <10; i ++) {
//    my_array [ i ] = j ;
//    j ++;
//}

.globl lab03c
.section .text

lab03c:
// load address of array
ADRP X3, my_array
ADD X3, X3, :loc12:my_array

// load initial_value (j) to X2
ADRP X4, initial_value
ADD X4, X4, :loc12:initial_value

MOVZ X9, XZR // i  = 0

Loop: SUB X8, X9, #10 // i - 10
  CBZ X8, Exit // i == 10?, go to exit
  STUR X2, [X3,#0] 

  ADD X4, X4, #1 //  ++j
  ADD X9, X9, #1 // ++i
  ADD X3, X3, #8 // move one word (8 bytes)
  
Exit:




.section .data
// reserve array of quad words, size 10
initial_value: .quad 6 // first digit of uin
my_array: .space 80 // quad word = 8 bytes , 10 words = 80 bytes, fill is zero

