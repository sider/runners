s = Runners::Testing::Smoke

s.add_test(
  "multiline",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 4 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "cat.rb",
      location: { start_line: 5 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "cat.rb",
      location: { start_line: 6 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test(
  "recommend_config",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 1 },
      id: "ModuleInitialize",
      message: "`Cat` has initialize method",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test(
  "syntax_error",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 1 },
      id: "ModuleInitialize",
      message: "`Cat` has initialize method",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" },
  warnings: [{ message: "Detected syntax error in `error.rb`", file: "error.rb" }]
)

s.add_test(
  "exist_reek_config",
  type: "success",
  issues: [
    {
      message: "`Summer#weekend` has 3 parameters",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Long-Parameter-List.md],
      id: "LongParameterList",
      path: "summer.rb",
      location: { start_line: 7 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "`Summer#summer_vacation` performs a nil-check",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Nil-Check.md],
      id: "NilCheck",
      path: "summer.rb",
      location: { start_line: 12 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test("renamed_rule", type: "error", class: "Runners::Shell::ExecError", backtrace: :_, inspect: :_)

s.add_test("v4_config_style", type: "error", class: "Runners::Shell::ExecError", backtrace: :_, inspect: :_)

s.add_test(
  "v4_config_file_exists",
  type: "success",
  issues: [
    {
      message: "`WorldCup#europe` has 14 parameters",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Long-Parameter-List.md],
      id: "LongParameterList",
      path: "world_cup.rb",
      location: { start_line: 3 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test(
  "lowest_deps",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 1 },
      id: "ModuleInitialize",
      message: "`Cat` has initialize method",
      links: %w[https://github.com/troessner/reek/blob/master/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "4.4.0" }
)

s.add_test(
  "unsupported",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 1 },
      id: "ModuleInitialize",
      message: "`Cat` has initialize method",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" },
  warnings: [
    {
      message: <<~MESSAGE.strip,
Sider tried to install `reek 4.0.0` according to your `Gemfile.lock`, but it installs `6.0.0` instead.
Because `4.0.0` does not satisfy the Sider constraints [\">= 4.4.0\", \"< 7.0.0\"].

If you want to use a different version of `reek`, update your `Gemfile.lock` to satisfy the constraint or specify the gem version in your `sider.yml`.
See https://help.sider.review/getting-started/custom-configuration#gems-option
MESSAGE
      file: nil
    }
  ]
)

s.add_test(
  "regex_directory_directive",
  type: "success",
  issues: [
    {
      message: "`Autumn#silver_week` performs a nil-check",
      links: %w[https://github.com/troessner/reek/blob/v6.0.0/docs/Nil-Check.md],
      id: "NilCheck",
      path: "app/models/seasons/test/summer.rb",
      location: { start_line: 8 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      message: "`A` has initialize method",
      links: %i[_],
      id: "ModuleInitialize",
      path: "lib/a.rb",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "`Sub::B` has initialize method",
      links: %i[_],
      id: "ModuleInitialize",
      path: "lib/sub/b.rb",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "`TargetTest` has initialize method",
      links: %i[_],
      id: "ModuleInitialize",
      path: "test/target_test.rb",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)

s.add_test(
  "option_config",
  type: "success",
  issues: [
    {
      message: "`nil_check` performs a nil-check",
      links: %i[_],
      id: "NilCheck",
      path: "a.rb",
      location: { start_line: 2 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: "6.0.0" }
)
