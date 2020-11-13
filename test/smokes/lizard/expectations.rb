s = Runners::Testing::Smoke

default_version = "1.17.7"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "code-metrics",
      path: "example.c",
      location: { start_line: 7, end_line: 11 },
      message: "Complexity is 1 for 5 line(s) of code at main.",
      object: {
        NLOC: 5,
        CCN: 1,
        token: 13,
        PARAM: 1,
        length: 5,
        function: "main",
        long_name: "main( void)"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cf51d105d80da8bcee55efeb3b70011502abf9d0", original_line: 7, final_line: 7
      }
    },
    {
      id: "code-metrics",
      path: "example.c",
      location: { start_line: 13, end_line: 16 },
      message: "Complexity is 1 for 4 line(s) of code at print_hello_world.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 10,
        PARAM: 0,
        length: 4,
        function: "print_hello_world",
        long_name: "print_hello_world()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "64218a0fd55b3bf3c6e2231b24cb97b4beb7c07d", original_line: 13, final_line: 13
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/hello.php",
      location: { start_line: 2, end_line: 6 },
      message: "Complexity is 1 for 4 line(s) of code at hello_world.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 7,
        PARAM: 0,
        length: 5,
        function: "hello_world",
        long_name: "hello_world ( )"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "1c5f9d44bb3f43d94efe7c31b50c452875698a80", original_line: 2, final_line: 2
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/hello.py",
      location: { start_line: 1, end_line: 3 },
      message: "Complexity is 1 for 2 line(s) of code at hello_world.",
      object: {
        NLOC: 2,
        CCN: 1,
        token: 8,
        PARAM: 0,
        length: 3,
        function: "hello_world",
        long_name: "hello_world( )"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "a3a7f8f418d186dcf9849a0109ed2cfb1c24c0c6", original_line: 1, final_line: 1
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/hello.rb",
      location: { start_line: 1, end_line: 4 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 4,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cef9c6f253991b843ddae7253c8b054d2f4bf046", original_line: 1, final_line: 1
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/hello.scala",
      location: { start_line: 2, end_line: 5 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 10,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "6bbc59d8a3b8d34f9a4b6452b7ec62242797bfec", original_line: 2, final_line: 2
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/qux/hello.go",
      location: { start_line: 5, end_line: 7 },
      message: "Complexity is 1 for 3 line(s) of code at main.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 9,
        PARAM: 0,
        length: 3,
        function: "main",
        long_name: "main"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "5656b6543b24b9b164b717943f7e56d1cf5954c0", original_line: 5, final_line: 5
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/qux/hello.go",
      location: { start_line: 9, end_line: 12 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 12,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "de8a54f94e2c7fa83cb8713e423cfcf77f705fb4", original_line: 9, final_line: 9
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/qux/hello.lua",
      location: { start_line: 2, end_line: 5 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 6,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world )"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "1c5f9d44bb3f43d94efe7c31b50c452875698a80", original_line: 2, final_line: 2
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/qux/hello.rs",
      location: { start_line: 2, end_line: 4 },
      message: "Complexity is 1 for 3 line(s) of code at main.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 10,
        PARAM: 0,
        length: 3,
        function: "main",
        long_name: "main"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "77cf7c960249076c5960ab96178083f5427e6cb9", original_line: 2, final_line: 2
      }
    },
    {
      id: "code-metrics",
      path: "src/baz/qux/hello.rs",
      location: { start_line: 6, end_line: 9 },
      message: "Complexity is 1 for 3 line(s) of code at print_hello.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 12,
        PARAM: 0,
        length: 4,
        function: "print_hello",
        long_name: "print_hello"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "7e4c807c0610e658f65874ffbef8ee7e44914731", original_line: 6, final_line: 6
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/bar/hello.m",
      location: { start_line: 3, end_line: 8 },
      message: "Complexity is 1 for 5 line(s) of code at hello_world.",
      object: {
        NLOC: 5,
        CCN: 1,
        token: 15,
        PARAM: 0,
        length: 6,
        function: "hello_world",
        long_name: "hello_world()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "5e4df70cbe0a97dffc6984e47f2425dc1b5ef306", original_line: 3, final_line: 3
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/bar/hello.m",
      location: { start_line: 10, end_line: 13 },
      message: "Complexity is 1 for 4 line(s) of code at main.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 21,
        PARAM: 1,
        length: 4,
        function: "main",
        long_name: "main( int argc , const char * argv [ ])"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "7ed115c44fba1afccd67bc57ac1ab3dead320c12", original_line: 10, final_line: 10
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/bar/hello.swift",
      location: { start_line: 1, end_line: 4 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 10,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "de8a54f94e2c7fa83cb8713e423cfcf77f705fb4", original_line: 1, final_line: 1
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.c",
      location: { start_line: 6, end_line: 10 },
      message: "Complexity is 1 for 5 line(s) of code at main.",
      object: {
        NLOC: 5,
        CCN: 1,
        token: 13,
        PARAM: 1,
        length: 5,
        function: "main",
        long_name: "main( void)"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cf51d105d80da8bcee55efeb3b70011502abf9d0", original_line: 6, final_line: 6
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.c",
      location: { start_line: 12, end_line: 16 },
      message: "Complexity is 1 for 4 line(s) of code at print_hello_world.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 10,
        PARAM: 0,
        length: 5,
        function: "print_hello_world",
        long_name: "print_hello_world()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "64218a0fd55b3bf3c6e2231b24cb97b4beb7c07d", original_line: 12, final_line: 12
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.cpp",
      location: { start_line: 6, end_line: 10 },
      message: "Complexity is 1 for 5 line(s) of code at main.",
      object: {
        NLOC: 5,
        CCN: 1,
        token: 13,
        PARAM: 1,
        length: 5,
        function: "main",
        long_name: "main( void)"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cf51d105d80da8bcee55efeb3b70011502abf9d0", original_line: 6, final_line: 6
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.cpp",
      location: { start_line: 12, end_line: 16 },
      message: "Complexity is 1 for 4 line(s) of code at print_hello_world.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 13,
        PARAM: 0,
        length: 5,
        function: "print_hello_world",
        long_name: "print_hello_world()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "64218a0fd55b3bf3c6e2231b24cb97b4beb7c07d", original_line: 12, final_line: 12
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.cs",
      location: { start_line: 4, end_line: 7 },
      message: "Complexity is 1 for 4 line(s) of code at HelloWorld::Main.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 9,
        PARAM: 0,
        length: 4,
        function: "HelloWorld::Main",
        long_name: "HelloWorld::Main()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "6f8675952e222798e307e7e02f8df48be9afa3d2", original_line: 4, final_line: 4
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.cs",
      location: { start_line: 9, end_line: 13 },
      message: "Complexity is 1 for 4 line(s) of code at HelloWorld::PrintHelloWorld.",
      object: {
        NLOC: 4,
        CCN: 1,
        token: 14,
        PARAM: 0,
        length: 5,
        function: "HelloWorld::PrintHelloWorld",
        long_name: "HelloWorld::PrintHelloWorld()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "971fa2c643e4f0d82408f8d118cd0d33fdf98267", original_line: 9, final_line: 9
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.java",
      location: { start_line: 2, end_line: 4 },
      message: "Complexity is 1 for 3 line(s) of code at HelloWorld::main.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 13,
        PARAM: 0,
        length: 3,
        function: "HelloWorld::main",
        long_name: "HelloWorld::main( String args [ ])"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "147eb5fd9cd9f1e6d7d48e4fbd89e0dd53b13c0c", original_line: 2, final_line: 2
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.java",
      location: { start_line: 6, end_line: 9 },
      message: "Complexity is 1 for 3 line(s) of code at HelloWorld::printHelloWorld.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 14,
        PARAM: 0,
        length: 4,
        function: "HelloWorld::printHelloWorld",
        long_name: "HelloWorld::printHelloWorld()"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "85f8de94a8f46916f827884dbb7f798dbe79fc95", original_line: 6, final_line: 6
      }
    },
    {
      id: "code-metrics",
      path: "src/foo/hello.js",
      location: { start_line: 1, end_line: 4 },
      message: "Complexity is 1 for 3 line(s) of code at hello_world.",
      object: {
        NLOC: 3,
        CCN: 1,
        token: 11,
        PARAM: 0,
        length: 4,
        function: "hello_world",
        long_name: "hello_world ( )"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "d8a4f7e4e1e40d4d89907f7c88e7910b5f4c89fb", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Lizard", version: default_version }
)
