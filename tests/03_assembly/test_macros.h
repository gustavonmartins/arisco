#ifndef __TEST_MACROS
#define __TEST_MACROS

/***
 * Test macros. Verilog is configured to know that it should check result when x31 is 1.
 * When this happens, it will check if the reference value, stored on x30, matches
 * the actual values, stored on x29.
 *
 * The test ID is stored on x1.
 *
 */
//
#define TEST_R(test_id, instruction, reg_1_content, reg_2_content, expected_result) \
    li x31, 0;                                                                      \
    li x1, test_id;                                                                 \
    li x2, reg_1_content;                                                           \
    li x3, reg_2_content;                                                           \
    instruction x29, x2, x3;                                                        \
    li x30, expected_result;                                                        \
    li x31, 1;

#define TEST_I(test_id, instruction, reg_1_content, immediate_content, expected_result) \
    li x31, 0;                                                                          \
    li x1, test_id;                                                                     \
    li x2, reg_1_content;                                                               \
    instruction x29, x2, immediate_content;                                             \
    li x30, expected_result;                                                            \
    li x31, 1;
#endif