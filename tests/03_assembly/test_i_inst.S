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