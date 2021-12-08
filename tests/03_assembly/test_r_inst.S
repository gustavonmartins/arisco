
#include "test_macros.h"

TEST_R(1    , AND   , 0xABCDEF09, 0x0F0F0F0F, 0x0B0D0F09);

TEST_R(2    , OR    , 0xABCDEF09, 0x0F0F0F0F, 0xAFCFEF0F);

TEST_R(3    , XOR   , 0x0033A8FF, 0x0F0F0F8F, 0x0F3CA770);

TEST_R(4    , SLL   , 0xABCDEF09, 4, 0xBCDEF090);

TEST_R(5    , SLT   , 100   , 10    , 0);
TEST_R(6    , SLT   , 10    , 100   , 1);
TEST_R(7    , SLT   , 100   , -10   , 0);
TEST_R(8    , SLT   , 10    , -100  , 0);
TEST_R(9    , SLT   , -10   , -100  , 0);
TEST_R(10   , SLT   , -10   , -1    , 1);

