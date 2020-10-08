#ifndef SAMPLE_H_
#define SAMPLE_H_

#include <stdio.h>
#include "utils.h"
std::vector<int> foo;

extern void func1();
extern void func2();
extern void func3();
extern int func4(int a, int b);

namespace bar {
class Foo {
  Foo(int i);

};

void Func(int& i);

class Baz {
  public:
    void Func();
};
}

#endif
