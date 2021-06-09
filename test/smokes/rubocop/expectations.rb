s = Runners::Testing::Smoke

default_version = "1.16.0"

s.add_test(
  "sandbox_rails",
  type: "success",
  issues: [
    {
      message: "Gems should be sorted in an alphabetical order within their section of the Gemfile. Gem `listen` should appear before `web-console`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_bundler.html#bundlerorderedgems],
      id: "Bundler/OrderedGems",
      path: "Gemfile",
      location: { start_line: 41, start_column: 3, end_line: 41, end_column: 26 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "d8161420157fd8efd8844ccad8e252ca61260ea9", original_line: 41, final_line: 41
      }
    },
    {
      message: "Extra blank line detected.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_layout.html#layoutemptylines
        https://rubystyle.guide#two-or-more-empty-lines
      ],
      id: "Layout/EmptyLines",
      path: "Gemfile",
      location: { start_line: 3, start_column: 1, end_line: 4, end_column: 0 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 3, final_line: 3
      }
    },
    {
      message: "Do not use space inside array brackets.",
      links: %w[https://docs.rubocop.org/rubocop/cops_layout.html#layoutspaceinsidearrayliteralbrackets],
      id: "Layout/SpaceInsideArrayLiteralBrackets",
      path: "config/environments/production.rb",
      location: { start_line: 50, start_column: 22, end_line: 50, end_column: 22 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "b613f3faa5fcac27b8334aae7d366f12641d07b2", original_line: 50, final_line: 50
      }
    },
    {
      message: "Do not use space inside array brackets.",
      links: %w[https://docs.rubocop.org/rubocop/cops_layout.html#layoutspaceinsidearrayliteralbrackets],
      id: "Layout/SpaceInsideArrayLiteralBrackets",
      path: "config/environments/production.rb",
      location: { start_line: 50, start_column: 34, end_line: 50, end_column: 34 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "b613f3faa5fcac27b8334aae7d366f12641d07b2", original_line: 50, final_line: 50
      }
    },
    {
      message: "Use `==` if you meant to do a comparison or wrap the expression in parentheses to indicate you meant to assign in a condition.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_lint.html#lintassignmentincondition
        https://rubystyle.guide#safe-assignment-in-condition
      ],
      id: "Lint/AssignmentInCondition",
      path: "bin/spring",
      location: { start_line: 11, start_column: 13, end_line: 11, end_column: 13 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "084f54bdec5c99fbfbdfa469bb734c9afcf8f98c", original_line: 11, final_line: 11
      }
    },
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
      message: "Replace unsafe number conversion with number class parsing, instead of using ENV.fetch(\"RAILS_MAX_THREADS\") { 5 }.to_i, use stricter Integer(ENV.fetch(\"RAILS_MAX_THREADS\") { 5 }, 10).",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintnumberconversion],
      id: "Lint/NumberConversion",
      path: "config/puma.rb",
      location: { start_line: 7, start_column: 17, end_line: 7, end_column: 57 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "87a9e59b8f03dcdb86ec1b5f1e293d7f72e9a37b", original_line: 7, final_line: 7
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
        https://docs.rubocop.org/rubocop/cops_lint.html#lintuselessassignment
        https://rubystyle.guide#underscore-unused-vars
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
      message: "Use nested module/class definitions instead of compact style.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleclassandmodulechildren
        https://rubystyle.guide#namespace-definition
      ],
      id: "Style/ClassAndModuleChildren",
      path: "test/test_helper.rb",
      location: { start_line: 5, start_column: 7, end_line: 5, end_column: 29 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "b8b23c5209ea33cd4f8eef9c70d4202bcf923104", original_line: 5, final_line: 5
      }
    },
    {
      message: "Use `expand_path('../Gemfile', __dir__)` instead of `expand_path('../../Gemfile', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "bin/bundle",
      location: { start_line: 2, start_column: 32, end_line: 2, end_column: 42 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "72878f05158918920f1a695082437f50b0caa002", original_line: 2, final_line: 2
      }
    },
    {
      message: "Use `expand_path('spring', __dir__)` instead of `expand_path('../spring', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "bin/rails",
      location: { start_line: 3, start_column: 13, end_line: 3, end_column: 23 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "5ed23790d51a052c9faf93ad79d686c3a117ef09", original_line: 3, final_line: 3
      }
    },
    {
      message: "Use `expand_path('spring', __dir__)` instead of `expand_path('../spring', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "bin/rake",
      location: { start_line: 3, start_column: 13, end_line: 3, end_column: 23 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "5ed23790d51a052c9faf93ad79d686c3a117ef09", original_line: 3, final_line: 3
      }
    },
    {
      message: "Use `expand_path('..', __dir__)` instead of `expand_path('../../', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "bin/setup",
      location: { start_line: 7, start_column: 30, end_line: 7, end_column: 40 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "9ed3d381ba6607c95bf22ad30e9abef985479a51", original_line: 7, final_line: 7
      }
    },
    {
      message: "Use `expand_path('..', __dir__)` instead of `expand_path('../../', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "bin/update",
      location: { start_line: 7, start_column: 30, end_line: 7, end_column: 40 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "9ed3d381ba6607c95bf22ad30e9abef985479a51", original_line: 7, final_line: 7
      }
    },
    {
      message: "Use `expand_path('../config/environment', __dir__)` instead of `expand_path('../../config/environment', __FILE__)`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#styleexpandpatharguments],
      id: "Style/ExpandPathArguments",
      path: "test/test_helper.rb",
      location: { start_line: 2, start_column: 14, end_line: 2, end_column: 24 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "c479c6b3607511740986bd7970a22aae25ca4f8e", original_line: 2, final_line: 2
      }
    },
    {
      message: "Use `$stdout` instead of `STDOUT`.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleglobalstdstream
        https://rubystyle.guide#global-stdout
      ],
      id: "Style/GlobalStdStream",
      path: "config/environments/production.rb",
      location: { start_line: 79, start_column: 50, end_line: 79, end_column: 55 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "50ef936ee42ecbff46adfe6375d1c2cf6394e0e8", original_line: 79, final_line: 79
      }
    },
    {
      message: "Do not introduce global variables.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleglobalvars
        https://rubystyle.guide#instance-vars
        https://www.zenspider.com/ruby/quickref.html
      ],
      id: "Style/GlobalVars",
      path: "app/controllers/users_controller.rb",
      location: { start_line: 33, start_column: 5, end_line: 33, end_column: 12 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "b73bba64a012e49a4a08d7340f5e847184cc8b1a", original_line: 33, final_line: 33
      }
    },
    {
      message: "`include` is used at the top level. Use inside `class` or `module`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylemixinusage],
      id: "Style/MixinUsage",
      path: "bin/setup",
      location: { start_line: 4, start_column: 1, end_line: 4, end_column: 17 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "226dfe7e35c7196ce90f9497622186c82bd9528c", original_line: 4, final_line: 4
      }
    },
    {
      message: "`include` is used at the top level. Use inside `class` or `module`.",
      links: %w[https://docs.rubocop.org/rubocop/cops_style.html#stylemixinusage],
      id: "Style/MixinUsage",
      path: "bin/update",
      location: { start_line: 4, start_column: 1, end_line: 4, end_column: 17 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "226dfe7e35c7196ce90f9497622186c82bd9528c", original_line: 4, final_line: 4
      }
    },
    {
      message: "Use underscores(_) as thousands separator and separate every 3 digits with them.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#stylenumericliterals
        https://rubystyle.guide#underscores-in-numerics
      ],
      id: "Style/NumericLiterals",
      path: "db/schema.rb",
      location: { start_line: 13, start_column: 38, end_line: 13, end_column: 51 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "0de7edd11a9ee05f32094a96f1241c60c094cd91", original_line: 13, final_line: 13
      }
    },
    {
      message: "Use `fetch(\"RAILS_MAX_THREADS\", 5)` instead of `fetch(\"RAILS_MAX_THREADS\") { 5 }`.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleredundantfetchblock
        https://github.com/JuanitoFatas/fast-ruby#hashfetch-with-argument-vs-hashfetch--block-code
      ],
      id: "Style/RedundantFetchBlock",
      path: "config/puma.rb",
      location: { start_line: 7, start_column: 21, end_line: 7, end_column: 52 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "87a9e59b8f03dcdb86ec1b5f1e293d7f72e9a37b", original_line: 7, final_line: 7
      }
    },
    {
      message: "Use `fetch(\"PORT\", 3000)` instead of `fetch(\"PORT\") { 3000 }`.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleredundantfetchblock
        https://github.com/JuanitoFatas/fast-ruby#hashfetch-with-argument-vs-hashfetch--block-code
      ],
      id: "Style/RedundantFetchBlock",
      path: "config/puma.rb",
      location: { start_line: 12, start_column: 17, end_line: 12, end_column: 38 },
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "d531369faeacba9b1fa4c7db6543cfdd3882393d", original_line: 12, final_line: 12
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "1.6.1" }
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
        https://docs.rubocop.org/rubocop/cops_style.html#styleemptymethod
        https://rubystyle.guide#no-single-line-methods
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
        https://docs.rubocop.org/rubocop/cops_layout.html#layoutindentationwidth
        https://rubystyle.guide#spaces-indentation
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
        https://docs.rubocop.org/rubocop/cops_layout.html#layouttab
        https://rubystyle.guide#spaces-indentation
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
        https://docs.rubocop.org/rubocop/cops_layout.html#layoutlinelength
        https://rubystyle.guide#80-character-limits
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
    },
    {
      message: "Reverse the order of the operands `10 < x`.",
      links: %w[
        https://docs.rubocop.org/rubocop/cops_style.html#styleyodacondition
        https://en.wikipedia.org/wiki/Yoda_conditions
      ],
      id: "Style/YodaCondition",
      path: "test.rb",
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 9 },
      object: { severity: "convention", corrected: false },
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
  message: "`linter.rubocop.gems[0]` value in `sideci.yml` is invalid"
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
      message: "Replace unsafe number conversion with number class parsing, instead of using '10'.to_i, use stricter Integer('10', 10).",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintnumberconversion],
      id: "Lint/NumberConversion",
      path: "cat.rb",
      location: { start_line: 4, start_column: 5, end_line: 4, end_column: 13 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "6f44d0bfb9b33bc338e189a4f2100afc76f476c3", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "0.71.0" },
  warnings: [
    {
      message: "`-R/--rails` option and Rails cops will be removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.",
      file: nil
    },
    {
      message: ".rubocop.yml: Layout/LineLength has the wrong namespace - should be Metrics",
      file: ".rubocop.yml"
    }
  ]
)

