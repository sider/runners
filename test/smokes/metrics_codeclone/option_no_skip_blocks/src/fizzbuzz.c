#include <stdio.h>

int main(void)
{
  int i;

  for (i = 1; i <= 100; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\n");
    } else if (i % 3 == 0) {
      printf("Fizz\n");
    } else if (i % 5 == 0) {
      printf("Buzz\n");
    } else {
      printf("%d\n", i);
    }
  }

#if 0
  for (i = 1; i <= 100; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\n");
    } else if (i % 3 == 0) {
      printf("Fizz\n");
    } else if (i % 5 == 0) {
      printf("Buzz\n");
    } else {
      printf("%d\n", i);
    }
  }
#endif

  return 0;
}
