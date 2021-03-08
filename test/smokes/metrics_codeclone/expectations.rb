s = Runners::Testing::Smoke

default_version = "6.32.0"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "app.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 2 with total 56 lines.",
      links: [],
      object: {
        clones: 2,
        total_clone_lines: 56
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "no_files",
  type: "success",
  issues: [],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "no_issues",
  type: "success",
  issues: [],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  message: "`linter.pmd_cpd.files-path` in `sider.yml` is unsupported",
  analyzer: :_
)

s.add_test(
  "option_files",
  type: "success",
  issues: [
    {
      path: "lib/foo/bar.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 28 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 28
      },
      git_blame_info: nil
    },
    {
      path: "src/app.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 28 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 28
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_language_ruby",
  type: "success",
  issues: [
    {
      path: "foo/bar/baz/qux.rb",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 14 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 14
      },
      git_blame_info: nil
    },
    {
      path: "src/app.rb",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 14 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 14
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_language_c",
  type: "success",
  issues: [
    {
      path: "src/fizzbuzz_1.c",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 3 with total 10 lines.",
      links: [],
      object: {
        clones: 3,
        total_clone_lines: 10
      },
      git_blame_info: nil
    },
    {
      path: "src/fizzbuzz_2.c",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 3 with total 10 lines.",
      links: [],
      object: {
        clones: 3,
        total_clone_lines: 10
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_no_skip_blocks",
  type: "success",
  issues: [
    {
      path: "src/fizzbuzz.c",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 2 with total 22 lines.",
      links: [],
      object: {
        clones: 2,
        total_clone_lines: 22
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_encoding_success",
  type: "success",
  issues: [
    {
      path: "bar/baz/こんにちは.sjis.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 24 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 24
      },
      git_blame_info: nil
    },
    {
      path: "foo/こんにちは.sjis.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 24 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 24
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
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_encoding_error",
  type: "success",
  issues: [],
  warnings: [
    {
      message: "Skipping ./hello.eucjp.cs. Reason: Lexical error in file ./hello.eucjp.cs at line 20, column 13.  Encountered: token recognition error at: '｣'",
      file: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_skip_duplicate_files",
  type: "success",
  issues: [
    {
      path: "bar/こんにちは.1.eucjp.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
      },
      git_blame_info: nil
    },
    {
      path: "foo/こんにちは.2.eucjp.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
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
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_language_java",
  type: "success",
  issues: [
    {
      path: "MyApp.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 40 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 40
      },
      git_blame_info: nil
    },
    {
      path: "jp/MyAppJp.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 40 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 40
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "warnings",
  type: "success",
  issues: [
    {
      path: "src/bar/こんにちは.1.sjis.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/こんにちは.2.sjis.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
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
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_multiple_languages_default",
  type: "success",
  issues: [
    {
      path: "bar/hello_cpp.cpp",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_cs.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 12 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 12
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_ecmascript.js",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 5 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 5
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_go.go",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 10 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 10
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_java.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 13 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 13
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_kotlin.kt",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_php.php",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 8 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 8
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_python.py",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_ruby.rb",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 24 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 24
      },
      git_blame_info: nil
    },
    {
      path: "bar/hello_swift.swift",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 9 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 9
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_cpp.cpp",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 15 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 15
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_cs.cs",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 12 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 12
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_ecmascript.js",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 5 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 5
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_go.go",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 10 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 10
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_java.java",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 13 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 13
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_kotlin.kt",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_php.php",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 8 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 8
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_python.py",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_ruby.rb",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 24 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 24
      },
      git_blame_info: nil
    },
    {
      path: "foo/hello_swift.swift",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 9 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 9
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_multiple_languages",
  type: "success",
  issues: [
    {
      path: "src/bar/hello_dart.dart",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "src/bar/hello_lua.lua",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 9 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 9
      },
      git_blame_info: nil
    },
    {
      path: "src/bar/hello_python.py",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_dart.dart",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_lua.lua",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 9 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 9
      },
      git_blame_info: nil
    },
    {
      path: "src/foo/hello_python.py",
      location: nil,
      id: "metrics_codeclone",
      message: "The number of code clones is 1 with total 7 lines.",
      links: [],
      object: {
        clones: 1,
        total_clone_lines: 7
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "option_multiple_languages_invalid",
  type: "failure",
  message: "`linter.pmd_cpd.language` value in `sider.yml` is invalid",
  analyzer: :_
)

s.add_test(
  "option_multiple_languages_available",
  type: "success",
  issues: [],
  analyzer: { name: "Metrics Code Clone", version: default_version }
)

s.add_test(
  "root_not_found",
  type: "failure",
  message: "`src` directory is not found! Please check `linter.pmd_cpd.root_dir` in your `sider.yml`",
  analyzer: :_
)
