s = Runners::Testing::Smoke

s.add_test(
  "sample1",
  type: "success",
  issues: [
    {
      path: "src/index.js",
      location: { start_line: 3 },
      id: "jshint.W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "JSHint", version: "2.11.1" }
)

s.add_test(
  "es2015-code-without-config",
  type: "success",
  issues: [
    {
      path: "index.js",
      location: { start_line: 1 },
      id: "jshint.W097",
      message: 'Use the function form of "use strict".',
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "index.js",
      location: { start_line: 9 },
      id: "jshint.W117",
      message: "'console' is not defined.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "index.js",
      location: { start_line: 16 },
      id: "jshint.W117",
      message: "'console' is not defined.",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "JSHint", version: "2.11.1" }
)

s.add_test(
  "dir",
  type: "success",
  issues: [
    {
      path: "src/app.js",
      location: { start_line: 3 },
      id: "jshint.W067",
      message: "Unorthodox function invocation.",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "JSHint", version: "2.11.1" }
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
      location: { start_line: 3 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "JSHint", version: "2.11.1" },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The following options in your `sideci.yml` are deprecated and will be removed.
        See https://help.sider.review/tools/javascript/jshint for details.
        - `linter.jshint.options`
      MSG
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "broken_package_json",
  type: "success",
  issues: [],
  analyzer: { name: "JSHint", version: "2.11.1" },
  warnings: [{ message: /`package.json` is broken: \d+: unexpected token at/, file: "package.json" }]
)

s.add_test(
  "invalid_output_xml",
  type: "failure",
  message: 'The output XML is invalid: Illegal character "\\u0000" in raw string "Unexpected &apos;\\u0000&apos;."',
  analyzer: { name: "JSHint", version: "2.11.1" }
)
