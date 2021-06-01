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
lui      x2,1           // BEGIN:   Loads 4548
addi    x2,x2,452       //          Loads 4548
addi x3,x0,453          //          Will read from memory position 2500=2047+453 (has to be different offset than before, otherwise test is worthless)
sw x1, 2047(x3)         //          Copies content of x1 into memory address 2500=453+2047
lw x4, -2048(x2)        //          Loads cotentents of 2500=4548-2048 into x3
sub x31,x1,x4           // END:     Control variable: Register 31 should be zero
addi x1,x0,100          // BEGIN:
addi x2,x0,200
addi x3,x0,400
sw x1, 51(x1)           //          Saves 100 into 151 (51 uses both part of immediate)
sw x2, 2047(x2)         //          Saves 200 into 2247
sw x3, -331(x3)         //          Saves 400 into 69. Assigning multiple times wasnt covered on previous tests
addi x11,x0,148         //          Will read from 100(99+1), 200(200+0), 300(301-1). This is done to test offsetting
addi x12,x0,200
addi x13,x0,84
lw x11, 3(x11)
lw x12, 2047(x12)
lw x13, -15(x13)
sub x31,x1,x11           
sub x31,x2,x12           
sub x31,x3,x13           //END:
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
nop
nop
nop
nop
nop
nop
