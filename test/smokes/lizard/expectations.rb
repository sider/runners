s = Runners::Testing::Smoke

default_version = "1.17.7"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "example.c",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "149adc10c9d2572e3b77dea6e7c33d192cf72899", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.php",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "9166a7b7093b6ef318e436c6b16866e360ab4381", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.rb",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cef9c6f253991b843ddae7253c8b054d2f4bf046", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/hello.scala",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "78914b96894b3c9c5892820e428f998cc22899e5", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/hello.lua",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/hello.rs",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/bar/hello.m",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "27d0b0697e417a1d3187d4996797d3e902ea4224", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/bar/hello.swift",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "de8a54f94e2c7fa83cb8713e423cfcf77f705fb4", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.c",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "d42248803e602b7ee4448ae8d372f0f95421205f", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.cpp",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "967aa8311e4618a7623761dbd00005a96a4591a4", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.java",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "162566b03b8543fc8a497a4394edf49a26904add", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/hello.js",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: {
        CCN: 1
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "d8a4f7e4e1e40d4d89907f7c88e7910b5f4c89fb", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Lizard", version: default_version }
)

s.add_test(
  "root_dir",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "src/baz/fizzbuzz.py",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 7.",
      object: {
        CCN: 7
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "d08f88df745fa7950b104e4a707a31cfce7b5841", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/qux/今日は世界.go",
      location: { start_line: 1 },
      message: "The sum of complexity of total 2 function(s) is 2.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/baz/こんにちは.py",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 1.",
      object: :_,
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "a3a7f8f418d186dcf9849a0109ed2cfb1c24c0c6", original_line: 1, final_line: 1
      }
    },
    {
      id: "metrics_file-complexity",
      path: "src/foo/こんにちは世界.cs",
      location: { start_line: 1 },
      message: "The sum of complexity of total 3 function(s) is 8.",
      object: {
        CCN: 8
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Lizard", version: default_version }
)

s.add_test(
  "comma_in_filename",
  type: "success",
  issues: [
    {
      id: "metrics_file-complexity",
      path: "src/example,file.cs",
      location: { start_line: 1 },
      message: "The sum of complexity of total 1 function(s) is 2.",
      object: {
        CCN: 2
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "c0e285cf808bd7dc2b67fbc8f279a4748e90fec8", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Lizard", version: default_version }
)
