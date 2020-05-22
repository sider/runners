#include "bad.h"

void foo(void)
{
  int i;
  for(i = 0; i < 10; i++)
  {
    if(misra_5_2_func3())
    {
      int misra_5_2_var_hides_var_1____31x;
    }
  }
}