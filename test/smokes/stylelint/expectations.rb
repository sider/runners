s = Runners::Testing::Smoke

default_version = "13.12.0"

s.add_test(
  "success",
  analyzer: { name: "stylelint", version: "10.0.1" },
  type: "success",
  issues: [
    {
      path: "test.sss",
      location: { start_line: 2, start_column: 12 },
      id: "block-closing-brace-newline-before",
      message: 'Expected newline before "}" of a multi-line block',
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/block-closing-brace-newline-before],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.sss",
      location: { start_line: 1, start_column: 1 },
      id: "block-opening-brace-space-before",
      message: 'Expected single space before "{"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/block-opening-brace-space-before],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8", original_line: 1, final_line: 1
      }
    },
    {
      path: "test.less",
      location: { start_line: 8, start_column: 15 },
      id: "declaration-block-trailing-semicolon",
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/declaration-block-trailing-semicolon],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "f106f8bc0c1f39d908f2e86f21e17d24531d537c", original_line: 8, final_line: 8
      }
    },
    {
      path: "test.sss",
      location: { start_line: 2, start_column: 13 },
      id: "declaration-block-trailing-semicolon",
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/declaration-block-trailing-semicolon],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.scss",
      location: { start_line: 2, start_column: 5 },
      id: "indentation",
      message: "Expected indentation of 2 spaces",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/indentation],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "6a632e487cbbe3c720f855cb014b32246fc9f2cc", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.less",
      location: { start_line: 11, start_column: 1 },
      id: "max-empty-lines",
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/max-empty-lines],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 11, final_line: 11
      }
    },
    {
      path: "test.less",
      location: { start_line: 12, start_column: 1 },
      id: "max-empty-lines",
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/max-empty-lines],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 12, final_line: 12
      }
    },
    {
      path: "test.css",
      location: { start_line: 2, start_column: 3 },
      id: "property-no-unknown",
      message: 'Unexpected unknown property "someattr"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e57d2d53ec4e822daa0f21953ceba16930f2fb9", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.scss",
      location: { start_line: 6, start_column: 7 },
      id: "property-no-unknown",
      message: 'Unexpected unknown property "font-color"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "dd97e7eb6460da8c61ebfc943266ca7043385bc7", original_line: 6, final_line: 6
      }
    },
    {
      path: "test.scss",
      location: { start_line: 3, start_column: 3 },
      id: "rule-empty-line-before",
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/rule-empty-line-before],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "081b47023eafeb633e64ef265f08fa8ff3671062", original_line: 3, final_line: 3
      }
    },
    {
      path: "test.scss",
      location: { start_line: 5, start_column: 5 },
      id: "rule-empty-line-before",
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/rule-empty-line-before],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "133c2d6f8c18db8a611db75d4a2c3f6fa6cfddb1", original_line: 5, final_line: 5
      }
    },
    {
      path: "test.scss",
      location: { start_line: 11, start_column: 1 },
      id: "scss/dollar-variable-pattern",
      message: "Expected $ variable name to match specified pattern",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "549e1c9f6fe81bc6112760484aa80657d81ad0b1", original_line: 11, final_line: 11
      }
    },
    {
      path: "test.less",
      location: { start_line: 13, start_column: 1 },
      id: "selector-type-no-unknown",
      message: 'Unexpected unknown type selector "hoge"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.0.1/lib/rules/selector-type-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b73282b5b554ad849a657f6278d9a8601d48da8b", original_line: 13, final_line: 13
      }
    }
  ]
)

s.add_test(
  "no_config",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      path: "test.css",
      location: { start_line: 2, start_column: 10 },
      id: "color-no-invalid-hex",
      message: 'Unexpected invalid hex color "#100000000"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/color-no-invalid-hex],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "65e235b2e09290002664d23832bdf646a2f43d5e", original_line: 2, final_line: 2
      }
    },
    {
      path: "test.css",
      location: { start_line: 1, start_column: 1 },
      id: "selector-type-no-unknown",
      message: 'Unexpected unknown type selector "foo"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/selector-type-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "64a11206df5ec24f2fe20ce2466f260e8c4ccae8", original_line: 1, final_line: 1
      }
    }
  ]
)

s.add_test(
  "analyze-only-css",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      path: "test.css",
      location: { start_line: 2, start_column: 3 },
      id: "property-no-unknown",
      message: 'Unexpected unknown property "someattr"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e57d2d53ec4e822daa0f21953ceba16930f2fb9", original_line: 2, final_line: 2
      }
    }
  ]
)

s.add_test("without-css", analyzer: { name: "stylelint", version: default_version }, type: "success", issues: [])

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
      location: { start_line: 1, start_column: 5 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "c7fad6f7d49e55931d1bcc14e60e902cd0efdc38", original_line: 1, final_line: 1
      }
    },
    {
      message: 'Expected newline before "}" of a multi-line block',
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/block-closing-brace-newline-before],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      location: { start_line: 2, start_column: 14 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    },
    {
      message: 'Expected single space before "{"',
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/block-opening-brace-space-before],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8", original_line: 1, final_line: 1
      }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      location: { start_line: 2, start_column: 13 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    }
  ]
)

