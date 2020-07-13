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
      links: %w[https://realm.github.io/SwiftLint/identifier_name.html],
      object: { severity: "Error" },
      git_blame_info: nil
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
      links: %w[https://realm.github.io/SwiftLint/class_delegate_protocol.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "closure_parameter_position",
      message: "Closure parameters should be on the same line as opening brace.",
      links: %w[https://realm.github.io/SwiftLint/closure_parameter_position.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_acl",
      message: "All declarations should specify Access Control Level keywords explicitly.",
      links: %w[https://realm.github.io/SwiftLint/explicit_acl.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_top_level_acl",
      message: "Top-level declarations should specify Access Control Level keywords explicitly.",
      links: %w[https://realm.github.io/SwiftLint/explicit_top_level_acl.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "file_name",
      message: "File name should match a type or extension declared in the file (if any).",
      links: %w[https://realm.github.io/SwiftLint/file_name.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "indentation_width",
      message: "Code should be indented using one tab or 4 spaces.",
      links: %w[https://realm.github.io/SwiftLint/indentation_width.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 8 },
      id: "multiline_arguments_brackets",
      message: "Multiline arguments should have their surrounding brackets in a new line.",
      links: %w[https://realm.github.io/SwiftLint/multiline_arguments_brackets.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 5 },
      id: "trailing_closure",
      message: "Trailing closure syntax should be used whenever possible.",
      links: %w[https://realm.github.io/SwiftLint/trailing_closure.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "trailing_whitespace",
      message: "Lines should not have trailing whitespace.",
      links: %w[https://realm.github.io/SwiftLint/trailing_whitespace.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_closing_braces",
      message: "Don't include vertical whitespace (empty line) before closing braces.",
      links: %w[https://realm.github.io/SwiftLint/vertical_whitespace_closing_braces.html],
      object: { severity: "Warning" },
      git_blame_info: nil
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_opening_braces",
      message: "Don't include vertical whitespace (empty line) after opening braces.",
      links: %w[https://realm.github.io/SwiftLint/vertical_whitespace_opening_braces.html],
      object: { severity: "Warning" },
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
      links: %w[https://realm.github.io/SwiftLint/force_cast.html],
      object: { severity: "Error" },
      git_blame_info: nil
    }
  ]
)

s.add_test("no_swift_file", type: "success", issues: [], analyzer: { name: "SwiftLint", version: "0.39.2" })

s.add_test(
  "no_config_file",
  type: "failure",
  message: "Could not read configuration file at path 'not_found.yml'.",
  analyzer: { name: "SwiftLint", version: "0.39.2" },
  warnings: [
    {
      message: /The `linter.swiftlint.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.swiftlint.lenient` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

# @see https://github.com/realm/SwiftLint/pull/2491
s.add_test(
  "wrong_swiftlint_version_set",
  type: "failure",
  message: "Currently running SwiftLint 0.39.2 but configuration specified version 0.0.0.",
  analyzer: { name: "SwiftLint", version: "0.39.2" }
)

# NOTE: `unused_import` rule is for `swiftlint analyze` and is not reported with `swiftlint lint`
#
# @see https://realm.github.io/SwiftLint/unused_import.html
s.add_test("unused_import", type: "success", issues: [], analyzer: { name: "SwiftLint", version: "0.39.2" })
