#ifndef __TEST_MACROS
#define __TEST_MACROS

/***
 * Test macros. Verilog is configured to know that it should check result when x31 non-null.
 * When this happens, it will check if the reference value, stored on x30, matches
 * the actual values, stored on x29.
 *
 * The test ID is stored on x1.
 *
 * During jump/branch instructions, the test might jump to another test if the circuit is wrong
 * To avoid this, there is a check if the order to check results is really issued by the
 * test we think we are in.
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
    li x31, test_id;

#define TEST_I(test_id, instruction, reg_1_content, immediate_content, expected_result) \
    li x31, 0;                                                                          \
    li x1, test_id;                                                                     \
    li x2, reg_1_content;                                                               \
    instruction x29, x2, immediate_content;                                             \
    li x30, expected_result;                                                            \
    li x31, test_id;

/***
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
//
#define TEST_B(test_id, instruction, reg_1_content, reg_2_content, should_it_brach) \
    addi x31, x0, 0;                                                                \
    addi x1, x0, test_id;                                                           \
    addi x30, x0, should_it_brach;                                                  \
    addi x29, zero, 0;                                                              \
    addi x2, zero, reg_1_content;                                                   \
    addi x3, zero, reg_2_content;                                                   \
    instruction x2, x3, 12;                                                         \
    addi x31, zero, test_id;                                                        \
    beq x0, x0, 12;                                                                 \
    addi x29, zero, 1;                                                              \
    instruction x2, x3, -12;                                                        \
    addi x31, zero, test_id;

#endif