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
      git_blame_info: {
        commit: :_, line_hash: "8275894a275e58036cb4ec633278ddcad508aa3a", original_line: 2, final_line: 2
      }
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
      git_blame_info: {
        commit: :_, line_hash: "8275894a275e58036cb4ec633278ddcad508aa3a", original_line: 4, final_line: 4
      }
    },
    {
      message: '"offense" is a misspelling of "offence"',
      links: [],
      id: "offence",
      path: "badspell.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 9 },
      object: { correct: "offence", incorrect: "offense" },
      git_blame_info: {
        commit: :_, line_hash: "c502c8e58ba42d1e6512162c5f9a3f4e8fbbb9f5", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "b91a909a91c32be0ac14d77b4c4ea2c117dd6204", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "0d278f9a2d0ae3f1200483b7d8334bf1209f2fd3", original_line: 2, final_line: 2
      }
    },
    {
      message: '"comminucation" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "target_dir/foo.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: { correct: "communications", incorrect: "comminucation" },
      git_blame_info: {
        commit: :_, line_hash: "cc7e8d7fadb7fd9a8ea0fe07cc3bd65a69f4b8ab", original_line: 3, final_line: 3
      }
    },
    {
      message: '"comminucation" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "target_file.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 15 },
      object: { correct: "communications", incorrect: "comminucation" },
      git_blame_info: {
        commit: :_, line_hash: "cc7e8d7fadb7fd9a8ea0fe07cc3bd65a69f4b8ab", original_line: 3, final_line: 3
      }
    },
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "target_dir/bar.rb",
      location: { start_line: 3, start_column: 2, end_line: 3, end_column: 12 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: {
        commit: :_, line_hash: "5fe97ba1a0d637bd858f81b277966a2342525b2e", original_line: 3, final_line: 3
      }
    },
    {
      message: '"recieve" is a misspelling of "receive"',
      links: [],
      id: "receive",
      path: "target_dir/foo.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: { correct: "receive", incorrect: "recieve" },
      git_blame_info: {
        commit: :_, line_hash: "7a8f0d1141edf4dbedba9cf7c6f887b044741827", original_line: 2, final_line: 2
      }
    },
    {
      message: '"recieve" is a misspelling of "receive"',
      links: [],
      id: "receive",
      path: "target_file.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 },
      object: { correct: "receive", incorrect: "recieve" },
      git_blame_info: {
        commit: :_, line_hash: "7a8f0d1141edf4dbedba9cf7c6f887b044741827", original_line: 2, final_line: 2
      }
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
      git_blame_info: {
        commit: :_, line_hash: "a11583e8c01f26f5f8266d5468e81d1380178a33", original_line: 2, final_line: 2
      }
    },
    {
      message: '"communiaction" is a misspelling of "communications"',
      links: [],
      id: "communications",
      path: "partial_exclude_dir/target.html",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 18 },
      object: { correct: "communications", incorrect: "communiaction" },
      git_blame_info: {
        commit: :_, line_hash: "4a61c3ab6e5ef7f24bfd8ecc53cd334139d37178", original_line: 1, final_line: 1
      }
    },
    {
      message: '"internelized" is a misspelling of "internalized"',
      links: [],
      id: "internalized",
      path: "partial_exclude_dir/bar_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: { correct: "internalized", incorrect: "internelized" },
      git_blame_info: {
        commit: :_, line_hash: "12f3058f6b6290c9ac313f6cc57b430f10b5090a", original_line: 1, final_line: 1
      }
    },
    {
      message: '"optimizacion" is a misspelling of "optimization"',
      links: [],
      id: "optimization",
      path: "partial_exclude_dir/bar_dir/target.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 21 },
      object: { correct: "optimization", incorrect: "optimizacion" },
      git_blame_info: {
        commit: :_, line_hash: "9f24938775a0c82c5ba8ed77d83556d3d7a56098", original_line: 1, final_line: 1
      }
    },
    {
      message: '"profissional" is a misspelling of "professional"',
      links: [],
      id: "professional",
      path: "foo_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: { correct: "professional", incorrect: "profissional" },
      git_blame_info: {
        commit: :_, line_hash: "a803af7ab7cfb97720efb260d7573e856ca3b732", original_line: 2, final_line: 2
      }
    },
    {
      message: '"requeriments" is a misspelling of "requirements"',
      links: [],
      id: "requirements",
      path: "foo_dir/another_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 },
      object: { correct: "requirements", incorrect: "requeriments" },
      git_blame_info: {
        commit: :_, line_hash: "7a58f2552315e14dc40d1231a0f8a2ee14bab992", original_line: 1, final_line: 1
      }
    },
    {
      message: '"scholarhsips" is a misspelling of "scholarships"',
      links: [],
      id: "scholarships",
      path: "foo_dir/another_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 },
      object: { correct: "scholarships", incorrect: "scholarhsips" },
      git_blame_info: {
        commit: :_, line_hash: "78e65ac697d6deb33dea1e01bc131a7541c2428f", original_line: 2, final_line: 2
      }
    },
    {
      message: '"trasnmission" is a misspelling of "transmissions"',
      links: [],
      id: "transmissions",
      path: "partial_exclude_dir/foo_dir/target.py",
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 16 },
      object: { correct: "transmissions", incorrect: "trasnmission" },
      git_blame_info: {
        commit: :_, line_hash: "7ebdb2efbe74a5fa57191e997760ad5fbcb2a67c", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)

s.add_offline_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.misspell.locale` value in `sideci.yml` is invalid",
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
      git_blame_info: {
        commit: :_, line_hash: "2fc7ae70299acc6d6438e7997e3dc4b23790de68", original_line: 1, final_line: 1
      }
    },
    {
      message: '"infomation" is a misspelling of "information"',
      links: [],
      id: "information",
      path: "file1.rb",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 14 },
      object: { correct: "information", incorrect: "infomation" },
      git_blame_info: {
        commit: :_, line_hash: "2fc7ae70299acc6d6438e7997e3dc4b23790de68", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Misspell", version: default_version }
)
