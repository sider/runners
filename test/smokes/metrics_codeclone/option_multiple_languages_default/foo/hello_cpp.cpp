#include <stdio.h>

void print_hello();

int main(void)
{
    print_hello();
    return 0;
}

void print_hello()
{
#ifdef TEST
    int foo;
#endif
    puts("Hello, world!");
}