s.add_test(
  "v0.72_rails",
  type: "success",
  issues: [
    {
      message: "Replace unsafe number conversion with number class parsing, instead of using '10'.to_i, use stricter Integer('10', 10).",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintnumberconversion],
      id: "Lint/NumberConversion",
      path: "cat.rb",
      location: { start_line: 4, start_column: 5, end_line: 4, end_column: 13 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "6f44d0bfb9b33bc338e189a4f2100afc76f476c3", original_line: 4, final_line: 4
      }
    }
  ],
  warnings: [
    {
      message: ".rubocop.yml: Layout/LineLength has the wrong namespace - should be Metrics",
      file: ".rubocop.yml"
    }
  ],
  analyzer: { name: "RuboCop", version: "0.72.0" }
)

s.add_test(
  "v0.72_rails_option",
  type: "success",
  issues: [
    {
      message: "Replace unsafe number conversion with number class parsing, instead of using '10'.to_i, use stricter Integer('10', 10).",
      links: %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintnumberconversion],
      id: "Lint/NumberConversion",
      path: "cat.rb",
      location: { start_line: 4, start_column: 5, end_line: 4, end_column: 13 },
      object: { severity: "warning", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "6f44d0bfb9b33bc338e189a4f2100afc76f476c3", original_line: 4, final_line: 4
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
    },
    {
      message: ".rubocop.yml: Layout/LineLength has the wrong namespace - should be Metrics",
      file: ".rubocop.yml"
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
        `rubocop = #{default_version}` will be installed instead of `0.60.0` in your `Gemfile.lock`.
        Because `0.60.0` does not satisfy our constraints `>= 0.61.0, < 2.0.0`.

        If you want to use a different version of `rubocop`, please do either:
        - Update your `Gemfile.lock` to satisfy the constraint
        - Set the `linter.rubocop.dependencies` option in your `sider.yml`
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
  "plugins",
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "Rubycw/Rubycw",
      message: "assigned but unused variable - a",
      links: %w[
        https://www.rubydoc.info/gems/rubocop-rubycw/RuboCop/Cop/Rubycw/Rubycw
        https://github.com/rubocop/rubocop-rubycw
      ],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "b88f1ec0c9fe96fde96a6f9dabcbeee661dd7afe", original_line: 1, final_line: 1
      }
    },
    {
      path: "foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 10 },
      id: "ThreadSafety/NewThread",
      message: "Avoid starting new threads.",
      links: %w[
        https://www.rubydoc.info/gems/rubocop-thread_safety/RuboCop/Cop/ThreadSafety/NewThread
        https://github.com/covermymeds/rubocop-thread_safety
      ],
      object: { severity: "convention", corrected: false },
      git_blame_info: {
        commit: :_, line_hash: "11b92bcabd991bd7aff3c1edfccb2c02eb8c51f7", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "RuboCop", version: "1.9.0" }
)
