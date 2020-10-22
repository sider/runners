s = Runners::Testing::Smoke

default_version = "6.0.2"

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
      git_blame_info: {
        commit: :_, line_hash: "8310170ff48fad2a764799f18dfefa31bf95ad6d", original_line: 4, final_line: 4
      }
    },
    {
      path: "cat.rb",
      location: { start_line: 5 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8310170ff48fad2a764799f18dfefa31bf95ad6d", original_line: 5, final_line: 5
      }
    },
    {
      path: "cat.rb",
      location: { start_line: 6 },
      id: "DuplicateMethodCall",
      message: "`Cat#self.call` calls 'self.new.call' 3 times",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Duplicate-Method-Call.md],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8310170ff48fad2a764799f18dfefa31bf95ad6d", original_line: 6, final_line: 6
      }
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
      git_blame_info: {
        commit: :_, line_hash: "f8045e8bf6285f3a998c455875388663da81d636", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "f8045e8bf6285f3a998c455875388663da81d636", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2ba2efdc0e35f2f2c2f51c2852f44c20aefb5080", original_line: 7, final_line: 7
      }
    },
    {
      message: "`Summer#summer_vacation` performs a nil-check",
      links: %W[https://github.com/troessner/reek/blob/v#{default_version}/docs/Nil-Check.md],
      id: "NilCheck",
      path: "summer.rb",
      location: { start_line: 12 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d8ea918d9ca033f27ca457e1c3318b9dc99d09c0", original_line: 12, final_line: 12
      }
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
      git_blame_info: {
        commit: :_, line_hash: "9d9bf2ed887527f1cbd89c433c812c10be0c38cf", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "f8045e8bf6285f3a998c455875388663da81d636", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "f8045e8bf6285f3a998c455875388663da81d636", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Reek", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        `reek #{default_version}` is installed instead of `4.0.0` in your `Gemfile.lock`.
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
      git_blame_info: {
        commit: :_, line_hash: "b6e570adb89bce0cdc6c8621d1a5d53121f40611", original_line: 8, final_line: 8
      }
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
      git_blame_info: {
        commit: :_, line_hash: "12e95c91a02b22203af6124dfc649bfc2208784f", original_line: 1, final_line: 1
      }
    },
    {
      message: "`Sub::B` has initialize method",
      links: %i[_],
      id: "ModuleInitialize",
      path: "lib/sub/b.rb",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "e338f20e54f1fd368948a287f18c446f9c96d5a0", original_line: 1, final_line: 1
      }
    },
    {
      message: "`TargetTest` has initialize method",
      links: %i[_],
      id: "ModuleInitialize",
      path: "test/target_test.rb",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "a208ef4a2876c0fa501f66268fff846e30aaad3a", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "a157412cecba53223bbc4b8ceb54992a6fba7de6", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Reek", version: default_version }
)
