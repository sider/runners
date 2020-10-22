s = Runners::Testing::Smoke

default_version = "0.89.1"

s.add_test(
  "sandbox_rails",
  type: "success",
  issues: [
    {
      message: "Literal `true` appeared as a condition.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintliteralascondition],
      id: "Lint/LiteralAsCondition",
      path: "app/controllers/users_controller.rb",
      location: { start_line: 23, start_column: 8, end_line: 23, end_column: 11 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "57d3f05dcf6eda436e8767ebacf7058380da0c36", original_line: 23, final_line: 23
      }
    },
    {
      message: "Shadowing outer local variable - `v`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintshadowingouterlocalvariable],
      id: "Lint/ShadowingOuterLocalVariable",
      path: "app/controllers/users_controller.rb",
      location: { start_line: 27, start_column: 30, end_line: 27, end_column: 30 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "e0d6961a0bfecb1bc1b2ceab229ceeb47b19e800", original_line: 27, final_line: 27
      }
    },
    {
      message: "Useless assignment to variable - `v`.",
      links: %w[
        https://rubystyle.guide#underscore-unused-vars
        https://docs.rubocop.org/rubocop/cops_lint.html#lintuselessassignment
      ],
      id: "Lint/UselessAssignment",
      path: "app/controllers/users_controller.rb",
      location: { start_line: 26, start_column: 5, end_line: 26, end_column: 5 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "244264415175459d6469d72805cb5c39725b9b6c", original_line: 26, final_line: 26
      }
    },
    {
      message: "Prefer symbols instead of strings as hash keys.",
      links: %w[
        https://rubystyle.guide#symbols-as-keys
        https://docs.rubocop.org/rubocop/cops_style.html#stylestringhashkeys
      ],
      id: "Style/StringHashKeys",
      path: "config/environments/development.rb",
      location: { start_line: 21, start_column: 7, end_line: 21, end_column: 21 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "3073614325db4219b001e4ce703a8b10ba8cc0d2", original_line: 21, final_line: 21
      }
    },
    {
      message: "Prefer symbols instead of strings as hash keys.",
      links: %w[
        https://rubystyle.guide#symbols-as-keys
        https://docs.rubocop.org/rubocop/cops_style.html#stylestringhashkeys
      ],
      id: "Style/StringHashKeys",
      path: "config/environments/test.rb",
      location: { start_line: 18, start_column: 5, end_line: 18, end_column: 19 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "7ecd987ce8c7d9a7d7279b2b956b79644ee0083f", original_line: 18, final_line: 18
      }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "without_display_cop_names",
  type: "success",
  issues: [
    {
      message: "Missing top-level class documentation comment.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styledocumentation],
      id: "Style/Documentation",
      path: "app.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 5 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "11d2b5872a5f698502da96fb40bac6646c939b27", original_line: 3, final_line: 3
      }
    },
    {
      message: "Put empty method definitions on a single line.",
      links: %w[
        https://rubystyle.guide#no-single-line-methods
        https://docs.rubocop.org/rubocop/cops_style.html#styleemptymethod
      ],
      id: "Style/EmptyMethod",
      path: "app.rb",
      location: { start_line: 4, start_column: 3, end_line: 5, end_column: 5 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "22b4f311c3c0f05af882d9168396e6eb4ff3d7d6", original_line: 4, final_line: 4
      }
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
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 1 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "ae6db0dfbd48186e8c57314071e7ed72d24011ca", original_line: 2, final_line: 2
      }
    },
    {
      message: "Tab detected.",
      links: %w[
        https://rubystyle.guide#spaces-indentation
        https://docs.rubocop.org/rubocop/cops_layout.html#layouttab
      ],
      id: "Layout/Tab",
      path: "test.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 1 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "ae6db0dfbd48186e8c57314071e7ed72d24011ca", original_line: 2, final_line: 2
      }
    },
    {
      path: "Gemfile",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Style/FrozenStringLiteralComment",
      message: "Missing magic comment `# frozen_string_literal: true`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylefrozenstringliteralcomment],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "480be6c99925724ea2ad584a1cf6a075724bd29c", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Style/FrozenStringLiteralComment",
      message: "Missing magic comment `# frozen_string_literal: true`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylefrozenstringliteralcomment],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "a56cfa66045cc9bb9983be19974153631bbce34a", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "0.79.0" },
  warnings: [{ message: ".rubocop.yml: Style/Tab has the wrong namespace - should be Layout", file: ".rubocop.yml" }]
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
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "511481791f8837a45b800975920a1b91e36a9824", original_line: 3, final_line: 3
      }
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
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 14 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "c531a809c818b12596f956691930f7ec152d0a32", original_line: 2, final_line: 2
      }
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
      git_blame_info: {
        commit: :_, line_hash: "0eee5f8e262670825a864acd4e0c0b96923c9f92", original_line: 12, final_line: 12
      }
    },
    {
      message: "Do not chain ordinary method call after safe navigation operator.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintsafenavigationchain],
      id: "Lint/SafeNavigationChain",
      path: "drink.rb",
      location: { start_line: 18, start_column: 21, end_line: 18, end_column: 27 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "e78757546aea0e7ddb7aa4dabf48b7bf1d02780a", original_line: 18, final_line: 18
      }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version },
  warnings: [
    {
      message: /The `linter.rubocop.options` option is deprecated/,
      file: "sideci.yml"
    },
    {
      message: "my.rubocop.yml: Metrics/LineLength has the wrong namespace - should be Layout",
      file: "my.rubocop.yml"
    }
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
      git_blame_info: {
        commit: :_, line_hash: "511481791f8837a45b800975920a1b91e36a9824", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "0.71.0" },
  warnings: [
    {
      message: "`-R/--rails` option and Rails cops will be removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.",
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
      git_blame_info: {
        commit: :_, line_hash: "511481791f8837a45b800975920a1b91e36a9824", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "511481791f8837a45b800975920a1b91e36a9824", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "fe92bb5dae6d7be67a342a59856bf1f6b3041df4", original_line: 1, final_line: 1
      }
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsexit],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "2e20974092d62be36eda46801fa74cf5dfd6939a", original_line: 3, final_line: 3
      }
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsfilepath],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "13439c14669d33564a10377f854d42d8b9a9ffd8", original_line: 2, final_line: 2
      }
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
      git_blame_info: {
        commit: :_, line_hash: "fe92bb5dae6d7be67a342a59856bf1f6b3041df4", original_line: 1, final_line: 1
      }
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsexit],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "2e20974092d62be36eda46801fa74cf5dfd6939a", original_line: 3, final_line: 3
      }
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsfilepath],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "13439c14669d33564a10377f854d42d8b9a9ffd8", original_line: 2, final_line: 2
      }
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
  "old_rubocop_is_specified",
  type: "success",
  issues: [],
  analyzer: { name: "RuboCop", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        `rubocop #{default_version}` is installed instead of `0.60.0` in your `Gemfile.lock`.
        Because `0.60.0` does not satisfy our constraints `>= 0.61.0, < 2.0.0`.

        If you want to use a different version of `rubocop`, please do either:
        - Update your `Gemfile.lock` to satisfy the constraint
        - Set the `linter.rubocop.gems` option in your `sider.yml`
      MSG
      file: nil
    }
  ]
)

