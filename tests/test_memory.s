addi x31,x0,0           // STARTUP: Any test should pass if and only if x31 is zero
addi x1, x0, -500       // BEGIN:   STORE WORD, followed by LOAD WORD.
addi x2, x0, 1024       //          Will write to memory position 1024
sw x1, 0(x2)            //          Copies contents of x1 into memory given by x2
lw x3,0(x2)             //          Reads from mem pos 1024 (x2) into x3
sub x31,x1,x3           // END:     Control variable: Register 31 should be zero
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop