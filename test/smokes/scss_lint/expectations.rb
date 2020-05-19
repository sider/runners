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
      object: nil,
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Line should be indented 2 spaces, but was indented 4 spaces",
      links: [],
      id: "Indentation",
      path: "test.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Begin pseudo elements with double colons: `::`",
      links: [],
      id: "PseudoElement",
      path: "test.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Declaration should be terminated by a semicolon",
      links: [],
      id: "TrailingSemicolon",
      path: "test.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 2 }
    }
  ],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The support for SCSS-Lint is deprecated. Sider will drop these versions in the near future.
        Please consider using an alternative tool stylelint. See https://github.com/sds/scss-lint/blob/master/README.md#notice-consider-other-tools-before-adopting-scss-lint
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
      object: nil,
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Begin pseudo elements with double colons: `::`",
      links: [],
      id: "PseudoElement",
      path: "test.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Declaration should be terminated by a semicolon",
      links: [],
      id: "TrailingSemicolon",
      path: "test.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 2 }
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
      message: 'Syntax Error: Invalid CSS after "  color: black;": expected "}", was ""',
      links: [],
      id: "Syntax",
      path: "err.scss",
      object: nil,
      git_blame_info: nil,
      location: { start_line: 3 }
    }
  ],
  analyzer: { name: "SCSS-Lint", version: "0.59.0" },
  warnings: [{ message: /SCSS-Lint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `$.linter.scss_lint.config` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)