s.add_test(
  "old_bundler_via_gemspec",
  type: "success",
  issues: [
    {
      path: "foo.gemspec",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Gemspec/RequiredRubyVersion",
      message: "`required_ruby_version` should be specified.",
      links: %w[https://docs.rubocop.org/rubocop/cops_gemspec.html#gemspecrequiredrubyversion],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "78b32896d155565a3927c81aa4816e5512821df2", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "latest_bundler_via_gemspec",
  type: "success",
  issues: [
    {
      path: "foo.gemspec",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Gemspec/RequiredRubyVersion",
      message: "`required_ruby_version` should be specified.",
      links: %w[https://docs.rubocop.org/rubocop/cops_gemspec.html#gemspecrequiredrubyversion],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "78b32896d155565a3927c81aa4816e5512821df2", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "RuboCop", version: default_version }
)

s.add_test(
  "unexpected_error",
  type: "success",
  issues: [],
  analyzer: { name: "RuboCop", version: "0.90.0" },
  warnings: [
    {
      message: "An error occurred while Layout/EmptyLineAfterMultilineCondition cop was inspecting backtrace_silencers.rb:3:0.",
      file: "backtrace_silencers.rb"
    },
    {
      message: "An error occurred while Layout/EmptyLineAfterMultilineCondition cop was inspecting lib/backtrace_silencers2.rb:1:0.",
      file: "lib/backtrace_silencers2.rb"
    }
  ]
)

s.add_test(
  "v1.0.0",
  type: "success",
  issues: [
    {
      path: "Gemfile",
      location: { start_line: 1, start_column: 18, end_line: 1, end_column: 35 },
      id: "Lint/RedundantCopEnableDirective",
      message: "Unnecessary enabling of Bundler/GemComment.",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintredundantcopenabledirective],
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "2b6492d28753891a9c883b6043f89234caf80d53", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "1.0.0" }
)
