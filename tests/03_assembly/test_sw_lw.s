
addi x31,x0,0           // STARTUP: Any test should pass if and only if x31 is zero
addi x1,x0,1            // First test
addi x5, x0, -500       // BEGIN:   STORE WORD, followed by LOAD WORD.
addi x2, x0, 1024       //          Will write to memory position 1024
SW x5, 0(x2)            //          Copies contents of x5 into memory given by x2
LW x3,0(x2)             //          Reads from mem pos 1024 (x2) into x3
sub x31,x5,x3           // END:     Control variable: Register 31 should be zero

addi x1,x1,1            // Second test
addi x5,x0,-653         // BEGIN:   STORE WORD with negative offset, followed by LOAD WORD with positive offset
lui      x2,1           //          Loads 4548
addi    x2,x2,452       //          Loads 4548
addi x3,x0,453          //          Will read from memory position 2500=2047+453 (has to be different offset than before, otherwise test is worthless)
SW x5, -2048(x2)        //          Copies content of x5 into memory address 2500=4548-2048
LW x4, 2047(x3)         //          Loads cotentents of 2500=453+2047 into x3
sub x31,x5,x4           // END:     Control variable: Register 31 should be zero

addi x1,x1,1            // Third test
lui      x2,1           // BEGIN:   Loads 4548
addi    x2,x2,452       //          Loads 4548
addi x3,x0,453          //          Will read from memory position 2500=2047+453 (has to be different offset than before, otherwise test is worthless)
SW x5, 2047(x3)         //          Copies content of x5 into memory address 2500=453+2047
LW x4, -2048(x2)        //          Loads cotentents of 2500=4548-2048 into x3
sub x31,x5,x4           // END:     Control variable: Register 31 should be zero

addi x1,x1,1            // Fourth test
addi x5,x0,100          // BEGIN:
addi x2,x0,200
addi x3,x0,400
SW x5, 51(x5)           //          Saves 100 into 151 (51 uses both part of immediate)
SW x2, 2047(x2)         //          Saves 200 into 2247
SW x3, -331(x3)         //          Saves 400 into 69. Assigning multiple times wasnt covered on previous tests
addi x11,x0,148         //          Will read from 151(148+3), 2247(200+2047), 69(400-331). This is done to test offsetting
addi x12,x0,200
addi x13,x0,84
LW x11, 3(x11)
LW x12, 2047(x12)
LW x13, -15(x13)
sub x31,x5,x11           
sub x31,x2,x12           
sub x31,x3,x13          // END:

//addi x5,x0,0xF           // BEGIN:   LB: Will test Load Byte. Will save 0xABCDEF12 and read it byte per byte
//li      x5,-1412567040
//addi    x5,x5,-238      //          x5 has 0xABCDEF12 
//li      x2,-355618816
//addi    x2,x2,-1105     //          x2 has 0xEACDABAF. 0xAF will be used to replaced value on x5, becoming 0xABCDEFAF
//sb      x2,0(x5)        //          Uses SB: Extract 0xAF from x2 (0xEACDABAF) and overwrites partially x5 (0xABCDEF12) to become 0xABCDEFAF
//li      x3,-1412567040
//addi    x3,x3,-81       //          Store the expected result (0xABCDEFAF) in x3
//sub x31, x5, x3         // END:     Control varible
//lui x5, 703711          // BEGIN:   SB: Will test Store Byte, by using SB 4 times to fill a word
//addi x5, x5, -119       //          Adds 0xABCDEF89 into x5
//lui x2, 982235          //          Adds 0xEFCDAB12 into x2
//addi x2, x2, -1262
//lui    x3, 704251       //          Adds 0xABEFABEF into x3, which should be the combination of first bytes of x5,x2,x5,x2
//addi    x3, x3, -1041
//addi x11,x0,49          //          Will save byte in positions 100 (49+51), 101 (151-50), 102 and 103, which will be checked by reading word at 100
//addi x12,x0,151
//sb x5, 51(x5)           //          Store bytes 4 times, to make a full word
//sb x2, -50(x12)
//sb x5, 53(x11)
//sb x2, -48(x12)
//lw x20, 51(x5)          //          Reads the word formed
//sub x31,x3,x20          // END:     Control variblenop