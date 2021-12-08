#ifndef __TEST_MACROS
#define __TEST_MACROS

#define TEST_R(test_id, instruction, val1, val2, expected_result) \
    addi x31, x0, 0;                                              \
    li x1, test_id;                                               \
    li x2, expected_result;                                       \
    li x3, val1;                                                  \
    li x4, val2;                                                  \
    instruction x5, x3, x4;                                       \
    sub x31, x2, x5 // Verilog testbench is configured to detect x31=0 as a sign of passing.

#endif