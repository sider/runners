Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "no_config",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "ESLint", version: "6.8.0" }
  }
)

# This test case's .eslintrc includes ESLint plugin, thus Sider fails because of the plugin unavailable.
Smoke.add_test(
  "only_eslintrc",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message:
      Regexp.new(
        Regexp.quote(<<~MESSAGE)
          Oops! Something went wrong! :(

          ESLint: 6.8.0.

          ESLint couldn't find the plugin "eslint-plugin-filenames".
  MESSAGE
      ),
    analyzer: { name: "ESLint", version: "6.8.0" }
  }
)

Smoke.add_test(
  "pinned_old_eslint",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: <<~MSG
      Your `eslint` settings could not satisfy the required constraints. Please check your `package.json` again.
      If you want to analyze via the Sider default settings, please configure your `sideci.yml`. For details, see the documentation.
    MSG
      .strip,
    analyzer: nil
  }
)

Smoke.add_test(
  "no_files",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "ESLint", version: "6.8.0" } }
)

Smoke.add_test(
  "pinned_eslint5",
  {
    guid: "test-guid",
    timestamp: :_,
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
  }
)

Smoke.add_test(
  "broken_config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: /Error: ESLint configuration in .eslintrc.yml is invalid:/,
    analyzer: { name: "ESLint", version: :_ }
  }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message:
      "The value of the attribute `$.linter.eslint.npm_install` in your `sideci.yml` is invalid. Please fix and retry.",
    analyzer: nil
  }
)

Smoke.add_test(
  "quiet",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "ESLint", version: "6.8.0" }
  },
  {
    warnings: [
      {
        message: <<~MSG
          DEPRECATION WARNING!!!
          The `$.linter.eslint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
          Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/javascript/eslint ).
        MSG
          .strip,
        file: "sideci.yml"
      }
    ]
  }
)

Smoke.add_test(
  "array_ignore_pattern",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "ESLint", version: "6.8.0" }
  }
)

Smoke.add_test(
  "sider_config",
  {
    guid: "test-guid",
    timestamp: :_,
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
  }
)

Smoke.add_test(
  "no_ignore",
  {
    guid: "test-guid",
    timestamp: :_,
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
  }
)

Smoke.add_test(
  "additional_options",
  {
    guid: "test-guid",
    timestamp: :_,
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
  }
)

Smoke.add_test(
  "prefer_npm_install_true_to_eslintrc",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: <<~MESSAGE
          Parsing error: Unexpected token, expected ";"

            1 | function bar() {
          > 2 |   var x = foo:
              |              ^
            3 |   for (;;) {
            4 |     break x;
            5 |   }
      MESSAGE
          .rstrip,
        links: [],
        id: "d91b54561db04524f183f5f8dee752dcf1d4fcb0",
        path: "index.js",
        location: { start_line: 2 },
        object: { severity: "error", category: nil, recommended: nil },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "ESLint", version: "5.16.0" }
  }
)

Smoke.add_test(
  "default_version_is_used",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "ESLint", version: "6.8.0" } }
)

Smoke.add_test(
  "mismatched_package_version",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`.",
    analyzer: nil
  }
)

Smoke.add_test(
  "eslintrc_js",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "ESLint", version: "6.8.0" }
  }
)

Smoke.add_test(
  "typescript",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "ESLint", version: "6.5.1" }
  },
  {
    warnings: [
      { message: /The required dependency `eslint` may not have been correctly installed/, file: "package.json" }
    ]
  }
)

Smoke.add_test(
  "duplicate_lock_files",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "ESLint", version: "5.16.0" } },
  { warnings: [{ message: /Two lock files `package-lock.json` and `yarn.lock` are found/, file: "yarn.lock" }] }
)
