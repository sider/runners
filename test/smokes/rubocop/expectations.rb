s = Runners::Testing::Smoke

default_version = "0.85.1"

s.add_test(
  "sandbox_rails",
  type: "success",
  issues: [
    {
      message: "Literal `true` appeared as a condition.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintliteralascondition],
      id: "Lint/LiteralAsCondition",
      path: "app/controllers/users_controller.rb",
      object: { severity: "warning", corrected: false },
      git_blame_info: nil,
      location: { start_line: 23, start_column: 8, end_line: 23, end_column: 11 }
    },
    {
      message: "Shadowing outer local variable - `v`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintshadowingouterlocalvariable],
      id: "Lint/ShadowingOuterLocalVariable",
      path: "app/controllers/users_controller.rb",
      object: { severity: "warning", corrected: false },
      git_blame_info: nil,
      location: { start_line: 27, start_column: 30, end_line: 27, end_column: 30 }
    },
    {
      message: "Useless assignment to variable - `v`.",
      links: %w[
        https://rubystyle.guide#underscore-unused-vars
        https://docs.rubocop.org/rubocop/cops_lint.html#lintuselessassignment
      ],
      id: "Lint/UselessAssignment",
      path: "app/controllers/users_controller.rb",
      object: { severity: "warning", corrected: false },
      git_blame_info: nil,
      location: { start_line: 26, start_column: 5, end_line: 26, end_column: 5 }
    },
    {
      message: "Prefer symbols instead of strings as hash keys.",
      links: %w[
        https://rubystyle.guide#symbols-as-keys
        https://docs.rubocop.org/rubocop/cops_style.html#stylestringhashkeys
      ],
      id: "Style/StringHashKeys",
      path: "config/environments/development.rb",
      object: { severity: "convention", corrected: false },
      git_blame_info: nil,
      location: { start_line: 21, start_column: 7, end_line: 21, end_column: 21 }
    },
    {
      message: "Prefer symbols instead of strings as hash keys.",
      links: %w[
        https://rubystyle.guide#symbols-as-keys
        https://docs.rubocop.org/rubocop/cops_style.html#stylestringhashkeys
      ],
      id: "Style/StringHashKeys",
      path: "config/environments/test.rb",
      object: { severity: "convention", corrected: false },
      git_blame_info: nil,
      location: { start_line: 18, start_column: 5, end_line: 18, end_column: 19 }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "without_display_cop_names",
  type: "success",
  issues: [
    {
      "message": "Missing top-level class documentation comment.",
      "links": %w[https://docs.rubocop.org/rubocop/cops_style.html#styledocumentation],
      "id": "Style/Documentation",
      "path": "app.rb",
      "location": { "start_line": 3, "start_column": 1, "end_line": 3, "end_column": 5 },
      "object": { "severity": "convention", "corrected": false },
      "git_blame_info": nil
    },
    {
      "message": "Put empty method definitions on a single line.",
      "links": %w[
        https://rubystyle.guide#no-single-line-methods
        https://docs.rubocop.org/rubocop/cops_style.html#styleemptymethod
      ],
      "id": "Style/EmptyMethod",
      "path": "app.rb",
      "location": { "start_line": 4, "start_column": 3, "end_line": 5, "end_column": 5 },
      "object": { "severity": "convention", "corrected": false },
      "git_blame_info": nil
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "renamed-cop",
  type: "success",
  issues: [
    {
      message: "Use 2 (not 1) spaces for indentation.",
      links: %w[
        https://rubystyle.guide#spaces-indentation
        https://docs.rubocop.org/rubocop/cops_layout.html#layoutindentationwidth
      ],
      id: "Layout/IndentationWidth",
      path: "test.rb",
      object: { severity: "convention", corrected: false },
      git_blame_info: nil,
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 1 }
    },
    {
      message: "Tab detected.",
      links: %w[
        https://rubystyle.guide#spaces-indentation
        https://docs.rubocop.org/rubocop/cops_layout.html#layouttab
      ],
      id: "Layout/Tab",
      path: "test.rb",
      object: { severity: "convention", corrected: false },
      git_blame_info: nil,
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 1 }
    },
    {
      path: "Gemfile",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Style/FrozenStringLiteralComment",
      message: "Missing magic comment `# frozen_string_literal: true`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylefrozenstringliteralcomment],
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    },
    {
      path: "test.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Style/FrozenStringLiteralComment",
      message: "Missing magic comment `# frozen_string_literal: true`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylefrozenstringliteralcomment],
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.79.0" },
  warnings: [{ message: "Style/Tab has the wrong namespace - should be Layout", file: ".rubocop.yml" }]
)

s.add_test(
  "inherit_from",
  type: "success",
  issues: [
    {
      message: "Line is too long. [218/200]",
      links: %w[
        https://rubystyle.guide#80-character-limits
        https://docs.rubocop.org/rubocop/cops_layout.html#layoutlinelength
      ],
      id: "Layout/LineLength",
      path: "cat.rb",
      object: { severity: "convention", corrected: false },
      git_blame_info: nil,
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 }
    }
  ],
  analyzer: { name: "RuboCop", version: "0.79.0" }
)

s.add_test(
  "no_rubocop_yml",
  type: "success",
  issues: [
    {
      message: "Use the `&&` operator to compare multiple values.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintmultiplecomparison],
      id: "Lint/MultipleComparison",
      path: "test.rb",
      object: { severity: "warning", corrected: false },
      git_blame_info: nil,
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 14 }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "exit2",
  type: "failure",
  message: "Error: Cops cannot be both enabled by default and disabled by default",
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message:
    "The value of the attribute `linter.rubocop.gems[0]` in your `sideci.yml` is invalid. Please fix and retry."
)

s.add_test(
  "with_safe_cops",
  type: "success",
  issues: [
    {
      message: "Empty `ensure` block detected.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintemptyensure],
      id: "Lint/EmptyEnsure",
      path: "drink.rb",
      location: { start_line: 12, start_column: 3, end_line: 12, end_column: 8 },
      object: { severity: "warning", corrected: false },
      git_blame_info: nil
    },
    {
      message: "Do not chain ordinary method call after safe navigation operator.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintsafenavigationchain],
      id: "Lint/SafeNavigationChain",
      path: "drink.rb",
      location: { start_line: 18, start_column: 21, end_line: 18, end_column: 27 },
      object: { severity: "warning", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The following options in your `sideci.yml` are deprecated and will be removed.
        See https://help.sider.review/tools/ruby/rubocop for details.
        - `linter.rubocop.options`
      MSG
      file: "sideci.yml"
    },
    { message: "Metrics/LineLength has the wrong namespace - should be Layout", file: "my.rubocop.yml" }
  ]
)

s.add_test(
  "v0.71_rails",
  type: "success",
  issues: [
    {
      message: "Line is too long. [218/200]",
      links: %w[
        https://github.com/rubocop-hq/ruby-style-guide#80-character-limits
        https://docs.rubocop.org/rubocop/cops_metrics.html#metricslinelength
      ],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.71.0" },
  warnings: [
    {
      message: "Rails cops were removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.",
      file: nil
    }
  ]
)

s.add_test(
  "v0.72_rails",
  type: "success",
  issues: [
    {
      message: "Line is too long. [218/200]",
      links: %w[
        https://rubystyle.guide#80-character-limits
        https://docs.rubocop.org/rubocop/cops_metrics.html#metricslinelength
      ],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.72.0" }
)

s.add_test(
  "v0.72_rails_option",
  type: "success",
  issues: [
    {
      message: "Line is too long. [218/200]",
      links: %w[
        https://rubystyle.guide#80-character-limits
        https://docs.rubocop.org/rubocop/cops_metrics.html#metricslinelength
      ],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.72.0" },
  warnings: [
    {
      message: <<~WARNING.strip,
        The `linter.rubocop.rails` option in your `sideci.yml` is ignored.
        Because the `--rails` option was removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
      WARNING
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "rails_and_performance",
  type: "success",
  issues: [
    {
      message: "Use `caller(2..2).first` instead of `caller[1]`.",
      links: %w[https://docs.rubocop.org/rubocop-performance/cops_performance.html#performancecaller],
      id: "Performance/Caller",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 9 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsexit],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsfilepath],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.79.0" }
)

s.add_test(
  "rails_and_performance_old",
  type: "success",
  issues: [
    {
      message: "Use `caller(2..2).first` instead of `caller[1]`.",
      links: %w[https://docs.rubocop.org/rubocop-performance/cops_performance.html#performancecaller],
      id: "Performance/Caller",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 9 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsexit],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsfilepath],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "RuboCop", version: "0.67.0" }
)

s.add_test(
  "install_from_sideci.yml_when_installing_old_version_gems",
  type: "failure",
  message: <<~MSG.strip,
    Failed to install gems according to `sideci.yml` and `Gemfile.lock`.
    You can select the version of gems you want to install via `sideci.yml`.
    See https://help.sider.review/getting-started/custom-configuration#linteranalyzer_idgems
  MSG
  analyzer: :_
)

s.add_test(
  "old_ruocop_is_specified",
  type: "success",
  issues: [],
  analyzer: { name: "RuboCop", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        `rubocop 0.85.1` is installed instead of `0.60.0` in your `Gemfile.lock`.
        Because `0.60.0` does not satisfy our constraints `>= 0.61.0, < 1.0.0`.

        If you want to use a different version of `rubocop`, please do either:
        - Update your `Gemfile.lock` to satisfy the constraint
        - Set the `linter.rubocop.gems` option in your `sider.yml`
      MSG
      file: nil
    }
  ]
)

s.add_test("old_bundler_via_gemspec", type: "success", issues: [], analyzer: { name: "RuboCop", version: default_version })

s.add_test("latest_bundler_via_gemspec", type: "success", issues: [], analyzer: { name: "RuboCop", version: default_version })
