s = Runners::Testing::Smoke

default_version = "7.2.0"

s.add_test(
  "no_config",
  type: "success",
  issues: [
    {
      path: "index.js",
      location: { start_line: 1, start_column: 1, end_line: 2, end_column: 2 },
      id: "for-direction",
      message: "The update clause in this loop moves the variable in the wrong direction.",
      links: %w[https://eslint.org/docs/rules/for-direction],
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: nil
    },
    {
      path: "index.js",
      location: { start_line: 1, start_column: 30, end_line: 2, end_column: 2 },
      id: "no-empty",
      message: "Empty block statement.",
      links: %w[https://eslint.org/docs/rules/no-empty],
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "no_config_v5",
  type: "success",
  issues: [
    {
      path: "index.js",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 12 },
      id: "no-console",
      message: "Unexpected console statement.",
      links: [],
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.0.0" }
)

s.add_test(
  "no_config_v6",
  type: "success",
  issues: [
    {
      path: "index.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 11 },
      id: "no-constant-condition",
      message: "Unexpected constant condition.",
      links: %w[https://eslint.org/docs/rules/no-constant-condition],
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "6.0.0" }
)

# This test case's .eslintrc includes ESLint plugin, thus Sider fails because of the plugin unavailable.
s.add_test(
  "only_eslintrc",
  type: "failure",
  message: /ESLint couldn't find the plugin "eslint-plugin-filenames"/,
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "pinned_old_eslint",
  type: "failure",
  message: <<~MSG.strip,
    Your ESLint dependencies do not satisfy our constraints `eslint@>=5.0.0 <8.0.0`. Please update them.
  MSG
  analyzer: :_
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "ESLint", version: default_version })

s.add_test(
  "pinned_eslint5",
  type: "success",
  issues: [
    {
      message: "Expected indentation of 8 space characters but found 6.",
      links: [],
      id: "react/jsx-indent",
      path: "src/App.jsx",
      location: { start_line: 6, start_column: 7, end_line: 6, end_column: 11 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Missing JSX expression container around literal string",
      links: [],
      id: "react/jsx-no-literals",
      path: "src/App.jsx",
      location: { start_line: 6, start_column: 11, end_line: 6, end_column: 23 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "`Hello world.` must be placed on a new line",
      links: [],
      id: "react/jsx-one-expression-per-line",
      path: "src/App.jsx",
      location: { start_line: 6, start_column: 11, end_line: 6, end_column: 23 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Component should be written as a pure function",
      links: [],
      id: "react/prefer-stateless-function",
      path: "src/App.jsx",
      location: { start_line: 3, start_column: 16, end_line: 9, end_column: 2 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Component is not optimized. Please add a shouldComponentUpdate method.",
      links: [],
      id: "react/require-optimization",
      path: "src/App.jsx",
      location: { start_line: 3, start_column: 16, end_line: 9, end_column: 2 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.1.0" }
)

s.add_test(
  "broken_config",
  type: "failure",
  message: /Error: ESLint configuration in .eslintrc.yml is invalid:/,
  analyzer: { name: "ESLint", version: :_ }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.eslint.npm_install` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "quiet",
  type: "success",
  issues: [
    {
      message: "Missing semicolon.",
      links: %w[https://eslint.org/docs/rules/semi],
      id: "semi",
      path: "test.js",
      location: { start_line: 1, start_column: 83, end_line: 2, end_column: 1 },
      object: { severity: "error", category: "Stylistic Issues", recommended: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The following options in your `sideci.yml` are deprecated and will be removed.
        See https://help.sider.review/tools/javascript/eslint for details.
        - `linter.eslint.options`
      MSG
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "array_ignore_pattern",
  type: "success",
  issues: [
    {
      message: "This line has a length of 82. Maximum allowed is 10.",
      links: %w[https://eslint.org/docs/rules/max-len],
      id: "max-len",
      path: "app.js",
      location: { start_line: 1 },
      object: { severity: "warn", category: "Stylistic Issues", recommended: false },
      git_blame_info: nil
    },
    {
      message: "Missing semicolon.",
      links: %w[https://eslint.org/docs/rules/semi],
      id: "semi",
      path: "app.js",
      location: { start_line: 1, start_column: 83, end_line: 2, end_column: 1 },
      object: { severity: "error", category: "Stylistic Issues", recommended: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "sider_config",
  type: "success",
  issues: [
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/application.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "'foo' is not defined.",
      links: %w[https://eslint.org/docs/rules/no-undef],
      id: "no-undef",
      path: "src/index.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 12 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: nil
    },
    {
      message: "'x' is assigned a value but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: nil
    },
    {
      message: "'bar' is defined but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 2, start_column: 10, end_line: 2, end_column: 13 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" }
)

s.add_test(
  "no_ignore",
  type: "success",
  issues: [
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/index.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" }
)

s.add_test(
  "additional_options",
  type: "success",
  issues: [
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    },
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/application.jsx",
      location: { start_line: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" }
)

s.add_test(
  "prefer_npm_install_true_to_eslintrc",
  type: "success",
  issues: [
    {
      message: <<~MESSAGE.strip,
        Parsing error: Unexpected token, expected ";"

          1 | function bar() {
        > 2 |   var x = foo:
            |              ^
          3 |   for (;;) {
          4 |     break x;
          5 |   }
      MESSAGE
      links: [],
      id: "d91b54561db04524f183f5f8dee752dcf1d4fcb0",
      path: "index.js",
      location: { start_line: 2 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" }
)

s.add_test("default_version_is_used", type: "success", issues: [], analyzer: { name: "ESLint", version: default_version })

s.add_test(
  "mismatched_package_version",
  type: "failure",
  message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`.",
  analyzer: :_
)

s.add_test(
  "eslintrc_js",
  type: "success",
  issues: [
    {
      id: "eqeqeq",
      message: "Expected '===' and instead saw '=='.",
      links: %w[https://eslint.org/docs/rules/eqeqeq],
      path: "index.js",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 9 },
      object: { severity: "error", category: "Best Practices", recommended: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "typescript",
  type: "success",
  issues: [
    {
      id: "@typescript-eslint/no-unused-vars",
      message: "'x' is assigned a value but never used.",
      links: %w[
        https://github.com/typescript-eslint/typescript-eslint/blob/v1.13.0/packages/eslint-plugin/docs/rules/no-unused-vars.md
      ],
      path: "index.ts",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 8 },
      object: { severity: "warn", category: "Variables", recommended: "warn" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "6.5.1" },
  warnings: [
    { message: "The required dependency `eslint` may not be installed and be a missing peer dependency.", file: "package.json" }
  ]
)

s.add_test(
  "duplicate_lock_files",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "5.16.0" },
  warnings: [{ message: /Two lock files `package-lock.json` and `yarn.lock` are found/, file: "yarn.lock" }]
)

s.add_test(
  "v7",
  type: "success",
  issues: [
    {
      id: "no-constant-condition",
      message: "Unexpected constant condition.",
      links: %w[https://eslint.org/docs/rules/no-constant-condition],
      path: "test.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 16 },
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "ESLint", version: "7.0.0" }
)
