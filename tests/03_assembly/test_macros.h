#ifndef __TEST_MACROS
#define __TEST_MACROS

#define TEST_R(test_id, instruction, reg_1_content, reg_2_content, expected_result) \
    addi x31, x0, 0;                                                                \
    li x1, test_id;                                                                 \
    li x2, expected_result;                                                         \
    li x3, reg_1_content;                                                           \
    li x4, reg_2_content;                                                           \
    instruction x5, x3, x4;                                                         \
    sub x31, x5, x2 // Verilog testbench is configured to detect x31=0 as a sign of passing.
                    // For debug, to get the generated value, set expected to zero
#endif