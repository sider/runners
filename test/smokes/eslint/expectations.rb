s = Runners::Testing::Smoke

default_version = "7.23.0"

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
      git_blame_info: {
        commit: :_, line_hash: "f3ad79b5672cb93aaade2944995ccc7766faaac4", original_line: 1, final_line: 1
      }
    },
    {
      path: "index.js",
      location: { start_line: 1, start_column: 30, end_line: 2, end_column: 2 },
      id: "no-empty",
      message: "Empty block statement.",
      links: %w[https://eslint.org/docs/rules/no-empty],
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "f3ad79b5672cb93aaade2944995ccc7766faaac4", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "ad253ddf045d147f097d310d41c67964b27ee471", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "19f7c599ce45fd313bdab7d41271e27f978a1f27", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: "6.0.0" }
)

# This test case's .eslintrc includes ESLint plugin, thus Sider fails because of the plugin unavailable.
s.add_test(
  "only_eslintrc",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "pinned_old_eslint",
  type: "success",
  issues: [
    {
      message: "'x' is assigned a value but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "41477d1b34124a7763e6dae5cb7067201fed41e4", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: default_version },
  warnings: [{ message: "Installed `eslint@4.0.0` does not satisfy our constraint `>=5.0.0 <8.0.0`. Please update it as possible.", file: "package.json" }]
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "ESLint", version: default_version })

s.add_test("no_files_with_option_target", type: "success", issues: [], analyzer: { name: "ESLint", version: default_version })

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
      git_blame_info: {
        commit: :_, line_hash: "ba6152968b30a6d813c0d157ae52a4af008787ac", original_line: 6, final_line: 6
      }
    },
    {
      message: "Missing JSX expression container around literal string",
      links: [],
      id: "react/jsx-no-literals",
      path: "src/App.jsx",
      location: { start_line: 6, start_column: 11, end_line: 6, end_column: 23 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "ba6152968b30a6d813c0d157ae52a4af008787ac", original_line: 6, final_line: 6
      }
    },
    {
      message: "`Hello world.` must be placed on a new line",
      links: [],
      id: "react/jsx-one-expression-per-line",
      path: "src/App.jsx",
      location: { start_line: 6, start_column: 11, end_line: 6, end_column: 23 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "ba6152968b30a6d813c0d157ae52a4af008787ac", original_line: 6, final_line: 6
      }
    },
    {
      message: "Component should be written as a pure function",
      links: [],
      id: "react/prefer-stateless-function",
      path: "src/App.jsx",
      location: { start_line: 3, start_column: 16, end_line: 9, end_column: 2 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "56c08f685137a9fbc5a2135a434c0ac855862bde", original_line: 3, final_line: 3
      }
    },
    {
      message: "Component is not optimized. Please add a shouldComponentUpdate method.",
      links: [],
      id: "react/require-optimization",
      path: "src/App.jsx",
      location: { start_line: 3, start_column: 16, end_line: 9, end_column: 2 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "56c08f685137a9fbc5a2135a434c0ac855862bde", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ESLint", version: "5.1.0" }
)

s.add_test(
  "broken_config",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "ESLint", version: :_ }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.eslint.npm_install` value in `sideci.yml` is invalid",
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
      git_blame_info: {
        commit: :_, line_hash: "04578e6c1c3221c3a3ac0da2f69ddace55b594ec", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: default_version },
  config_file: "sideci.yml"
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
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 83 },
      object: { severity: "warn", category: "Stylistic Issues", recommended: false },
      git_blame_info: {
        commit: :_, line_hash: "04578e6c1c3221c3a3ac0da2f69ddace55b594ec", original_line: 1, final_line: 1
      }
    },
    {
      message: "Missing semicolon.",
      links: %w[https://eslint.org/docs/rules/semi],
      id: "semi",
      path: "app.js",
      location: { start_line: 1, start_column: 83, end_line: 2, end_column: 1 },
      object: { severity: "error", category: "Stylistic Issues", recommended: false },
      git_blame_info: {
        commit: :_, line_hash: "04578e6c1c3221c3a3ac0da2f69ddace55b594ec", original_line: 1, final_line: 1
      }
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
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
    },
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/application.jsx",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
    },
    {
      message: "'foo' is not defined.",
      links: %w[https://eslint.org/docs/rules/no-undef],
      id: "no-undef",
      path: "src/index.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 12 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "1344e9df550a53b40d135830a9289d34f4246299", original_line: 1, final_line: 1
      }
    },
    {
      message: "'x' is assigned a value but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "1344e9df550a53b40d135830a9289d34f4246299", original_line: 1, final_line: 1
      }
    },
    {
      message: "'bar' is defined but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 2, start_column: 10, end_line: 2, end_column: 13 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "7961454e7d4897ddbb8ff6ba75873a89c361aca4", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" },
  warnings: [{ message: "The `linter.eslint.dir` option is deprecated. Please use the `linter.eslint.target` option instead in your `sideci.yml`.", file: "sideci.yml" }]
)

s.add_test(
  "no_ignore",
  type: "success",
  issues: [
    {
      message: "Parsing error: 'import' and 'export' may appear only with 'sourceType: module'",
      links: [],
      id: "f5e284aac9909f94f39932ce3290c6171d728ba2",
      path: "src/App.jsx",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
    },
    {
      message: "Parsing error: 'import' and 'export' may appear only with 'sourceType: module'",
      links: [],
      id: "f5e284aac9909f94f39932ce3290c6171d728ba2",
      path: "src/index.jsx",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
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
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
    },
    {
      message: "Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "0299e5a2c549669334ef4905ed3a636d9ae07723",
      path: "src/application.jsx",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "6033e7a3a30a7570c4033dd784209f02ea9affa7", original_line: 1, final_line: 1
      }
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
        Parsing error: Missing semicolon

          1 | function bar() {
        > 2 |   var x = foo:
            |              ^
          3 |   for (;;) {
          4 |     break x;
          5 |   }
      MESSAGE
      links: [],
      id: "a146e219901ecca16bd2c00873406719d6b503d5",
      path: "index.js",
      location: { start_line: 2, start_column: 14 },
      object: { severity: "error", category: nil, recommended: nil },
      git_blame_info: {
        commit: :_, line_hash: "c1b43b28d2de5aeb81959f4eb99eb0fa83753069", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "ESLint", version: "5.16.0" }
)

s.add_test("default_version_is_used", type: "success", issues: [], analyzer: { name: "ESLint", version: default_version })

# NOTE: `yarn.lock` is ignored.
s.add_test(
  "mismatched_package_version",
  type: "success",
  issues: [
    {
      id: "no-unused-vars",
      message: "'x' is assigned a value but never used.",
      links: %w[https://eslint.org/docs/rules/no-unused-vars],
      path: "src/index.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "1344e9df550a53b40d135830a9289d34f4246299", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: "6.8.0" }
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
      git_blame_info: {
        commit: :_, line_hash: "b08eba45f95518788b876fcfad0b8760e767fea6", original_line: 1, final_line: 1
      }
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
        https://github.com/typescript-eslint/typescript-eslint/blob/v4.20.0/packages/eslint-plugin/docs/rules/no-unused-vars.md
      ],
      path: "index.ts",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 8 },
      object: { severity: "warn", category: "Variables", recommended: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "88b17d4beeec7112cf85384c64daffaba01244d2", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: default_version }
)

# NOTE: `package-lock.json` is preferred over `yarn.lock`.
s.add_test(
  "duplicate_lock_files",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "5.1.0" }
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
      git_blame_info: {
        commit: :_, line_hash: "089c7565d54e338b719647421b55b3e644cf0a4b", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: "7.0.0" }
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      id: "no-extra-semi",
      message: "Unnecessary semicolon.",
      links: %w[https://eslint.org/docs/rules/no-extra-semi],
      path: "foo.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "5786438d311af019d0e3d06977c4ab84a25d591b", original_line: 1, final_line: 1
      }
    },
    {
      id: "no-extra-semi",
      message: "Unnecessary semicolon.",
      links: %w[https://eslint.org/docs/rules/no-extra-semi],
      path: "src/bar.js",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 6 },
      object: { severity: "error", category: "Possible Errors", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "5f94a2b6c745ba6538ff265a8d1f1f98b8538623", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ESLint", version: default_version },
  config_file: "sider.yml"
)

s.add_test(
  "yarnrc",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "7.14.0" }
)

s.add_test(
  "yarnrc_yml",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "7.13.0" }
)

s.add_test(
  "pre_installed_packages",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "package_lock_v2",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "7.22.0" }
)

s.add_test(
  "package_lock_v2_mismatch",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "6.8.0" }
)

s.add_test(
  "package_lock_without_package_json",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: default_version }
)

s.add_test(
  "option_dependencies",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "6.8.0" }
)

s.add_test(
  "option_dependencies_missing",
  type: "failure",
  message: /`npm install` failed. If you want to avoid this installation, try one of the following in your `sider.yml`/,
  analyzer: :_
)

s.add_test(
  "option_dependencies_outdated",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: default_version },
  warnings: [{ message: "Installed `eslint@4.19.1` does not satisfy our constraint `>=5.0.0 <8.0.0`. Please update it as possible.", file: "package.json" }]
)

s.add_test(
  "unmet_peer_deps",
  type: "success",
  issues: [],
  analyzer: { name: "ESLint", version: "7.21.0" }
)

s.add_test(
  "option_global",
  type: "success",
  issues: [
    {
      id: "no-undef",
      message: "'unknown' is not defined.",
      links: %w[https://eslint.org/docs/rules/no-undef],
      path: "foo.js",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 8 },
      object: { severity: "error", category: "Variables", recommended: true },
      git_blame_info: {
        commit: :_, line_hash: "ad0c28a04d30c0f5a968852042a892ccc53b4984", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ESLint", version: default_version }
)
