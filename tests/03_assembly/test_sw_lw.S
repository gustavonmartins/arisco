
#include "test_macros.h"

TEST_SW_LW(1, 3, 1024, 0, 1024, 0)
TEST_SW_LW(2, 5, 2047, 453, 4548, -2048)
TEST_SW_LW(3, 7, 4548, -2048, 2047, 453)

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