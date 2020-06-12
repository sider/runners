s = Runners::Testing::Smoke

default_version = "6.0.1"

s.add_test(
  "multiline",
  type: "success",
  issues: [
    {
      path: "cat.rb",
      location: { start_line: 4 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "cat.rb",
      location: { start_line: 5 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "cat.rb",
      location: { start_line: 6 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version }
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
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version }
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
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version },
  warnings: [{ message: "Detected syntax error in `error.rb`", file: "error.rb" }]
)

s.add_test(
  "exist_reek_config",
  type: "success",
  issues: [
    {
      message: "`Summer#weekend` has 3 parameters",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Long-Parameter-List.md],
      id: "LongParameterList",
      path: "summer.rb",
      location: { start_line: 7 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "`Summer#summer_vacation` performs a nil-check",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Nil-Check.md],
      id: "NilCheck",
      path: "summer.rb",
      location: { start_line: 12 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version }
)

s.add_test(
  "renamed_rule",
  type: "error",
  class: "Runners::Shell::ExecError",
  backtrace: :_,
  inspect: :_,
  analyzer: { name: "Reek", version: default_version }
)

s.add_test(
  "v4_config_style",
  type: "error",
  class: "Runners::Shell::ExecError",
  backtrace: :_,
  inspect: :_,
  analyzer: { name: "Reek", version: default_version }
)

s.add_test(
  "v4_config_file_exists",
  type: "success",
  issues: [
    {
      message: "`WorldCup#europe` has 14 parameters",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Long-Parameter-List.md],
      id: "LongParameterList",
      path: "world_cup.rb",
      location: { start_line: 3 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version }
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
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Module-Initialize.md],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        `reek 6.0.1` is installed instead of `4.0.0` in your `Gemfile.lock`.
        Because `4.0.0` does not satisfy our constraints `>= 4.4.0, < 7.0.0`.

        If you want to use a different version of `reek`, please do either:
        - Update your `Gemfile.lock` to satisfy the constraint
        - Set the `linter.reek.gems` option in your `sider.yml`
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
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Nil-Check.md],
      id: "NilCheck",
      path: "app/models/seasons/test/summer.rb",
      location: { start_line: 8 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Reek", version: default_version }
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
  analyzer: { name: "Reek", version: default_version }
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
  analyzer: { name: "Reek", version: default_version }
)
