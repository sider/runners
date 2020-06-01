// sample file
#include <stdio.h>

extern int func1();
extern int func2();

void func0(void)
{
  int i, j;
  switch(func1())
  {
    case 1:
    {
      for(i = 0; i < 10; i++)
      {
        if(func2())
        {
          j = i + 1;
        }
      }
    }
  }
}
