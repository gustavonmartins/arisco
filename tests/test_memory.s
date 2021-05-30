addi x31,x0,0           // STARTUP: Any test should pass if and only if x31 is zero
addi x1, x0, -500       // BEGIN:   STORE WORD, followed by LOAD WORD.
addi x2, x0, 1024       //          Will write to memory position 1024
sw x1, 0(x2)            //          Copies contents of x1 into memory given by x2
lw x3,0(x2)             //          Reads from mem pos 1024 (x2) into x3
sub x31,x1,x3           // END:     Control variable: Register 31 should be zero
addi x1,x0,-653         // BEGIN:   STORE WORD with negative offset, followed by LOAD WORD with positive offset
lui      x2,1           //          Loads 4548
addi    x2,x2,452       //          Loads 4548
addi x3,x0,453          //          Will read from memory position 2500=2047+453 (has to be different offset than before, otherwise test is worthless)
sw x1, -2048(x2)        //          Copies content of x1 into memory address 2500=4548-2048
lw x4, 2047(x3)         //          Loads cotentents of 2500=453+2047 into x3
sub x31,x1,x4           // END:     Control variable: Register 31 should be zero
lui      x2,1           //          Loads 4548
addi    x2,x2,452       //          Loads 4548
addi x3,x0,453          //          Will read from memory position 2500=2047+453 (has to be different offset than before, otherwise test is worthless)
sw x1, 2047(x3)         //          Copies content of x1 into memory address 2500=453+2047
lw x4, -2048(x2)        //          Loads cotentents of 2500=4548-2048 into x3
sub x31,x1,x4           // END:     Control variable: Register 31 should be zero
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
