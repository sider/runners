s = Runners::Testing::Smoke

default_version = "2.12.0"

s.add_test(
  "sample1",
  type: "success",
  issues: [
    {
      path: "src/index.js",
      location: { start_line: 3, start_column: 1 },
      id: "jshint.W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "es2015-code-without-config",
  type: "success",
  issues: [
    {
      path: "index.js",
      location: { start_line: 1, start_column: 1 },
      id: "jshint.W097",
      message: 'Use the function form of "use strict".',
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "89b72153bd7e6390415ba25b9b5fbe750e6e16d5", original_line: 1, final_line: 1
      }
    },
    {
      path: "index.js",
      location: { start_line: 9, start_column: 5 },
      id: "jshint.W117",
      message: "'console' is not defined.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "4fcccde0e9f839fae12b97b5e3e6064fa5a60bc6", original_line: 9, final_line: 9
      }
    },
    {
      path: "index.js",
      location: { start_line: 16, start_column: 3 },
      id: "jshint.W117",
      message: "'console' is not defined.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "9c73ee33849055aae0cbc3e48e46a1d8851db037", original_line: 16, final_line: 16
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "dir",
  type: "success",
  issues: [
    {
      path: "src/app.js",
      location: { start_line: 3, start_column: 1 },
      id: "jshint.W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message: "The value of the attribute `linter.jshint.config` in your `sideci.yml` is invalid. Please fix and retry."
)

s.add_test(
  "with_options",
  type: "success",
  issues: [
    {
      message: "Unorthodox function invocation.",
      links: [],
      id: "jshint.W067",
      path: "src/index.js",
      location: { start_line: 3, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_,   line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version },
  warnings: [
    {
      message: /The `linter.jshint.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "broken_package_json",
  type: "success",
  issues: [],
  analyzer: { name: "JSHint", version: default_version },
  warnings: [{ message: /`package.json` is broken: \d+: unexpected token at/, file: "package.json" }]
)

s.add_test(
  "invalid_output_xml",
  type: "failure",
  message: 'The output XML is invalid: Illegal character "\\u0000" in raw string "Unexpected &apos;\\u0000&apos;."',
  analyzer: { name: "JSHint", version: default_version }
)
