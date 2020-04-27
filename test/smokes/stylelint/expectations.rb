s = Runners::Testing::Smoke

s.add_test(
  "success",
  analyzer: { name: "stylelint", version: "10.0.1" },
  type: "success",
  issues: [
    {
      path: "test.sss",
      location: { start_line: 2 },
      id: "block-closing-brace-newline-before",
      message: "Expected newline before \"}\" of a multi-line block",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/block-closing-brace-newline-before]
    },
    {
      path: "test.sss",
      location: { start_line: 1 },
      id: "block-opening-brace-space-before",
      message: "Expected single space before \"{\"",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/block-opening-brace-space-before]
    },
    {
      path: "test.less",
      location: { start_line: 8 },
      id: "declaration-block-trailing-semicolon",
      message: "Expected a trailing semicolon",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/declaration-block-trailing-semicolon]
    },
    {
      path: "test.sss",
      location: { start_line: 2 },
      id: "declaration-block-trailing-semicolon",
      message: "Expected a trailing semicolon",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/declaration-block-trailing-semicolon]
    },
    {
      path: "test.scss",
      location: { start_line: 2 },
      id: "indentation",
      message: "Expected indentation of 2 spaces",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/indentation]
    },
    {
      path: "test.less",
      location: { start_line: 11 },
      id: "max-empty-lines",
      message: "Expected no more than 1 empty line",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/max-empty-lines]
    },
    {
      path: "test.less",
      location: { start_line: 12 },
      id: "max-empty-lines",
      message: "Expected no more than 1 empty line",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/max-empty-lines]
    },
    {
      path: "test.css",
      location: { start_line: 2 },
      id: "property-no-unknown",
      message: "Unexpected unknown property \"someattr\"",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/property-no-unknown]
    },
    {
      path: "test.scss",
      location: { start_line: 6 },
      id: "property-no-unknown",
      message: "Unexpected unknown property \"font-color\"",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/property-no-unknown]
    },
    {
      path: "test.scss",
      location: { start_line: 3 },
      id: "rule-empty-line-before",
      message: "Expected empty line before rule",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/rule-empty-line-before]
    },
    {
      path: "test.scss",
      location: { start_line: 5 },
      id: "rule-empty-line-before",
      message: "Expected empty line before rule",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/rule-empty-line-before]
    },
    {
      path: "test.scss",
      location: { start_line: 11 },
      id: "scss/dollar-variable-pattern",
      message: "Expected $ variable name to match specified pattern",
      object: { severity: "warning" },
      git_blame_info: nil,
      links: []
    },
    {
      path: "test.less",
      location: { start_line: 13 },
      id: "selector-type-no-unknown",
      message: "Unexpected unknown type selector \"hoge\"",
      object: { severity: "error" },
      git_blame_info: nil,
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/selector-type-no-unknown]
    }
  ]
)

s.add_test(
  "no_config",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      path: "test.css",
      location: { start_line: 2 },
      id: "color-no-invalid-hex",
      message: "Unexpected invalid hex color \"#100000000\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/color-no-invalid-hex],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      path: "test.css",
      location: { start_line: 1 },
      id: "selector-type-no-unknown",
      message: "Unexpected unknown type selector \"foo\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/selector-type-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "analyse-only-css",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "failure",
  message: /Error: Could not find "stylelint-config-standard"/
)

s.add_test("without-css", analyzer: { name: "stylelint", version: "13.2.0" }, type: "success", issues: [])

s.add_test("without-css-v9", analyzer: { name: "stylelint", version: "9.10.1" }, type: "success", issues: [])

s.add_test(
  "with_options",
  analyzer: { name: "stylelint", version: "8.4.0" },
  type: "success",
  issues: [
    {
      message: "Unnecessary curly bracket",
      links: [],
      id: "CssSyntaxError",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Expected newline before \"}\" of a multi-line block",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/block-closing-brace-newline-before],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Expected single space before \"{\"",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/block-opening-brace-space-before],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    }
  ]
)

s.add_test(
  "syntax-error",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      message: "Unclosed block",
      links: [],
      id: "CssSyntaxError",
      path: "ng.css",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Unexpected unknown property \"someattr\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "ok.css",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    }
  ]
)

