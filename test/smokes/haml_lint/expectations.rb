s = Runners::Testing::Smoke

default_version = "0.35.0"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "with-sideci.yml",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The following options in your `sideci.yml` are deprecated and will be removed.
        See https://help.sider.review/tools/ruby/haml-lint for details.
        - `linter.haml_lint.options`
      MSG
      file: "sideci.yml"
    },
    {
      message: "The `linter.haml_lint.file` option is deprecated. Use the `linter.haml_lint.target` option instead.",
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "plain-rubocop",
  type: "success",
  issues: [
    {
      message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`.",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#rubocop],
      id: "RuboCop",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "with-inherit-gem",
  type: "success",
  issues: [
    {
      message:
        "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`. (https://rubystyle.guide#underscore-unused-vars)",
      links: %w[https://github.com/sds/haml-lint/blob/v0.34.0/lib/haml_lint/linter#rubocop],
      id: "RuboCop",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.34.0" }
)

s.add_test(
  "optional_gems_are_installed_via_gemfile",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      path: "test.haml",
      location: { start_line: 5 },
      id: "RuboCop",
      message: "Performance/FlatMap: Use `flat_map` instead of `map...flatten`.",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#rubocop],
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "with_exclude_files",
  type: "success",
  issues: [
    {
      message: "3 consecutive Ruby scripts can be merged into a single `:ruby` filter",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#consecutivesilentscripts],
      id: "ConsecutiveSilentScripts",
      path: "hello.haml",
      location: { start_line: 2 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      message: "Illegal nesting: content can't be both given on the same line as %span and nested within it.",
      links: [],
      id: "Syntax",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.haml_lint.config` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "lowest-deps",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %w[https://github.com/sds/haml-lint/blob/v0.26.0/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.26.0" }
)

s.add_test(
  "incompatible_rubocop",
  guid: "test-guid", timestamp: :_, type: "failure", message: /Failed to install gems/, analyzer: :_
)

# This test case, `incompatible_haml`, will be failed if updating HAML-Lint version,
# because HAML-Lint 4.1 beta support was dropped.
# https://github.com/sds/haml-lint/releases/tag/v0.31.0
s.add_test(
  "incompatible_haml",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %w[https://github.com/sds/haml-lint/blob/v0.28.0/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.28.0" }
)

# HAML-Lint v0.33.0 has supported HAML 5.1, therefore this test case checks brand-new HAML version.
# When HAML-Lint supports upper HAML version than 5.1, feel free to change pinned version such as `5.2`, `5.3`, ....
s.add_test(
  "pinned_haml_version",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %w[https://github.com/sds/haml-lint/blob/v0.32.0/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 4 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.32.0" }
)

s.add_test(
  "missing_rubocop_required_gems",
  type: "failure", message: "HAML-Lint raises an unexpected error", analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "missing_rubocop_required_gems_with_old_haml_lint",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %w[https://github.com/sds/haml-lint/blob/v0.34.2/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "test.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.34.2" },
  warnings: [{ message: "cannot load such file -- rubocop-performance", file: nil }]
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "foo.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "src/bar.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)
