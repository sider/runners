s = Runners::Testing::Smoke

default_version = "0.43.0"

s.add_test(
  "success",
  type: "success",
  analyzer: { name: "SwiftLint", version: default_version },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "identifier_name",
      message: "Function name should start with a lowercase character: 'Hello田()'",
      links: %w[https://realm.github.io/SwiftLint/identifier_name.html],
      object: { severity: "Error" },
      git_blame_info: {
        commit: :_, line_hash: "6211d2086ae586f782f4c3668f2fdb3d767aff58", original_line: 1, final_line: 1
      }
    }
  ]
)

s.add_test(
  "sideciyml",
  type: "success",
  analyzer: { name: "SwiftLint", version: default_version },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "class_delegate_protocol",
      message: "Delegate protocols should be class-only so they can be weakly referenced.",
      links: %w[https://realm.github.io/SwiftLint/class_delegate_protocol.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e7497ffa950f6e47ae1ef020fd1c1730fc35bc6", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "closure_parameter_position",
      message: "Closure parameters should be on the same line as opening brace.",
      links: %w[https://realm.github.io/SwiftLint/closure_parameter_position.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "79d8a9208644b10d765dafa9cc02c9bf4160e6ba", original_line: 6, final_line: 6
      }
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_acl",
      message: "All declarations should specify Access Control Level keywords explicitly.",
      links: %w[https://realm.github.io/SwiftLint/explicit_acl.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e7497ffa950f6e47ae1ef020fd1c1730fc35bc6", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "explicit_top_level_acl",
      message: "Top-level declarations should specify Access Control Level keywords explicitly.",
      links: %w[https://realm.github.io/SwiftLint/explicit_top_level_acl.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e7497ffa950f6e47ae1ef020fd1c1730fc35bc6", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.swift",
      location: { start_line: 1 },
      id: "file_name",
      message: "File name should match a type or extension declared in the file (if any).",
      links: %w[https://realm.github.io/SwiftLint/file_name.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e7497ffa950f6e47ae1ef020fd1c1730fc35bc6", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.swift",
      location: { start_line: 6 },
      id: "indentation_width",
      message: "Code should be indented using one tab or 4 spaces.",
      links: %w[https://realm.github.io/SwiftLint/indentation_width.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "79d8a9208644b10d765dafa9cc02c9bf4160e6ba", original_line: 6, final_line: 6
      }
    },
    {
      path: "test.swift",
      location: { start_line: 5 },
      id: "trailing_closure",
      message: "Trailing closure syntax should be used whenever possible.",
      links: %w[https://realm.github.io/SwiftLint/trailing_closure.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "5d4df678eddc97f02258547e2cac78ee2a5feea9", original_line: 5, final_line: 5
      }
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "trailing_whitespace",
      message: "Lines should not have trailing whitespace.",
      links: %w[https://realm.github.io/SwiftLint/trailing_whitespace.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "099600a10a944114aac406d136b625fb416dd779", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_closing_braces",
      message: "Don't include vertical whitespace (empty line) before closing braces.",
      links: %w[https://realm.github.io/SwiftLint/vertical_whitespace_closing_braces.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "099600a10a944114aac406d136b625fb416dd779", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.swift",
      location: { start_line: 2 },
      id: "vertical_whitespace_opening_braces",
      message: "Don't include vertical whitespace (empty line) after opening braces.",
      links: %w[https://realm.github.io/SwiftLint/vertical_whitespace_opening_braces.html],
      object: { severity: "Warning" },
      git_blame_info: {
        commit: :_, line_hash: "099600a10a944114aac406d136b625fb416dd779", original_line: 2, final_line: 2
      }
    }
  ]
)

s.add_test(
  "ignore_warnings",
  type: "success",
  analyzer: { name: "SwiftLint", version: default_version },
  issues: [
    {
      path: "test.swift",
      location: { start_line: 3 },
      id: "force_cast",
      message: "Force casts should be avoided.",
      links: %w[https://realm.github.io/SwiftLint/force_cast.html],
      object: { severity: "Error" },
      git_blame_info: {
        commit: :_, line_hash: "2befe6e35cfbdd67cda2cd3be9f4660634d39463", original_line: 3, final_line: 3
      }
    }
  ]
)

s.add_test("no_swift_file", type: "success", issues: [], analyzer: { name: "SwiftLint", version: default_version })

s.add_test(
  "no_config_file",
  type: "failure",
  message: "SwiftLint Configuration Error: Could not read file at path: not_found.yml",
  analyzer: { name: "SwiftLint", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.swiftlint.lenient` value in `sideci.yml` is invalid",
  analyzer: :_
)

# @see https://github.com/realm/SwiftLint/pull/2491
s.add_test(
  "wrong_swiftlint_version_set",
  type: "failure",
  message: "Currently running SwiftLint #{default_version} but configuration specified version 0.0.0.",
  analyzer: { name: "SwiftLint", version: default_version }
)

# NOTE: `unused_import` rule is for `swiftlint analyze` and is not reported with `swiftlint lint`
#
# @see https://realm.github.io/SwiftLint/unused_import.html
s.add_test("unused_import", type: "success", issues: [], analyzer: { name: "SwiftLint", version: default_version })

# @see https://github.com/realm/SwiftLint/pull/3313
s.add_test(
  "params_files",
  type: "success",
  analyzer: { name: "SwiftLint", version: default_version },
  issues: [
    {
      path: "foo/bar/baz/test3.swift",
      location: { start_line: 1 },
      id: "identifier_name",
      message: "Function name should start with a lowercase character: 'Hello3田()'",
      links: %w[https://realm.github.io/SwiftLint/identifier_name.html],
      object: { severity: "Error" },
      git_blame_info: {
        commit: :_, line_hash: "f7bc1a1b754c8835099fb68df561206b4275d9f9", original_line: 1, final_line: 1
      }
    },
    {
      path: "foo/test1.swift",
      location: { start_line: 1 },
      id: "identifier_name",
      message: "Function name should start with a lowercase character: 'Hello1田()'",
      links: %w[https://realm.github.io/SwiftLint/identifier_name.html],
      object: { severity: "Error" },
      git_blame_info: {
        commit: :_, line_hash: "c22b783989b7c2e8fa79ca4be7d32969dd9fdf3b", original_line: 1, final_line: 1
      }
    }
  ]
)
