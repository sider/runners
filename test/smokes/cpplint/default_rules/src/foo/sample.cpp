/* Copyright [2020] John Doe */

#include "./utils.h"
#include "./sample.h"
#include <stdio.h>
#include <regex>

using namespace bar;

int main(void) {
  int a;   

  char b = (char)a;

  // TODO: fix this
  short c = 123;

  if (a)
  {
    func1();
  }
  else
  {
    func2();
  }

  if (a)
    func1();
  else {
    func2();
    func3();
  }

  a = func4(5, 7); // add numbers

  a = 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 0;

  int s = 10<<a;

  s = ( a + b ) * 10;

  std::string str;
  printf(str.c_str());

  while (true) {};
	// infinite loop
}
