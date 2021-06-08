s = Runners::Testing::Smoke

default_version = "2.13.0"

s.add_test(
  "sample1",
  type: "success",
  issues: [
    {
      path: "src/index.js",
      location: { start_line: 3, start_column: 1 },
      id: "W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
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
      location: { start_line: 10, start_column: 12 },
      id: "W147",
      message: "Regular expressions should include the 'u' flag.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "ca4b2c9ee4f84e77d3adaebb8c6a88eb5250c811", original_line: 10, final_line: 10
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
      id: "W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message: "`linter.jshint.config` value in `sideci.yml` is invalid"
)

s.add_test(
  "with_options",
  type: "success",
  issues: [
    {
      message: "Unorthodox function invocation.",
      links: [],
      id: "W067",
      path: "src/index.js",
      location: { start_line: 3, start_column: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "b419b61355f047cf4b8d3bcceacb6f671bcdd5b1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "broken_package_json",
  type: "success",
  issues: [],
  analyzer: { name: "JSHint", version: default_version },
  warnings: [{ message: /`package.json` is broken: \d+: unexpected token at/, file: "package.json" }]
)

s.add_test(
  "invalid_character",
  type: "success",
  issues: [], # handled as a binary file, so considered as no changes
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "syntax_error",
  type: "success",
  issues: [
    {
      message: "Unexpected early end of program.",
      links: [],
      id: "E006",
      path: "foo.js",
      location: { start_line: 1, start_column: 6 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "136d962ebe6eb8336c5826e7e91fe503f918ec54", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "with_package_json_config",
  type: "success",
  issues: [
    {
      message: "'class' is available in ES6 (use 'esversion: 6') or Mozilla JS extensions (use moz).",
      links: [],
      id: "W104",
      path: "foo.js",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "313d20acfe186ea3594870fc6d56c119f658fef2", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "JSHint", version: default_version }
)

s.add_test(
  "no_files",
  type: "success",
  issues: [],
  analyzer: { name: "JSHint", version: default_version }
)