s.add_test(
  "syntax-error",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      message: "Unclosed block",
      links: [],
      id: "CssSyntaxError",
      path: "ng.css",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3559094d3b49eb811fdba9d2df1ec8ff043008e4", original_line: 1, final_line: 1
      }
    },
    {
      message: 'Unexpected unknown property "someattr"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "ok.css",
      location: { start_line: 2, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e57d2d53ec4e822daa0f21953ceba16930f2fb9", original_line: 2, final_line: 2
      }
    }
  ]
)

s.add_test(
  "only_stylelintrc",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      message: "Expected custom property to come before declaration",
      links: [],
      id: "order/order",
      path: "test.css",
      location: { start_line: 4, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "a7514cdb0b04a95435ab2c1f71d1bc92847f9103", original_line: 4, final_line: 4
      }
    },
    {
      message: 'Unexpected unknown property "someattr"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.css",
      location: { start_line: 2, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e57d2d53ec4e822daa0f21953ceba16930f2fb9", original_line: 2, final_line: 2
      }
    },
    {
      message: 'Unexpected unknown property "font-color"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.scss",
      location: { start_line: 6, start_column: 7 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "dd97e7eb6460da8c61ebfc943266ca7043385bc7", original_line: 6, final_line: 6
      }
    },
    {
      message: 'Unexpected unknown at-rule "@functio" (at-rule-no-unknown)',
      links: [],
      id: "scss/at-rule-no-unknown",
      path: "test.scss",
      location: { start_line: 11, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "9a316db7f7aaa13dbe89d9450ebe1b9aa37050a3", original_line: 11, final_line: 11
      }
    },
    {
      message: "Unexpected empty comment",
      links: [],
      id: "scss/comment-no-empty",
      path: "test.scss",
      location: { start_line: 12, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "2a4777d6668e546d75c606ac67bd19e882af1991", original_line: 12, final_line: 12
      }
    },
    {
      message: 'Unexpected unknown type selector "hoge"',
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b73282b5b554ad849a657f6278d9a8601d48da8b", original_line: 13, final_line: 13
      }
    }
  ]
)

s.add_test(
  "only_stylelintrc_without_packages",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      message: "Expected empty line before closing brace",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 16, start_column: 5 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "e266bf187351d458abacf0d6374d1c6659d82428", original_line: 16, final_line: 16
      }
    },
    {
      message: "Expected empty line before closing brace",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 17, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "48d033810df113d5c3ca5f9231e170ffb04f3f63", original_line: 17, final_line: 17
      }
    },
    {
      message: "Expected empty line before closing brace",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 20, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "48d033810df113d5c3ca5f9231e170ffb04f3f63", original_line: 20, final_line: 20
      }
    },
    {
      message: "Expected empty line before closing brace",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/block-closing-brace-empty-line-before],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 21, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "c2b7df6201fdd3362399091f0a29550df3505b6a", original_line: 21, final_line: 21
      }
    },
    {
      message: "Expected a trailing semicolon",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      location: { start_line: 1, start_column: 20 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b19a78a5dc374fdf5b858d0464e4e9b43aa35436", original_line: 1, final_line: 1
      }
    },
    {
      message: "Expected a trailing semicolon",
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      location: { start_line: 19, start_column: 32 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "e1d75f616910f964aa13b1d24a8d429bff77fac0", original_line: 19, final_line: 19
      }
    }
  ]
)

s.add_test(
  "pinned_stylelint_version",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      message: "Unknown rule declaration-block-no-ignored-properties.",
      links: %w[
        https://github.com/stylelint/stylelint/tree/13.12.0/lib/rules/declaration-block-no-ignored-properties
      ],
      id: "declaration-block-no-ignored-properties",
      path: "test.css",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "6cb82c7c1bab86194932ba32abd0fe35f7cd6109", original_line: 1, final_line: 1
      }
    }
  ],
  warnings: [{ message: "Installed `stylelint@7.13.0` does not satisfy our constraint `>=8.3.0 <14.0.0`. Please update it as possible.", file: "package.json" }]
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
      location: { start_line: 6, start_column: 45 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "df69ad45efcf345f16e385899393082d4b9049d8", original_line: 6, final_line: 6
      }
    },
    {
      message: 'Unexpected unknown property "someattr"',
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.css",
      location: { start_line: 2, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e57d2d53ec4e822daa0f21953ceba16930f2fb9", original_line: 2, final_line: 2
      }
    },
    {
      message: 'Unexpected unknown type selector "hoge"',
      links: %w[https://github.com/stylelint/stylelint/tree/8.4.0/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b73282b5b554ad849a657f6278d9a8601d48da8b", original_line: 13, final_line: 13
      }
    }
  ]
)

