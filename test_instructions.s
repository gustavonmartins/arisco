addi x31,x0,0 		// Test ADDI start, setting expected value
ADDI x21, x0, 123 
ADDI x20, x0, 123
SUB x31, x20, x21 	//Control variable: X31 is zero if and only if circuit is correct. Finish test
addi x10,x0,1110 	// Test ADD start, setting expected value
addi x1,x0,555
addi x2,x0,555
add x3,x1,x2
sub x31,x3,x10 		// End of test: Control variable should be zero if passed
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
addi x0,x0,0
