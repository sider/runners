s = Runners::Testing::Smoke

default_version = "6.25.0"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "app.java",
      location: {
        start_line: 31,
        start_column: 1,
        end_line: 58,
        end_column: 1
      },
      id: "069e8856ac66563b0c6e50b615209face9958fa7",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 28,
        tokens: 111,
        files: [
          {
            id: "e8eee93de21372ef3086ae97d2d0e998f15e96e7",
            path: "app.java",
            start_line: 1,
            start_column: 1,
            end_line: 28,
            end_column: 1
          },
          {
            id: "069e8856ac66563b0c6e50b615209face9958fa7",
            path: "app.java",
            start_line: 31,
            start_column: 1,
            end_line: 58,
            end_column: 1
          }
        ],
        codefragment: %[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]
      },
      git_blame_info: nil
    },
    {
      path: "app.java",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 28,
        end_column: 1
      },
      id: "e8eee93de21372ef3086ae97d2d0e998f15e96e7",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 28,
        tokens: 111,
        files: [
          {
            id: "e8eee93de21372ef3086ae97d2d0e998f15e96e7",
            path: "app.java",
            start_line: 1,
            start_column: 1,
            end_line: 28,
            end_column: 1
          },
          {
            id: "069e8856ac66563b0c6e50b615209face9958fa7",
            path: "app.java",
            start_line: 31,
            start_column: 1,
            end_line: 58,
            end_column: 1
          }
        ],
        codefragment: %[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "no_files",
  type: "success",
  issues: [],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "no_issues",
  type: "success",
  issues: [],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  message: "The attribute `linter.pmd_cpd.files-path` in your `sider.yml` is unsupported. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "option_files",
  type: "success",
  issues: [
    {
      path: "lib/foo/bar.java",
      location: {
        start_line: 4,
        start_column: 1,
        end_line: 31,
        end_column: 1
      },
      id: "f721b99980175debf0b6e860af6e29b43b4509b3",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 28,
        tokens: 111,
        files: [
          {
            id: "fcc107525557a97b43b555bda88b63903ac1bed0",
            path: "src/app.java",
            start_line: 1,
            start_column: 1,
            end_line: 28,
            end_column: 1
          },
          {
            id: "f721b99980175debf0b6e860af6e29b43b4509b3",
            path: "lib/foo/bar.java",
            start_line: 4,
            start_column: 1,
            end_line: 31,
            end_column: 1
          }
        ],
        codefragment: %[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]
      },
      git_blame_info: nil
    },
    {
      path: "src/app.java",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 28,
        end_column: 1
      },
      id: "fcc107525557a97b43b555bda88b63903ac1bed0",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 28,
        tokens: 111,
        files: [
          {
            id: "fcc107525557a97b43b555bda88b63903ac1bed0",
            path: "src/app.java",
            start_line: 1,
            start_column: 1,
            end_line: 28,
            end_column: 1
          },
          {
            id: "f721b99980175debf0b6e860af6e29b43b4509b3",
            path: "lib/foo/bar.java",
            start_line: 4,
            start_column: 1,
            end_line: 31,
            end_column: 1
          }
        ],
        codefragment: %[public class Main {
  public static void main(String[] args) {
    int day = 4;
    switch (day) {
      case 1:
        System.out.println("Monday");
        break;
      case 2:
        System.out.println("Tuesday");
        break;
      case 3:
        System.out.println("Wednesday");
        break;
      case 4:
        System.out.println("Thursday");
        break;
      case 5:
        System.out.println("Friday");
        break;
      case 6:
        System.out.println("Saturday");
        break;
      case 7:
        System.out.println("Sunday");
        break;
    }
  }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_language_ruby",
  type: "success",
  issues: [
    {
      path: "src/app.rb",
      location: {
        start_line: 3,
        start_column: 1,
        end_line: 14,
        end_column: 56
      },
      id: "90ee917cf8612589def4e3030d309564062cdbf8",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 12,
        tokens: 19,
        files: [
          {
            id: "b232ffb305e88308e309ab3dd3ff66e8578168b5",
            path: "foo/bar/baz/qux.rb",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 56
          },
          {
            id: "90ee917cf8612589def4e3030d309564062cdbf8",
            path: "src/app.rb",
            start_line: 3,
            start_column: 1,
            end_line: 14,
            end_column: 56
          }
        ],
        codefragment: %[def show_status_tank capacity
  case capacity
  when 0
    "You ran out of gas."
  when 1..20
    "The tank is almost empty. Quickly, find a gas station!"
  when 21..70
    "You should be ok for now."
  when 71..100
    "The tank is almost full."
  else
    "Error: capacity has an invalid value (\#{capacity})"]
      },
      git_blame_info: nil
    },
    {
      path: "foo/bar/baz/qux.rb",
      location: {
        start_line: 5,
        start_column: 1,
        end_line: 16,
        end_column: 56
      },
      id: "b232ffb305e88308e309ab3dd3ff66e8578168b5",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 12,
        tokens: 19,
        files: [
          {
            id: "b232ffb305e88308e309ab3dd3ff66e8578168b5",
            path: "foo/bar/baz/qux.rb",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 56
          },
          {
            id: "90ee917cf8612589def4e3030d309564062cdbf8",
            path: "src/app.rb",
            start_line: 3,
            start_column: 1,
            end_line: 14,
            end_column: 56
          }
        ],
        codefragment: %[def show_status_tank capacity
  case capacity
  when 0
    "You ran out of gas."
  when 1..20
    "The tank is almost empty. Quickly, find a gas station!"
  when 21..70
    "You should be ok for now."
  when 71..100
    "The tank is almost full."
  else
    "Error: capacity has an invalid value (\#{capacity})"]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_language_c",
  type: "success",
  issues: [
    {
      path: "src/fizzbuzz_2.c",
      location: {
        start_line: 11,
        start_column: 16,
        end_line: 13,
        end_column: 13
      },
      id: "3b57b2623d8a19a1a050be0ffe54d21d22cac853",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 3,
        tokens: 15,
        files: [
          {
            id: "e6fffe827f811f90be0146a87204fd27a7249d06",
            path: "src/fizzbuzz_1.c",
            start_line: 10,
            start_column: 18,
            end_line: 12,
            end_column: 15
          },
          {
            id: "3b57b2623d8a19a1a050be0ffe54d21d22cac853",
            path: "src/fizzbuzz_2.c",
            start_line: 11,
            start_column: 16,
            end_line: 13,
            end_column: 13
          }
        ],
        codefragment: %[    } else if (i % 3 == 0) {
      printf("Fizz\\n");
    } else if (i % 5 == 0) {]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_1.c",
      location: {
        start_line: 12,
        start_column: 18,
        end_line: 15,
        end_column: 20
      },
      id: "716fb07d6436e0486af893e0e93166fc06f42db9",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 4,
        tokens: 18,
        files: [
          {
            id: "716fb07d6436e0486af893e0e93166fc06f42db9",
            path: "src/fizzbuzz_1.c",
            start_line: 12,
            start_column: 18,
            end_line: 15,
            end_column: 20
          },
          {
            id: "e33562290c84ad67d2a2937738674ca7b8fb0397",
            path: "src/fizzbuzz_2.c",
            start_line: 13,
            start_column: 16,
            end_line: 16,
            end_column: 18
          }
        ],
        codefragment: %[    } else if (i % 5 == 0) {
      printf("Buzz\\n");
    } else {
      printf("%d\\n", i);]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_1.c",
      location: {
        start_line: 8,
        start_column: 25,
        end_line: 10,
        end_column: 15
      },
      id: "ab01be198edb6fa6635f534da66db0fd22928305",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 3,
        tokens: 15,
        files: [
          {
            id: "ab01be198edb6fa6635f534da66db0fd22928305",
            path: "src/fizzbuzz_1.c",
            start_line: 8,
            start_column: 25,
            end_line: 10,
            end_column: 15
          },
          {
            id: "cd80f7d3fa55dde6def3d4114931f102038a6abc",
            path: "src/fizzbuzz_2.c",
            start_line: 9,
            start_column: 23,
            end_line: 11,
            end_column: 13
          }
        ],
        codefragment: %[    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\\n");
    } else if (i % 3 == 0) {]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_2.c",
      location: {
        start_line: 9,
        start_column: 23,
        end_line: 11,
        end_column: 13
      },
      id: "cd80f7d3fa55dde6def3d4114931f102038a6abc",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 3,
        tokens: 15,
        files: [
          {
            id: "ab01be198edb6fa6635f534da66db0fd22928305",
            path: "src/fizzbuzz_1.c",
            start_line: 8,
            start_column: 25,
            end_line: 10,
            end_column: 15
          },
          {
            id: "cd80f7d3fa55dde6def3d4114931f102038a6abc",
            path: "src/fizzbuzz_2.c",
            start_line: 9,
            start_column: 23,
            end_line: 11,
            end_column: 13
          }
        ],
        codefragment: %[    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\\n");
    } else if (i % 3 == 0) {]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_2.c",
      location: {
        start_line: 13,
        start_column: 16,
        end_line: 16,
        end_column: 18
      },
      id: "e33562290c84ad67d2a2937738674ca7b8fb0397",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 4,
        tokens: 18,
        files: [
          {
            id: "716fb07d6436e0486af893e0e93166fc06f42db9",
            path: "src/fizzbuzz_1.c",
            start_line: 12,
            start_column: 18,
            end_line: 15,
            end_column: 20
          },
          {
            id: "e33562290c84ad67d2a2937738674ca7b8fb0397",
            path: "src/fizzbuzz_2.c",
            start_line: 13,
            start_column: 16,
            end_line: 16,
            end_column: 18
          }
        ],
        codefragment: %[    } else if (i % 5 == 0) {
      printf("Buzz\\n");
    } else {
      printf("%d\\n", i);]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_1.c",
      location: {
        start_line: 10,
        start_column: 18,
        end_line: 12,
        end_column: 15
      },
      id: "e6fffe827f811f90be0146a87204fd27a7249d06",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 3,
        tokens: 15,
        files: [
          {
            id: "e6fffe827f811f90be0146a87204fd27a7249d06",
            path: "src/fizzbuzz_1.c",
            start_line: 10,
            start_column: 18,
            end_line: 12,
            end_column: 15
          },
          {
            id: "3b57b2623d8a19a1a050be0ffe54d21d22cac853",
            path: "src/fizzbuzz_2.c",
            start_line: 11,
            start_column: 16,
            end_line: 13,
            end_column: 13
          }
        ],
        codefragment: %[    } else if (i % 3 == 0) {
      printf("Fizz\\n");
    } else if (i % 5 == 0) {]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_no_skip_blocks",
  type: "success",
  issues: [
    {
      path: "src/fizzbuzz.c",
      location: {
        start_line: 7,
        start_column: 3,
        end_line: 17,
        end_column: 3
      },
      id: "71df59ee3a36c5d80d35007541cdbde6fd127215",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 11,
        tokens: 78,
        files: [
          {
            id: "71df59ee3a36c5d80d35007541cdbde6fd127215",
            path: "src/fizzbuzz.c",
            start_line: 7,
            start_column: 3,
            end_line: 17,
            end_column: 3
          },
          {
            id: "7e98a5dcfadd5f7617d390c6ab4dbf2b3008fda8",
            path: "src/fizzbuzz.c",
            start_line: 20,
            start_column: 3,
            end_line: 30,
            end_column: 3
          }
        ],
        codefragment: %[  for (i = 1; i <= 100; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\\n");
    } else if (i % 3 == 0) {
      printf("Fizz\\n");
    } else if (i % 5 == 0) {
      printf("Buzz\\n");
    } else {
      printf("%d\\n", i);
    }
  }]
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz.c",
      location: {
        start_line: 20,
        start_column: 3,
        end_line: 30,
        end_column: 3
      },
      id: "7e98a5dcfadd5f7617d390c6ab4dbf2b3008fda8",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 11,
        tokens: 78,
        files: [
          {
            id: "71df59ee3a36c5d80d35007541cdbde6fd127215",
            path: "src/fizzbuzz.c",
            start_line: 7,
            start_column: 3,
            end_line: 17,
            end_column: 3
          },
          {
            id: "7e98a5dcfadd5f7617d390c6ab4dbf2b3008fda8",
            path: "src/fizzbuzz.c",
            start_line: 20,
            start_column: 3,
            end_line: 30,
            end_column: 3
          }
        ],
        codefragment: %[  for (i = 1; i <= 100; i++) {
    if (i % 3 == 0 && i % 5 == 0) {
      printf("Fizz, Buzz\\n");
    } else if (i % 3 == 0) {
      printf("Fizz\\n");
    } else if (i % 5 == 0) {
      printf("Buzz\\n");
    } else {
      printf("%d\\n", i);
    }
  }]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_encoding_success",
  type: "success",
  issues: [
    {
      path: "foo/こんにちは.sjis.cs",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 24,
        end_column: 1
      },
      id: "37f517be4959df9fb77a38308b522a24d674c0aa",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 24,
        tokens: 78,
        files: [
          {
            id: "38c21ddc22cbcd412e1ea9fcbcd91251615c75ad",
            path: "bar/baz/こんにちは.sjis.cs",
            start_line: 3,
            start_column: 1,
            end_line: 26,
            end_column: 1
          },
          {
            id: "37f517be4959df9fb77a38308b522a24d674c0aa",
            path: "foo/こんにちは.sjis.cs",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 1
          }
        ],
        codefragment: %[using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    },
    {
      path: "bar/baz/こんにちは.sjis.cs",
      location: {
        start_line: 3,
        start_column: 1,
        end_line: 26,
        end_column: 1
      },
      id: "38c21ddc22cbcd412e1ea9fcbcd91251615c75ad",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 24,
        tokens: 78,
        files: [
          {
            id: "38c21ddc22cbcd412e1ea9fcbcd91251615c75ad",
            path: "bar/baz/こんにちは.sjis.cs",
            start_line: 3,
            start_column: 1,
            end_line: 26,
            end_column: 1
          },
          {
            id: "37f517be4959df9fb77a38308b522a24d674c0aa",
            path: "foo/こんにちは.sjis.cs",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 1
          }
        ],
        codefragment: %[using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message: "Skipping ./bar/hello.eucjp.cs. Reason: Lexical error in file ./bar/hello.eucjp.cs at line 20, column 13.  Encountered: token recognition error at: '｣'",
      file: nil
    }
  ],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_encoding_error",
  type: "error",
  class: "Runners::Shell::ExecError",
  backtrace: :_,
  inspect: :_,
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_skip_duplicate_files",
  type: "success",
  issues: [
    {
      path: "foo/こんにちは.2.eucjp.cs",
      location: {
        start_line: 16,
        start_column: 1,
        end_line: 30,
        end_column: 1
      },
      id: "2daa6f2b2f344ac293767c7ddd0f2090538cce9b",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 36,
        files: [
          {
            id: "2daa6f2b2f344ac293767c7ddd0f2090538cce9b",
            path: "foo/こんにちは.2.eucjp.cs",
            start_line: 16,
            start_column: 1,
            end_line: 30,
            end_column: 1
          },
          {
            id: "408776ef9c22448f623aae1a15f82cab1d133846",
            path: "bar/こんにちは.1.eucjp.cs",
            start_line: 14,
            start_column: 1,
            end_line: 28,
            end_column: 1
          }
        ],
        codefragment: %[namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    },
    {
      path: "bar/こんにちは.1.eucjp.cs",
      location: {
        start_line: 14,
        start_column: 1,
        end_line: 28,
        end_column: 1
      },
      id: "408776ef9c22448f623aae1a15f82cab1d133846",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 36,
        files: [
          {
            id: "2daa6f2b2f344ac293767c7ddd0f2090538cce9b",
            path: "foo/こんにちは.2.eucjp.cs",
            start_line: 16,
            start_column: 1,
            end_line: 30,
            end_column: 1
          },
          {
            id: "408776ef9c22448f623aae1a15f82cab1d133846",
            path: "bar/こんにちは.1.eucjp.cs",
            start_line: 14,
            start_column: 1,
            end_line: 28,
            end_column: 1
          }
        ],
        codefragment: %[namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message: "Skipping bar/こんにちは.2.eucjp.cs since it appears to be a duplicate file and --skip-duplicate-files is set",
      file: nil
    },
    {
      message: "Skipping baz/こんにちは.2.eucjp.cs since it appears to be a duplicate file and --skip-duplicate-files is set",
      file: nil
    }
  ],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_language_java",
  type: "success",
  issues: [
    {
      path: "jp/MyAppJp.java",
      location: {
        start_line: 3,
        start_column: 1,
        end_line: 42,
        end_column: 1
      },
      id: "bdb8c726d714be749ee35093e72d1472249215b6",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 40,
        tokens: 110,
        files: [
          {
            id: "bdb8c726d714be749ee35093e72d1472249215b6",
            path: "jp/MyAppJp.java",
            start_line: 3,
            start_column: 1,
            end_line: 42,
            end_column: 1
          },
          {
            id: "e5d36afbb6911b96a9e52d77388c9cad9c3cedf0",
            path: "MyApp.java",
            start_line: 1,
            start_column: 1,
            end_line: 40,
            end_column: 1
          }
        ],
        codefragment: %[public class MyAppJp {
  public static void main(String[] args) {
    String str;
    int day = 5;
    switch (day) {
      case 1:
        str = "月曜日";
        break;
      case 2:
        str = "火曜日";
        break;
      case 3:
        str = "水曜日";
        break;
      case 4:
        str = "木曜日";
        break;
      case 5:
        str = "金曜日";
        break;
      case 6:
        str = "土曜日";
        break;
      case 7:
        str = "日曜日";
        break;
      default:
        str = null;
        break;
    }

    System.out.println(str);
  }

  @Deprecated
  private static void Foo(String text)
  {
    System.out.println(text);
  }
}]
      },
      git_blame_info: nil
    },
    {
      path: "MyApp.java",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 40,
        end_column: 1
      },
      id: "e5d36afbb6911b96a9e52d77388c9cad9c3cedf0",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 40,
        tokens: 110,
        files: [
          {
            id: "bdb8c726d714be749ee35093e72d1472249215b6",
            path: "jp/MyAppJp.java",
            start_line: 3,
            start_column: 1,
            end_line: 42,
            end_column: 1
          },
          {
            id: "e5d36afbb6911b96a9e52d77388c9cad9c3cedf0",
            path: "MyApp.java",
            start_line: 1,
            start_column: 1,
            end_line: 40,
            end_column: 1
          }
        ],
        codefragment: %[public class MyAppJp {
  public static void main(String[] args) {
    String str;
    int day = 5;
    switch (day) {
      case 1:
        str = "月曜日";
        break;
      case 2:
        str = "火曜日";
        break;
      case 3:
        str = "水曜日";
        break;
      case 4:
        str = "木曜日";
        break;
      case 5:
        str = "金曜日";
        break;
      case 6:
        str = "土曜日";
        break;
      case 7:
        str = "日曜日";
        break;
      default:
        str = null;
        break;
    }

    System.out.println(str);
  }

  @Deprecated
  private static void Foo(String text)
  {
    System.out.println(text);
  }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "warnings",
  type: "success",
  issues: [
    {
      path: "src/bar/こんにちは.1.sjis.cs",
      location: {
        start_line: 12,
        start_column: 1,
        end_line: 26,
        end_column: 1
      },
      id: "0d0169de6995b44aca9b1860372a6428bf67faa7",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 36,
        files: [
          {
            id: "300265fa853e0451e5b3898d13088549b0ed6709",
            path: "src/foo/こんにちは.2.sjis.cs",
            start_line: 12,
            start_column: 1,
            end_line: 26,
            end_column: 1
          },
          {
            id: "0d0169de6995b44aca9b1860372a6428bf67faa7",
            path: "src/bar/こんにちは.1.sjis.cs",
            start_line: 12,
            start_column: 1,
            end_line: 26,
            end_column: 1
          }
        ],
        codefragment: %[namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/こんにちは.2.sjis.cs",
      location: {
        start_line: 12,
        start_column: 1,
        end_line: 26,
        end_column: 1
      },
      id: "300265fa853e0451e5b3898d13088549b0ed6709",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 36,
        files: [
          {
            id: "300265fa853e0451e5b3898d13088549b0ed6709",
            path: "src/foo/こんにちは.2.sjis.cs",
            start_line: 12,
            start_column: 1,
            end_line: 26,
            end_column: 1
          },
          {
            id: "0d0169de6995b44aca9b1860372a6428bf67faa7",
            path: "src/bar/こんにちは.1.sjis.cs",
            start_line: 12,
            start_column: 1,
            end_line: 26,
            end_column: 1
          }
        ],
        codefragment: %[namespace MyApp
{
    public class Hello
    {
        public static void Main()
        {
            今日は世界();
        }

        private static void 今日は世界()
        {
            Console.WriteLine("今日は, 世界!");
        }
    }
}]
      },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message: "Skipping src/bar/baz/こんにちは.1.eucjp.cs. Reason: Lexical error in file src/bar/baz/こんにちは.1.eucjp.cs at line 20, column 13.  Encountered: token recognition error at: '｣'",
      file: nil
    },
    {
      message: "Skipping src/bar/こんにちは.2.sjis.cs since it appears to be a duplicate file and --skip-duplicate-files is set",
      file: nil
    },
    {
      message: "Skipping src/baz/こんにちは.2.sjis.cs since it appears to be a duplicate file and --skip-duplicate-files is set",
      file: nil
    }
  ],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_multiple_languages_default",
  type: "success",
  issues: [
    {
      path: "bar/hello_cpp.cpp",
      location: {
        start_line: 3,
        start_column: 1,
        end_line: 17,
        end_column: 1
      },
      id: "1043fd82f4219d1d06a380cba3b5dd68f6a29c9c",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 30,
        files: [
          {
            id: "1043fd82f4219d1d06a380cba3b5dd68f6a29c9c",
            path: "bar/hello_cpp.cpp",
            start_line: 3,
            start_column: 1,
            end_line: 17,
            end_column: 1
          },
          {
            id: "f596d2f766fb7b912331c3691b493b5d028f8ce3",
            path: "foo/hello_cpp.cpp",
            start_line: 3,
            start_column: 1,
            end_line: 17,
            end_column: 1
          }
        ],
        codefragment: /void print_hello\(\);/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_ecmascript.js",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 5,
        end_column: 14
      },
      id: "2313e91e4b39484760de0c6a7de02d9fcd7db381",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 5,
        tokens: 17,
        files: [
          {
            id: "55adda2f9e7939504b6d9938a16422894b054888",
            path: "bar/hello_ecmascript.js",
            start_line: 1,
            start_column: 1,
            end_line: 5,
            end_column: 14
          },
          {
            id: "2313e91e4b39484760de0c6a7de02d9fcd7db381",
            path: "foo/hello_ecmascript.js",
            start_line: 1,
            start_column: 1,
            end_line: 5,
            end_column: 14
          }
        ],
        codefragment: /function print_hello\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_java.java",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 13,
        end_column: 1
      },
      id: "34a7cda47c1a5be96dc3077987747cfcab326455",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 13,
        tokens: 35,
        files: [
          {
            id: "34a7cda47c1a5be96dc3077987747cfcab326455",
            path: "bar/hello_java.java",
            start_line: 1,
            start_column: 1,
            end_line: 13,
            end_column: 1
          },
          {
            id: "59d1a6ee4579c0bb7c7abecf5c0aaa006988b5e4",
            path: "foo/hello_java.java",
            start_line: 1,
            start_column: 1,
            end_line: 13,
            end_column: 1
          }
        ],
        codefragment: /class TestJp/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_php.php",
      location: {
        start_line: 1,
        end_line: 8
      },
      id: "3f18338e7a3124257c7b1424604e3386e6808bc4",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 8,
        tokens: 57,
        files: [
          {
            id: "816e15083fd49ae7bd01aee5f5a979978f6f7b84",
            path: "bar/hello_php.php",
            start_line: 1,
            start_column: nil,
            end_line: 8,
            end_column: nil
          },
          {
            id: "3f18338e7a3124257c7b1424604e3386e6808bc4",
            path: "foo/hello_php.php",
            start_line: 1,
            start_column: nil,
            end_line: 8,
            end_column: nil
          }
        ],
        codefragment: /<\?php/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_kotlin.kt",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 1
      },
      id: "551c2990310dfc0c56a00a83d7e2b3010de61732",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 27,
        files: [
          {
            id: "b9f17da21dec2181d8a7eb66b611362fc525aa11",
            path: "bar/hello_kotlin.kt",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          },
          {
            id: "551c2990310dfc0c56a00a83d7e2b3010de61732",
            path: "foo/hello_kotlin.kt",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          }
        ],
        codefragment: /fun main\(args: Array<String>\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_ecmascript.js",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 5,
        end_column: 14
      },
      id: "55adda2f9e7939504b6d9938a16422894b054888",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 5,
        tokens: 17,
        files: [
          {
            id: "55adda2f9e7939504b6d9938a16422894b054888",
            path: "bar/hello_ecmascript.js",
            start_line: 1,
            start_column: 1,
            end_line: 5,
            end_column: 14
          },
          {
            id: "2313e91e4b39484760de0c6a7de02d9fcd7db381",
            path: "foo/hello_ecmascript.js",
            start_line: 1,
            start_column: 1,
            end_line: 5,
            end_column: 14
          }
        ],
        codefragment: /function print_hello\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_java.java",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 13,
        end_column: 1
      },
      id: "59d1a6ee4579c0bb7c7abecf5c0aaa006988b5e4",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 13,
        tokens: 35,
        files: [
          {
            id: "34a7cda47c1a5be96dc3077987747cfcab326455",
            path: "bar/hello_java.java",
            start_line: 1,
            start_column: 1,
            end_line: 13,
            end_column: 1
          },
          {
            id: "59d1a6ee4579c0bb7c7abecf5c0aaa006988b5e4",
            path: "foo/hello_java.java",
            start_line: 1,
            start_column: 1,
            end_line: 13,
            end_column: 1
          }
        ],
        codefragment: /class TestJp/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_go.go",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 10,
        end_column: 1
      },
      id: "7e380f221fcff72d4568a72141e1a29d1acf9ba4",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 10,
        tokens: 25,
        files: [
          {
            id: "b132dc6bb149c3edce143b36ae2eb9245eea4e81",
            path: "bar/hello_go.go",
            start_line: 1,
            start_column: 1,
            end_line: 10,
            end_column: 1
          },
          {
            id: "7e380f221fcff72d4568a72141e1a29d1acf9ba4",
            path: "foo/hello_go.go",
            start_line: 1,
            start_column: 1,
            end_line: 10,
            end_column: 1
          }
        ],
        codefragment: /package main/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_php.php",
      location: {
        start_line: 1,
        end_line: 8
      },
      id: "816e15083fd49ae7bd01aee5f5a979978f6f7b84",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 8,
        tokens: 57,
        files: [
          {
            id: "816e15083fd49ae7bd01aee5f5a979978f6f7b84",
            path: "bar/hello_php.php",
            start_line: 1,
            start_column: nil,
            end_line: 8,
            end_column: nil
          },
          {
            id: "3f18338e7a3124257c7b1424604e3386e6808bc4",
            path: "foo/hello_php.php",
            start_line: 1,
            start_column: nil,
            end_line: 8,
            end_column: nil
          }
        ],
        codefragment: /<\?php/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_ruby.rb",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 24,
        end_column: 4
      },
      id: "936520f0ce1feec8bd0ebcaab536888c2268f715",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 24,
        tokens: 27,
        files: [
          {
            id: "936520f0ce1feec8bd0ebcaab536888c2268f715",
            path: "bar/hello_ruby.rb",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 4
          },
          {
            id: "dee764319f0b6fe2d4ff23925c5ab296c779ca14",
            path: "foo/hello_ruby.rb",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 4
          }
        ],
        codefragment: /def main\(\)/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_cs.cs",
      location: {
        start_line: 5,
        start_column: 1,
        end_line: 16,
        end_column: 1
      },
      id: "a3ae806ca52225161be17832b2b18cc24a24d09d",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 12,
        tokens: 38,
        files: [
          {
            id: "a3ae806ca52225161be17832b2b18cc24a24d09d",
            path: "bar/hello_cs.cs",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 1
          },
          {
            id: "ff532463942827ebfcbe38b1f1c34924421d13ef",
            path: "foo/hello_cs.cs",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 1
          }
        ],
        codefragment: /public class Test/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_python.py",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 6
      },
      id: "a6ab9a2c09efa41b65880070942ddf9d8606b2f9",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 20,
        files: [
          {
            id: "a6ab9a2c09efa41b65880070942ddf9d8606b2f9",
            path: "bar/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          },
          {
            id: "c78059bc1c128c7f394e24848ba626ea6983bcb8",
            path: "foo/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          }
        ],
        codefragment: /def main\(\):/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_go.go",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 10,
        end_column: 1
      },
      id: "b132dc6bb149c3edce143b36ae2eb9245eea4e81",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 10,
        tokens: 25,
        files: [
          {
            id: "b132dc6bb149c3edce143b36ae2eb9245eea4e81",
            path: "bar/hello_go.go",
            start_line: 1,
            start_column: 1,
            end_line: 10,
            end_column: 1
          },
          {
            id: "7e380f221fcff72d4568a72141e1a29d1acf9ba4",
            path: "foo/hello_go.go",
            start_line: 1,
            start_column: 1,
            end_line: 10,
            end_column: 1
          }
        ],
        codefragment: /package main/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_kotlin.kt",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 1
      },
      id: "b9f17da21dec2181d8a7eb66b611362fc525aa11",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 27,
        files: [
          {
            id: "b9f17da21dec2181d8a7eb66b611362fc525aa11",
            path: "bar/hello_kotlin.kt",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          },
          {
            id: "551c2990310dfc0c56a00a83d7e2b3010de61732",
            path: "foo/hello_kotlin.kt",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          }
        ],
        codefragment: /fun main\(args: Array<String>\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_python.py",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 6
      },
      id: "c78059bc1c128c7f394e24848ba626ea6983bcb8",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 20,
        files: [
          {
            id: "a6ab9a2c09efa41b65880070942ddf9d8606b2f9",
            path: "bar/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          },
          {
            id: "c78059bc1c128c7f394e24848ba626ea6983bcb8",
            path: "foo/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          }
        ],
        codefragment: /def main\(\):/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_swift.swift",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 9,
        end_column: 6
      },
      id: "c89018422ac15c0d1fc595195903c7c65371fac3",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 9,
        tokens: 22,
        files: [
          {
            id: "f9bbe8b502aaa2f832bb2bd8cab6377172077bd7",
            path: "bar/hello_swift.swift",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          },
          {
            id: "c89018422ac15c0d1fc595195903c7c65371fac3",
            path: "foo/hello_swift.swift",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          }
        ],
        codefragment: /func main\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_ruby.rb",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 24,
        end_column: 4
      },
      id: "dee764319f0b6fe2d4ff23925c5ab296c779ca14",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 24,
        tokens: 27,
        files: [
          {
            id: "936520f0ce1feec8bd0ebcaab536888c2268f715",
            path: "bar/hello_ruby.rb",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 4
          },
          {
            id: "dee764319f0b6fe2d4ff23925c5ab296c779ca14",
            path: "foo/hello_ruby.rb",
            start_line: 1,
            start_column: 1,
            end_line: 24,
            end_column: 4
          }
        ],
        codefragment: /def main\(\)/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_cpp.cpp",
      location: {
        start_line: 3,
        start_column: 1,
        end_line: 17,
        end_column: 1
      },
      id: "f596d2f766fb7b912331c3691b493b5d028f8ce3",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 15,
        tokens: 30,
        files: [
          {
            id: "1043fd82f4219d1d06a380cba3b5dd68f6a29c9c",
            path: "bar/hello_cpp.cpp",
            start_line: 3,
            start_column: 1,
            end_line: 17,
            end_column: 1
          },
          {
            id: "f596d2f766fb7b912331c3691b493b5d028f8ce3",
            path: "foo/hello_cpp.cpp",
            start_line: 3,
            start_column: 1,
            end_line: 17,
            end_column: 1
          }
        ],
        codefragment: /void print_hello\(\);/
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_swift.swift",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 9,
        end_column: 6
      },
      id: "f9bbe8b502aaa2f832bb2bd8cab6377172077bd7",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 9,
        tokens: 22,
        files: [
          {
            id: "f9bbe8b502aaa2f832bb2bd8cab6377172077bd7",
            path: "bar/hello_swift.swift",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          },
          {
            id: "c89018422ac15c0d1fc595195903c7c65371fac3",
            path: "foo/hello_swift.swift",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          }
        ],
        codefragment: /func main\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_cs.cs",
      location: {
        start_line: 5,
        start_column: 1,
        end_line: 16,
        end_column: 1
      },
      id: "ff532463942827ebfcbe38b1f1c34924421d13ef",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 12,
        tokens: 38,
        files: [
          {
            id: "a3ae806ca52225161be17832b2b18cc24a24d09d",
            path: "bar/hello_cs.cs",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 1
          },
          {
            id: "ff532463942827ebfcbe38b1f1c34924421d13ef",
            path: "foo/hello_cs.cs",
            start_line: 5,
            start_column: 1,
            end_line: 16,
            end_column: 1
          }
        ],
        codefragment: /public class Test/
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_multiple_languages",
  type: "success",
  issues: [
    {
      path: "src/bar/hello_dart.dart",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 1
      },
      id: "24e1fe0d195a05c3f08be9162af15df810755211",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 19,
        files: [
          {
            id: "24e1fe0d195a05c3f08be9162af15df810755211",
            path: "src/bar/hello_dart.dart",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          },
          {
            id: "8b7407bcff2b251861c4454c59c29184b78750e9",
            path: "src/foo/hello_dart.dart",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          }
        ],
        codefragment: /void main\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_python.py",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 6
      },
      id: "266f2b1a5dc72b41758be1aca2ebea206ea4cf24",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 20,
        files: [
          {
            id: "71b080e1acdb056e1b06047b5a2d252422607322",
            path: "src/bar/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          },
          {
            id: "266f2b1a5dc72b41758be1aca2ebea206ea4cf24",
            path: "src/foo/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          }
        ],
        codefragment: /def main\(\):/
      },
      git_blame_info: nil
    },
    {
      path: "src/bar/hello_python.py",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 6
      },
      id: "71b080e1acdb056e1b06047b5a2d252422607322",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 20,
        files: [
          {
            id: "71b080e1acdb056e1b06047b5a2d252422607322",
            path: "src/bar/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          },
          {
            id: "266f2b1a5dc72b41758be1aca2ebea206ea4cf24",
            path: "src/foo/hello_python.py",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 6
          }
        ],
        codefragment: /def main\(\):/
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_dart.dart",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 7,
        end_column: 1
      },
      id: "8b7407bcff2b251861c4454c59c29184b78750e9",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 7,
        tokens: 19,
        files: [
          {
            id: "24e1fe0d195a05c3f08be9162af15df810755211",
            path: "src/bar/hello_dart.dart",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          },
          {
            id: "8b7407bcff2b251861c4454c59c29184b78750e9",
            path: "src/foo/hello_dart.dart",
            start_line: 1,
            start_column: 1,
            end_line: 7,
            end_column: 1
          }
        ],
        codefragment: /void main\(\) \{/
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_lua.lua",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 9,
        end_column: 6
      },
      id: "b4b263f2acec2d1721e04791c768966feedb8080",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 9,
        tokens: 18,
        files: [
          {
            id: "b66bcfec6a73c25cbc233365326fb4bad4f39f5e",
            path: "src/bar/hello_lua.lua",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          },
          {
            id: "b4b263f2acec2d1721e04791c768966feedb8080",
            path: "src/foo/hello_lua.lua",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          }
        ],
        codefragment: /function main\(\)/
      },
      git_blame_info: nil
    },
    {
      path: "src/bar/hello_lua.lua",
      location: {
        start_line: 1,
        start_column: 1,
        end_line: 9,
        end_column: 6
      },
      id: "b66bcfec6a73c25cbc233365326fb4bad4f39f5e",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 9,
        tokens: 18,
        files: [
          {
            id: "b66bcfec6a73c25cbc233365326fb4bad4f39f5e",
            path: "src/bar/hello_lua.lua",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          },
          {
            id: "b4b263f2acec2d1721e04791c768966feedb8080",
            path: "src/foo/hello_lua.lua",
            start_line: 1,
            start_column: 1,
            end_line: 9,
            end_column: 6
          }
        ],
        codefragment: /function main\(\)/
      },
      git_blame_info: nil
    }
  ],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)

s.add_test(
  "option_multiple_languages_invalid",
  type: "failure",
  message: "The value of the attribute `linter.pmd_cpd.language` in your `sider.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "option_multiple_languages_available",
  type: "success",
  issues: [],
  warnings: [],
  analyzer: { name: "PMD CPD", version: default_version }
)