# Install peer dependencies
s.add_test(
  "npm_install_without_stylelint",
  analyzer: { name: "stylelint", version: "10.1.0" },
  type: "success",
  issues: [
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.less",
      location: { start_line: 8, start_column: 15 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "f106f8bc0c1f39d908f2e86f21e17d24531d537c", original_line: 8, final_line: 8
      }
    },
    {
      message: "Expected indentation of 2 spaces",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/indentation],
      id: "indentation",
      path: "test.scss",
      location: { start_line: 2, start_column: 5 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "6a632e487cbbe3c720f855cb014b32246fc9f2cc", original_line: 2, final_line: 2
      }
    },
    {
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/max-empty-lines],
      id: "max-empty-lines",
      path: "test.less",
      location: { start_line: 11, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 11, final_line: 11
      }
    },
    {
      message: "Expected no more than 1 empty line",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/max-empty-lines],
      id: "max-empty-lines",
      path: "test.less",
      location: { start_line: 12, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 12, final_line: 12
      }
    },
    {
      message: 'Unexpected unknown property "font-color"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/property-no-unknown],
      id: "property-no-unknown",
      path: "test.scss",
      location: { start_line: 6, start_column: 7 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "dd97e7eb6460da8c61ebfc943266ca7043385bc7", original_line: 6, final_line: 6
      }
    },
    {
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/rule-empty-line-before],
      id: "rule-empty-line-before",
      path: "test.scss",
      location: { start_line: 3, start_column: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "081b47023eafeb633e64ef265f08fa8ff3671062", original_line: 3, final_line: 3
      }
    },
    {
      message: "Expected empty line before rule",
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/rule-empty-line-before],
      id: "rule-empty-line-before",
      path: "test.scss",
      location: { start_line: 5, start_column: 5 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "133c2d6f8c18db8a611db75d4a2c3f6fa6cfddb1", original_line: 5, final_line: 5
      }
    },
    {
      message: 'Unexpected unknown type selector "hoge"',
      links: %w[https://github.com/stylelint/stylelint/tree/10.1.0/lib/rules/selector-type-no-unknown],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b73282b5b554ad849a657f6278d9a8601d48da8b", original_line: 13, final_line: 13
      }
    }
  ]
)

s.add_test("failed_to_npm_install", analyzer: :_, type: "failure", message: /`npm install` failed./)

s.add_test(
  "without_npm_install",
  analyzer: { name: "stylelint", version: "8.4.0" },
  type: "failure",
  message: /Could not find "stylelint-processor-html"/
)

s.add_test(
  "broken_sideci_yml",
  analyzer: :_,
  type: "failure",
  message: "`linter.stylelint.options.ignore-path` value in `sideci.yml` is invalid"
)

s.add_test(
  "options_is_deprecated",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [],
  warnings: [
    {
      message: /The `linter.stylelint.options` option is deprecated/,
      file: "sider.yml"
    }
  ]
)

s.add_test(
  "additional_options",
  analyzer: { name: "stylelint", version: "9.10.1" },
  type: "success",
  issues: [
    {
      message: 'Expected newline before "}" of a multi-line block',
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/block-closing-brace-newline-before],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      location: { start_line: 2, start_column: 12 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    },
    {
      message: 'Expected single space before "{"',
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/block-opening-brace-space-before],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8", original_line: 1, final_line: 1
      }
    },
    {
      message: "Expected a trailing semicolon",
      links: %w[https://github.com/stylelint/stylelint/tree/9.10.1/lib/rules/declaration-block-trailing-semicolon],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      location: { start_line: 2, start_column: 13 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "0e3f74c01e7e7d8437a814bb562c4173ffdc1fef", original_line: 2, final_line: 2
      }
    }
  ]
)

s.add_test(
  "allow_empty_input_option_with_v10.0.0",
  analyzer: { name: "stylelint", version: "10.0.0" },
  type: "success",
  issues: []
)

s.add_test(
  "mismatched_yarnlock_and_package_json",
  analyzer: { name: "stylelint", version: "10.1.0" },
  type: "success",
  issues: []
)

s.add_test(
  "default_glob",
  analyzer: { name: "stylelint", version: default_version },
  type: "success",
  issues: [
    {
      path: "a.css",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2, start_column: 3 },
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "77655f0c8320932fddf4beae90e00b7c34fd8aa0", original_line: 2, final_line: 2
      }
    },
    {
      path: "a.less",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2, start_column: 3 },
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "77655f0c8320932fddf4beae90e00b7c34fd8aa0", original_line: 2, final_line: 2
      }
    },
    {
      path: "a.sass",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2, start_column: 3 },
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "6cd973a674855ca64ab47605c8d41b1c1d847a46", original_line: 2, final_line: 2
      }
    },
    {
      path: "a.scss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2, start_column: 3 },
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "77655f0c8320932fddf4beae90e00b7c34fd8aa0", original_line: 2, final_line: 2
      }
    },
    {
      path: "a.sss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2, start_column: 3 },
      links: %W[https://github.com/stylelint/stylelint/tree/#{default_version}/lib/rules/property-no-unknown],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "6cd973a674855ca64ab47605c8d41b1c1d847a46", original_line: 2, final_line: 2
      }
    }
  ]
)
