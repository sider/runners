s = Runners::Testing::Smoke

default_version = "0.37.0"

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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
    },
    {
      message: "Line is too long. [204/200]",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#linelength],
      id: "LineLength",
      path: "test.haml",
      location: { start_line: 7 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "416b409e6b7628da6f061cd2c159b03157c38192", original_line: 7, final_line: 7
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version },
  warnings: [{ message: "The `linter.haml_lint.file` option is deprecated. Please use the `linter.haml_lint.target` option instead in your `sideci.yml`.", file: "sideci.yml" }]
)

s.add_test(
  "plain-rubocop",
  type: "success",
  issues: [
    {
      message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`.",
      links: %W[
        https://docs.rubocop.org/rubocop/cops_lint.html#lintuselessassignment
        https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#rubocop
      ],
      id: "RuboCop:Lint/UselessAssignment",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "d5c5462372be75aeed8a878e413ce34e69e38e58", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "with-inherit-gem",
  type: "success",
  issues: [
    {
      message: "Useless assignment to variable - `unused_variable`. (https://rubystyle.guide#underscore-unused-vars)",
      links: %w[https://github.com/sds/haml-lint/blob/v0.34.0/lib/haml_lint/linter#rubocop],
      id: "RuboCop",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "d5c5462372be75aeed8a878e413ce34e69e38e58", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
    },
    {
      path: "test.haml",
      location: { start_line: 5 },
      id: "RuboCop:Performance/FlatMap",
      message: "Performance/FlatMap: Use `flat_map` instead of `map...flatten`.",
      links: %W[
        https://docs.rubocop.org/rubocop-performance/cops_performance.html#performanceflatmap
        https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#rubocop
      ],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "fbeff8480acd0bfaa22199218b67510fdfa9c389", original_line: 5, final_line: 5
      }
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
      git_blame_info: {
        commit: :_, line_hash: "da7cbdf991191af285867e39fd1239b6a030b465", original_line: 2, final_line: 2
      }
    },
    {
      message: "Line is too long. [84/80]",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#linelength],
      id: "LineLength",
      path: "hello.haml",
      location: { start_line: 7 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "53d100be96dfb32b768bb472f9f7da2409f73ab6", original_line: 7, final_line: 7
      }
    },
    {
      message: "Illegal nesting: content can't be both given on the same line as %span and nested within it.",
      links: [],
      id: "Syntax",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "548868ef1457d72c2cf9dc8b7fec98642332e40a", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.haml_lint.config` value in `sideci.yml` is invalid",
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.26.0" },
  warnings: [{ message: "The option `linter.haml_lint.parallel` is ignored with HAML-Lint 0.26.0. Please update it to **0.36.0+** or use our default version.", file: "sider.yml" }]
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: "0.32.0" }
)

s.add_test(
  "missing_rubocop_required_gems",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "HAML-Lint", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "44947cfd037e9e7da2b3c820c05f5724230f12c7", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 1, final_line: 1
      }
    },
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "src/bar.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)

s.add_test(
  "option_parallel",
  type: "success",
  issues: [
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "1.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 1, final_line: 1
      }
    },
    {
      message: "Avoid defining `class` in attributes hash for static class names",
      links: %W[https://github.com/sds/haml-lint/blob/v#{default_version}/lib/haml_lint/linter#classattributewithstaticvalue],
      id: "ClassAttributeWithStaticValue",
      path: "2.haml",
      location: { start_line: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "2f024a2bdf291a1ab61e026140f7e709028266a8", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "HAML-Lint", version: default_version }
)
