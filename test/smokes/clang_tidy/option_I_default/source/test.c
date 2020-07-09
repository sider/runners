#include "baz/myinclude/example1.H"
#include <readline/readline.h>
#include "example2.H++"
#include "test.h"

int foo()
{
  const char *s;
  const char *t = s;
  const char *v = u; /* u is defined in test.tpp */
  return 0;
}
