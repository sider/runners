#include <stdio.h>

void fizzbuzz(int n)
{
  if (n > 1) {
    fizzbuzz(n-1);
  }

  if (n % 3 == 0 && n % 5 == 0) {
    printf("Fizz, Buzz\n");
  } else if (n % 3 == 0) {
    printf("Fizz\n");
  } else if (n % 5 == 0) {
    printf("Buzz\n");
  } else {
    printf("%d\n", n);
  }

#ifdef TEST
  if (n % 3 == 0 && n % 5 == 0) {
    printf("Fizz, Buzz\n");
  } else if (n % 3 == 0) {
    printf("Fizz\n");
  } else if (n % 5 == 0) {
    printf("Buzz\n");
  } else {
    printf("%d\n", n);
  }
#endif
}

int main(void)
{
  fizzbuzz(100);

  return 0;
}