s.add_test(
  "only_stylelintrc",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      message: "Unexpected unknown property \"someattr\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.css",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Unexpected unknown property \"font-color\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 6 }
    },
    {
      message: "Unexpected unknown type selector \"hoge\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 13 }
    }
  ]
)

s.add_test(
  "only_stylelintrc_without_packages",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      message: "Expected empty line before closing brace",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 16 }
    },
    {
      message: "Expected empty line before closing brace",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 17 }
    },
    {
      message: "Expected empty line before closing brace",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 20 }
    },
    {
      message: "Expected empty line before closing brace",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 21 }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 19 }
    }
  ]
)

s.add_test(
  "pinned_stylelint_version",
  analyzer: :_, type: "failure", message: /Your `stylelint` settings could not satisfy the required constraints/
)

s.add_test(
  "only_stylelint_in_package_json",
  analyzer: { name: "stylelint", version: "8.4.0" },
  type: "success",
  issues: [
    {
      message: "Unexpected missing generic font family",
      links: %w[
        https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/font-family-no-missing-generic-family-keyword
      ],
      id: "font-family-no-missing-generic-family-keyword",
      path: "test.css",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 6 }
    },
    {
      message: "Unexpected unknown property \"someattr\"",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.css",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Unexpected unknown type selector \"hoge\"",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 13 }
    }
  ]
)

s.add_test(
  "npm_install_without_stylelint",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 8 }
    },
    {
      message: "Expected indentation of 2 spaces",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/indentation],
      id: "indentation",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/max-empty-lines],
      id: "max-empty-lines",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 11 }
    },
    {
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/max-empty-lines],
      id: "max-empty-lines",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 12 }
    },
    {
      message: "Unexpected unknown property \"font-color\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 6 }
    },
    {
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/rule-empty-line-before],
      id: "rule-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 3 }
    },
    {
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/rule-empty-line-before],
      id: "rule-empty-line-before",
      path: "test.scss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 5 }
    },
    {
      message: "Unexpected unknown type selector \"hoge\"",
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 13 }
    }
  ],
  warnings: [
    { message: /The required dependency `stylelint` may not have been correctly installed/, file: "package.json" }
  ]
)

s.add_test("failed_to_npm_install", analyzer: :_, type: "failure", message: /`npm install` failed./)

s.add_test(
  "without_npm_install",
  analyzer: { 'name': "stylelint", version: "8.4.0" },
  type: "failure",
  message: /Could not find "stylelint-processor-html"/
)

s.add_test(
  "broken_sideci_yml",
  analyzer: :_,
  type: "failure",
  message:
    "The value of the attribute `$.linter.stylelint.options.ignore-path` in your `sideci.yml` is invalid. Please fix and retry."
)

s.add_test(
  "options_is_deprecated",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [],
  warnings: [
    {
      message: <<~MSG.strip,
DEPRECATION WARNING!!!
The `$.linter.stylelint.options` option(s) in your `sider.yml` are deprecated and will be removed in the near future.
Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/css/stylelint ).
MSG
      file: "sider.yml"
    }
  ]
)

s.add_test(
  "additional_options",
  analyzer: { 'name': "stylelint", version: "9.10.1" },
  type: "success",
  issues: [
    {
      message: "Expected newline before \"}\" of a multi-line block",
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/block-closing-brace-newline-before],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    },
    {
      message: "Expected single space before \"{\"",
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/block-opening-brace-space-before],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 1 }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      object: { severity: "error" },
      git_blame_info: nil,
      location: { start_line: 2 }
    }
  ]
)

s.add_test(
  "allow_empty_input_option_with_v10.0.0",
  analyzer: { 'name': "stylelint", version: "10.0.0" }, type: "success", issues: []
)

s.add_test(
  "mismatched_yarnlock_and_package_json",
  analyzer: :_,
  type: "failure",
  message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`."
)

s.add_test(
  "default_glob",
  analyzer: { name: "stylelint", version: "13.2.0" },
  type: "success",
  issues: [
    {
      path: "a.css",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      path: "a.less",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      path: "a.sass",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      path: "a.scss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      path: "a.sss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: %w[https://github.com/stylelint/stylelint/tree/13.2.0/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: nil
    }
  ]
)
