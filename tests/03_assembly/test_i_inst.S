#include "test_macros.h"

TEST_I(2    , SLTI   , 100   , 10    , 0);
TEST_I(3    , SLTI   , 10    , 100   , 1);
TEST_I(4    , SLTI   , 100   , -10   , 0);
TEST_I(5    , SLTI   , 10    , -100  , 0);
TEST_I(6    , SLTI   , -10   , -100  , 0);
TEST_I(7    , SLTI   , -10   , -1    , 1);

TEST_I(8    , SLTIU  , 100          , 10    , 0);
TEST_I(9    , SLTIU  , 10           , 100   , 1);
TEST_I(10   , SLTIU  , 0xAAAAAAAA   , -2048 , 1); //-2048 is 0b 10000000 0
TEST_I(11   , SLTIU  , 0xFFFFFFFF   , -2048 , 0);//-2048 is 0b 10000000    

TEST_I(12   , XORI   , 0x0033A8FF, 0, 0x0033A8FF);

TEST_I(13   , ORI    , 0x0000000C, 10, 14);

TEST_I(14   , ANDI   , 0x0000000C, 10, 0x00000008);

///shamt
TEST_I(15   , SLLI   , 1, 4, 16);
TEST_I(16   , SLLI   , -1, 2, -4);
TEST_I(17   , SLLI   , -1, 31, -2147483648);

TEST_I(18   , SRLI   , 16, 2, 4);
TEST_I(19   , SRLI   , 0xFFFFFFFF, 4, 0x0FFFFFFF);
TEST_I(20   , SRLI   , 0x0FFFFFFF, 4, 0x00FFFFFF);
TEST_I(21   , SRLI   , 0xFFFFFFFF, 1, 0x7FFFFFFF);
TEST_I(22   , SRLI   , 0x8000004F, 4, 0x08000004);
TEST_I(23   , SRLI   , -1, 1, 2147483647);
TEST_I(24   , SRLI   , -1, 31, 1);

TEST_I(25   , SRAI   , 0x0000004F, 4, 0x4);
TEST_I(26   , SRAI   , 64, 1, 32);
TEST_I(27   , SRAI   , -64, 1, -32);
TEST_I(28   , SRAI   , 0x8000004F, 4, 0xF8000004);
TEST_I(29   , SRAI   , 0xFFFFFFFF, 1, 0xFFFFFFFF);
TEST_I(30   , SRAI   , -32, 2, -8);
