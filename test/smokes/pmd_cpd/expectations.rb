s = Runners::Testing::Smoke

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
  analyzer: { name: "PMD CPD", version: "6.23.0" }
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  message: "The attribute `$.linter.pmd_cpd.files-path` in your `sider.yml` is unsupported. Please fix and retry.",
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
  analyzer: { name: "PMD CPD", version: "6.23.0" }
)

s.add_test(
  "option_language_ruby",
  type: "success",
  issues: [
    {
      path: "app.rb",
      location: {
        start_line: 16,
        end_line: 29
      },
      id: "4a336bed0551258d443c4e061bcc219ca326783c",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 14,
        tokens: 58,
        files: [
          {
            id: "54a4099b5fbb00635c59fc0c0ee8fa3ab711ad76",
            path: "app.rb",
            start_line: 1,
            start_column: nil,
            end_line: 14,
            end_column: nil
          },
          {
            id: "4a336bed0551258d443c4e061bcc219ca326783c",
            path: "app.rb",
            start_line: 16,
            start_column: nil,
            end_line: 29,
            end_column: nil
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
    "Error: capacity has an invalid value (\#{capacity})"
  end
end]
      },
      git_blame_info: nil
    },
    {
      path: "app.rb",
      location: {
        start_line: 1,
        end_line: 14
      },
      id: "54a4099b5fbb00635c59fc0c0ee8fa3ab711ad76",
      message: "Code duplications found (2 occurrences).",
      links: [],
      object: {
        lines: 14,
        tokens: 58,
        files: [
          {
            id: "54a4099b5fbb00635c59fc0c0ee8fa3ab711ad76",
            path: "app.rb",
            start_line: 1,
            start_column: nil,
            end_line: 14,
            end_column: nil
          },
          {
            id: "4a336bed0551258d443c4e061bcc219ca326783c",
            path: "app.rb",
            start_line: 16,
            start_column: nil,
            end_line: 29,
            end_column: nil
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
    "Error: capacity has an invalid value (\#{capacity})"
  end
end]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PMD CPD", version: "6.23.0" }
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
  analyzer: { name: "PMD CPD", version: "6.23.0" }
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
  analyzer: { name: "PMD CPD", version: "6.23.0" }
)
