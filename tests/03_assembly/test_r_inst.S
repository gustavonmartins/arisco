
#include "test_macros.h"

TEST_R(1    , SLL   , 0xABCDEF09, 4, 0xBCDEF090);

TEST_R(2    , SLT   , 100   , 10    , 0);
TEST_R(3    , SLT   , 10    , 100   , 1);
TEST_R(4    , SLT   , 100   , -10   , 0);
TEST_R(5    , SLT   , 10    , -100  , 0);
TEST_R(6    , SLT   , -10   , -100  , 0);
TEST_R(7    , SLT   , -10   , -1    , 1);

TEST_R(8    , SLTU   , 0xFFFFFFFF    , 0xFFFFFFFF   , 0);
TEST_R(9    , SLTU   , 0xFFFFFFF1    , 0xFFFFFFF2   , 1);
TEST_R(10   , SLTU   , 0x0FFFFFFF    , 0x0FFFFFFE   , 0);

TEST_R(11   , XOR   , 0x0033A8FF, 0x0F0F0F8F, 0x0F3CA770);

TEST_R(12   , SRL   , 0xABCDEF09    , 4             , 0x0ABCDEF0);
TEST_R(13   , SRL   , 0xFFFFFFFF    , 31            , 0x1);
TEST_R(14   , SRL   , 0xFFFFFFFF    , 32            , 0x0);
TEST_R(15   , SRL   , 0xFFFFFFFF    , 33            , 0x0);

TEST_R(16   , SRA   , 32            , 2             , 8);
TEST_R(17   , SRA   , 0x800000E0    , 4             , 0xF800000E );
TEST_R(18   , SRA   , -128          , 5             , -4);

TEST_R(19   , OR    , 0xABCDEF09, 0x0F0F0F0F, 0xAFCFEF0F);

TEST_R(20   , AND   , 0xABCDEF09, 0x0F0F0F0F, 0x0B0D0F09);









