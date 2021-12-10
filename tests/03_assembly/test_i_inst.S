#include "test_macros.h"

TEST_I(1    , SLTI   , 100, 10, 0);
TEST_I(2    , SLTI   , 10, 100, 1);
TEST_I(3    , SLTI   , 100, -10, 0);
TEST_I(4    , SLTI   , 100, -1000, 0);
TEST_I(5    , SLTI   , -10, -100, 0);
TEST_I(6    , SLTI   , -10, -1, 1);
TEST_I(7    , SLTI   , -10, 1, 1);
TEST_I(8    , SLTI   , -10, 100, 1);
TEST_I(9    , SLTI   , -10, -10, 0);
TEST_I(10   , SLTI   , 10, 10, 0);

TEST_I(11    , SLTIU   , 100,           10,     0);
TEST_I(12    , SLTIU   , 10,            100,    1);
TEST_I(13    , SLTIU   , 0x00000000,    0,      0);
TEST_I(14    , SLTIU   , 0x00000000,    2047,   1);
TEST_I(15    , SLTIU   , 0x00000000,    -2048,  1);
TEST_I(16    , SLTIU   , 0xFFFFFFFF,    2047,   0);
TEST_I(17    , SLTIU   , 0xFFFFFFFF,    -2048,  0);
TEST_I(18    , SLTIU   , 0xFFFFFFFF,    0,      0);
TEST_I(19    , SLTIU   , 0xFAAAAAAA,    -2048,  1);
TEST_I(20    , SLTIU   , 0xFAAAAAAA,    2047,   0);
TEST_I(21    , SLTIU   , 0x7AAAAAAA,    2047,   0);
TEST_I(21    , SLTIU   , 0x7AAAAAAA,    -2048,  1);