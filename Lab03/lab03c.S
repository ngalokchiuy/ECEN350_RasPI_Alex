// long long int j = initial_value;

//for ( i=0; i <10; i ++) {
//    my_array [ i ] = j ;
//    j ++;
//}

.globl lab03c
.section text

// load address of array
ADRP X3, my_array
ADD X3, X3, :loc12:my_array








.section data
// reserve array of quad words, size 10
my_array: .space 80[,0] // quad word = 8 bytes , 10 words = 80 bytes, fill is zero
//emits size bytes, each of value fill. If the comma and fill are omitted, fill is assumed to be zero.
