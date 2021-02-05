s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      message:
        "Color literals like `#fff` should only be used in variable declarations; they should be referred to via variable everywhere else.",
      links: [],
      id: "ColorVariable",
      path: "test.scss",
      location: { start_line: 2, start_column: 12 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8c320a269d81ef5a874a701aea17274085e4d4f4", original_line: 2, final_line: 2
      }
    },
    {
      message: "Line should be indented 2 spaces, but was indented 4 spaces",
      links: [],
      id: "Indentation",
      path: "test.scss",
      location: { start_line: 2, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8c320a269d81ef5a874a701aea17274085e4d4f4", original_line: 2, final_line: 2
      }
    },
    {
      message: "Begin pseudo elements with double colons: `::`",
      links: [],
      id: "PseudoElement",
      path: "test.scss",
      location: { start_line: 1, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d3bb175b780db30598397a7b3ddb7646d3bca43a", original_line: 1, final_line: 1
      }
    },
    {
      message: "Declaration should be terminated by a semicolon",
      links: [],
      id: "TrailingSemicolon",
      path: "test.scss",
      location: { start_line: 2, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8c320a269d81ef5a874a701aea17274085e4d4f4", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The support for SCSS-Lint is deprecated and will be removed in the near future.
        Please migrate to stylelint as an alternative. See https://github.com/sds/scss-lint#readme
      MSG
      file: "sider.yml"
    }
  ]
)

s.add_test(
  "no_scss_files",
  type: "success",
  issues: [],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [
    { message: /SCSS-Lint is deprecated/, file: "sider.yml" },
    { message: "No files, paths, or patterns were specified", file: nil }
  ]
)

s.add_test(
  "with_config_option",
  type: "success",
  issues: [
    {
      message:
        "Color literals like `#fff` should only be used in variable declarations; they should be referred to via variable everywhere else.",
      links: [],
      id: "ColorVariable",
      path: "test.scss",
      location: { start_line: 2, start_column: 12 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8c320a269d81ef5a874a701aea17274085e4d4f4", original_line: 2, final_line: 2
      }
    },
    {
      message: "Begin pseudo elements with double colons: `::`",
      links: [],
      id: "PseudoElement",
      path: "test.scss",
      location: { start_line: 1, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d3bb175b780db30598397a7b3ddb7646d3bca43a", original_line: 1, final_line: 1
      }
    },
    {
      message: "Declaration should be terminated by a semicolon",
      links: [],
      id: "TrailingSemicolon",
      path: "test.scss",
      location: { start_line: 2, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "8c320a269d81ef5a874a701aea17274085e4d4f4", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [{ message: /SCSS-Lint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "syntax_error",
  type: "success",
  issues: [
    {
      message: 'Syntax Error: Invalid CSS after "}": expected selector or at-rule, was "}"',
      links: [],
      id: "Syntax",
      path: "err.scss",
      location: { start_line: 3, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "482e90cb1adaf93f59b583ac06936515412a4319", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [{ message: /SCSS-Lint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.scss_lint.config` value in `sideci.yml` is invalid",
  analyzer: :_
)
