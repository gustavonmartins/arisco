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
TEST_I(10    , SLTI   , 10, 10, 0);