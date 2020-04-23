s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "identifier_name",
      message: "Function name should start with a lowercase character: 'Hello田()'",
      object: nil,
      git_blame_info: nil,
      links: []
    }
  ]
)

s.add_test(
  "sideciyml",
  type: "success",
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "class_delegate_protocol",
      message: "Delegate protocols should be class-only so they can be weakly referenced.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "closure_parameter_position",
      message: "Closure parameters should be on the same line as opening brace.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_acl",
      message: "All declarations should specify Access Control Level keywords explicitly.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_top_level_acl",
      message: "Top-level declarations should specify Access Control Level keywords explicitly.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "file_name",
      message: "File name should match a type or extension declared in the file (if any).",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "indentation_width",
      message: "Code should be indented using one tab or 4 spaces.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 8 },
      id: "multiline_arguments_brackets",
      message: "Multiline arguments should have their surrounding brackets in a new line.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 5 },
      id: "trailing_closure",
      message: "Trailing closure syntax should be used whenever possible.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "trailing_whitespace",
      message: "Lines should not have trailing whitespace.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_closing_braces",
      message: "Don't include vertical whitespace (empty line) before closing braces.",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_opening_braces",
      message: "Don't include vertical whitespace (empty line) after opening braces.",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "ignore_warnings",
  type: "success",
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 3 },
      id: "force_cast",
      message: "Force casts should be avoided.",
      object: nil,
      git_blame_info: nil,
      links: []
    }
  ]
)

s.add_test(
  "no_swift_file",
  type: "success",
  issues: [],
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  warnings: [{ message: "No lintable files found.", file: nil }]
)

s.add_test(
  "no_config_file",
  type: "failure",
  message: /\ASwiftLint aborted\.\n(.+)\nCould not read configuration file at path (.+)/m,
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  warnings: [
    {
      message: <<~MSG.strip,
DEPRECATION WARNING!!!
The `$.linter.swiftlint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/swift/swiftlint ).
MSG
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `$.linter.swiftlint.lenient` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "wrong_swiftlint_version_set",
  type: "failure",
  # TODO: The message sometimes can be "". It should be "Loading configuration from '.swiftlint.yml'".
  message: :_,
  analyzer: { name: "SwiftLint", version: "0.39.2" }
)
