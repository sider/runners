s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "badspell.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 12 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" }
)

s.add_test(
  "locale",
  type: "success",
  issues: [
    {
      message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "badspell.rb",
      location: { start_line: 4, start_column: 2, end_line: 4, end_column: 12 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"offense\" is a misspelling of \"offence\"",
      links: [],
      id: "\"offense\" is a misspelling of \"offence\"",
      path: "badspell.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 9 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" },
  warnings: [
    {
      message: <<~MSG.strip,
DEPRECATION WARNING!!!
The `$.linter.misspell.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/others/misspell ).
MSG
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "ignore",
  type: "success",
  issues: [
    {
      message: "\"recieve\" is a misspelling of \"receive\"",
      links: [],
      id: "\"recieve\" is a misspelling of \"receive\"",
      path: "badspell.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 9 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" }
)

s.add_test(
  "analyze_specific_targets",
  type: "success",
  issues: [
    {
      message: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      links: [],
      id: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      path: "target_dir/bar.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 13 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"comminucation\" is a misspelling of \"communications\"",
      links: [],
      id: "\"comminucation\" is a misspelling of \"communications\"",
      path: "target_dir/foo.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"comminucation\" is a misspelling of \"communications\"",
      links: [],
      id: "\"comminucation\" is a misspelling of \"communications\"",
      path: "target_file.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "target_dir/bar.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 12 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"recieve\" is a misspelling of \"receive\"",
      links: [],
      id: "\"recieve\" is a misspelling of \"receive\"",
      path: "target_dir/foo.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"recieve\" is a misspelling of \"receive\"",
      links: [],
      id: "\"recieve\" is a misspelling of \"receive\"",
      path: "target_file.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" },
  warnings: [{ message: /DEPRECATION WARNING!!!\nThe `\$\.linter\.misspell\.targets` option/, file: "sideci.yml" }]
)

s.add_test(
  "exclude_targets",
  type: "success",
  issues: [
    {
      message: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      links: [],
      id: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      path: "target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 13 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"communiaction\" is a misspelling of \"communications\"",
      links: [],
      id: "\"communiaction\" is a misspelling of \"communications\"",
      path: "partial_exclude_dir/target.html",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 18 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"internelized\" is a misspelling of \"internalized\"",
      links: [],
      id: "\"internelized\" is a misspelling of \"internalized\"",
      path: "partial_exclude_dir/bar_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"optimizacion\" is a misspelling of \"optimization\"",
      links: [],
      id: "\"optimizacion\" is a misspelling of \"optimization\"",
      path: "partial_exclude_dir/bar_dir/target.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 21 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"profissional\" is a misspelling of \"professional\"",
      links: [],
      id: "\"profissional\" is a misspelling of \"professional\"",
      path: "foo_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"requeriments\" is a misspelling of \"requirements\"",
      links: [],
      id: "\"requeriments\" is a misspelling of \"requirements\"",
      path: "foo_dir/another_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"scholarhsips\" is a misspelling of \"scholarships\"",
      links: [],
      id: "\"scholarhsips\" is a misspelling of \"scholarships\"",
      path: "foo_dir/another_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"trasnmission\" is a misspelling of \"transmissions\"",
      links: [],
      id: "\"trasnmission\" is a misspelling of \"transmissions\"",
      path: "partial_exclude_dir/foo_dir/target.py",
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 16 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `$.linter.misspell.locale` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "dir1/file.rb",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 14 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "file1.rb",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 14 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: "0.3.4" }
)
