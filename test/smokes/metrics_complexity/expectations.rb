s = Runners::Testing::Smoke

default_version = "1.17.7"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "example.c",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/fizzbuzz.py",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 7.",
      object: {
        CCN: 7
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.php",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.rb",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.scala",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/hello.lua",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/hello.rs",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/今日は世界.go",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/bar/hello.m",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/bar/hello.swift",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.c",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.cpp",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.java",
      location: nil,
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.js",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/こんにちは世界.cs",
      location: nil,
      message: "The sum of complexity of total 3 function(s) is 8.",
      object: {
        CCN: 8
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Complexity", version: default_version }
)

s.add_test(
  "comma_in_filename",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "src/example,file.cs",
      location: nil,
      message: "The sum of complexity of total 1 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Complexity", version: default_version }
)

s.add_test(
  "illegal_char_in_rspec_condition",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "myclass_test.rb",
      location: nil,
      message: :_,
      object: :_,
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics Complexity", version: default_version}
)

s.add_test(
  "complex_file",
  type: "success",
    issues: [
      {
        id: "metrics_file-complexity",
        path: "test.js",
        location: nil,
        message: :_,
        object: :_,
        links: [],
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics Complexity", version: default_version}
)
