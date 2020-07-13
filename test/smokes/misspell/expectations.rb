s = Runners::Testing::Smoke

default_version = "0.3.4"

s.add_offline_test(
  "success",
  type: "success",
  issues: [
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "badspell.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 12 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)

s.add_offline_test(
  "locale",
  type: "success",
  issues: [
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "badspell.rb",
      location: { start_line: 4, start_column: 2, end_line: 4, end_column: 12 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: nil
    },
    {
      message: '"offense" is a misspelling of "offence"',
      links: [],
      id: "offence",
      path: "badspell.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 9 },
      object: { correct: "offence", incorrect: "offense" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version },
  warnings: [
    {
      message: /The `linter.misspell.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_offline_test(
  "ignore",
  type: "success",
  issues: [
    {
      message: '"recieve" is a misspelling of "receive"',
      links: [],
      id: "receive",
      path: "badspell.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 9 },
      object: { correct: "receive", incorrect: "recieve" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)

s.add_offline_test(
  "ignore_array",
  type: "success",
  issues: [],
  analyzer: { name: "Misspell", version: default_version }
)

s.add_offline_test(
  "analyze_specific_targets",
  type: "success",
  issues: [
    {
      message: '"acknowleges" is a misspelling of "acknowledges"',
      links: [],
      id: "acknowledges",
      path: "target_dir/bar.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 13 },
      object: { correct: "acknowledges", incorrect: "acknowleges" },
      git_blame_info: nil
    },
    {
      message: '"comminucation" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "target_dir/foo.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: { correct: "communications", incorrect: "comminucation" },
      git_blame_info: nil
    },
    {
      message: '"comminucation" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "target_file.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: { correct: "communications", incorrect: "comminucation" },
      git_blame_info: nil
    },
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "target_dir/bar.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 12 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: nil
    },
    {
      message: '"recieve" is a misspelling of "receive"',
      links: [],
      id: "receive",
      path: "target_dir/foo.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: { correct: "receive", incorrect: "recieve" },
      git_blame_info: nil
    },
    {
      message: '"recieve" is a misspelling of "receive"',
      links: [],
      id: "receive",
      path: "target_file.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: { correct: "receive", incorrect: "recieve" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version },
  warnings: [{ message: <<~MSG.strip, file: "sideci.yml" }]
    DEPRECATION WARNING!!!
    The `linter.misspell.targets` option is deprecated. Use the `linter.misspell.target` option instead in your `sideci.yml`.
    See https://help.sider.review/tools/others/misspell for details.
  MSG
)

s.add_offline_test(
  "exclude_targets",
  type: "success",
  issues: [
    {
      message: '"acknowleges" is a misspelling of "acknowledges"',
      links: [],
      id: "acknowledges",
      path: "target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 13 },
      object: { correct: "acknowledges", incorrect: "acknowleges" },
      git_blame_info: nil
    },
    {
      message: '"communiaction" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "partial_exclude_dir/target.html",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 18 },
      object: { correct: "communications", incorrect: "communiaction" },
      git_blame_info: nil
    },
    {
      message: '"internelized" is a misspelling of "internalized"',
      links: [],
      id: "internalized",
      path: "partial_exclude_dir/bar_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: { correct: "internalized", incorrect: "internelized" },
      git_blame_info: nil
    },
    {
      message: '"optimizacion" is a misspelling of "optimization"',
      links: [],
      id: "optimization",
      path: "partial_exclude_dir/bar_dir/target.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 21 },
      object: { correct: "optimization", incorrect: "optimizacion" },
      git_blame_info: nil
    },
    {
      message: '"profissional" is a misspelling of "professional"',
      links: [],
      id: "professional",
      path: "foo_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: { correct: "professional", incorrect: "profissional" },
      git_blame_info: nil
    },
    {
      message: '"requeriments" is a misspelling of "requirements"',
      links: [],
      id: "requirements",
      path: "foo_dir/another_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: { correct: "requirements", incorrect: "requeriments" },
      git_blame_info: nil
    },
    {
      message: '"scholarhsips" is a misspelling of "scholarships"',
      links: [],
      id: "scholarships",
      path: "foo_dir/another_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: { correct: "scholarships", incorrect: "scholarhsips" },
      git_blame_info: nil
    },
    {
      message: '"trasnmission" is a misspelling of "transmissions"',
      links: [],
      id: "transmissions",
      path: "partial_exclude_dir/foo_dir/target.py",
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 16 },
      object: { correct: "transmissions", incorrect: "trasnmission" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)

s.add_offline_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.misspell.locale` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_offline_test(
  "option_target",
  type: "success",
  issues: [
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "dir1/file.rb",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 14 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: nil
    },
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "file1.rb",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 14 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)
