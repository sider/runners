Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "SCSS-Lint", version: "0.59.0" }
  }
)

Smoke.add_test(
  "no_scss_files",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "SCSS-Lint", version: "0.59.0" } },
  warnings: [{ message: "No files, paths, or patterns were specified", file: nil }]
)

Smoke.add_test(
  "with_config_option",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "SCSS-Lint", version: "0.59.0" }
  },
  {
    warnings: [
      {
        message: <<~MSG
    DEPRECATION WARNING!!!
    The `$.linter.scss_lint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
    Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/css/scss-lint ).
  MSG
          .strip,
        file: "sideci.yml"
      }
    ]
  }
)

Smoke.add_test(
  "syntax_error",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Syntax Error: Invalid CSS after \"  color: black;\": expected \"}\", was \"\"",
        links: [],
        id: "Syntax",
        path: "err.scss",
        object: nil,
        git_blame_info: nil,
        location: { start_line: 3 }
      }
    ],
    analyzer: { name: "SCSS-Lint", version: "0.59.0" }
  }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "The value of the attribute `$.linter.scss_lint.config` of `sideci.yml` is invalid.",
    analyzer: nil
  }
)
