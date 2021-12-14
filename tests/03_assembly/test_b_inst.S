#include "test_macros.h"

/**
i1
i2 should jump to m1 now
i3 if reaches this instead of m1, didnt branch. fail
i4 : collect proof that it was in m1. if ok, pass. otherwise, fail
i5 : jumps to end of test
i...
m1:  should arrive here from i2 and get a proof that was here. proof can be setting a variable
i6: jump to i4
i7: if reaches this instead of jumping back, fail.
*/

addi x31,zero,0             // Sets test begin
addi x1,zero, 1             // test_id
addi x30,zero, 3            // sets accepted proof code
addi x29,zero, 7            //system gets invalid proof code by default

addi x2,zero, 11            //numbers to compare
addi x3,zero, 11            //numbers to compare

beq x2, x3, 8               //i2. jump to m1
addi x31,zero,1             //i4=m3. Final pass or fail
beq x0,x0,8                 //i5 jumps to test end
addi x29,zero,3             //m1. Gets proof to show to i4=m3
beq x2,x3,-16               //i6. jump to i4
addi x31,zero,1             //i7. Fail if reaches here, END OF TEST

TEST_B(2, beq, 2047, -2048, 0)
TEST_B(3, beq, -2048, -2048, 1)

TEST_B(4, bne, -1024, 2047, 1)
TEST_B(5, bne, -2048, -2048, 0)

TEST_B(6, blt, -512, 32, 1)
TEST_B(7, blt, -512, -512, 0)

TEST_B(8, bge, -512, -1024, 1)
TEST_B(9, bge, -512, -512, 1)
TEST_B(10, bge, -512, 32, 0)

TEST_B(11, bltu, -1, 32, 0)
TEST_B(12, bltu, 32, -1, 1)
TEST_B(13, bltu, -10, -1, 1)
TEST_B(14, bltu, -1, -10, 0)
TEST_B(15, bltu, 1, -1, 1)
TEST_B(16, bltu, -1, 1, 0)

TEST_B(17, bgeu, 100, 10, 1)
TEST_B(18, bgeu, 0, 100, 0)
TEST_B(19, bgeu, -1, 10, 1)
TEST_B(20, bgeu, 10, -1, 0)