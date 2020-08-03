s = Runners::Testing::Smoke

default_version = "6.1.3"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "no-console",
      path: "range.ts",
      location: { start_line: 11, end_line: 11 },
      message: "Calls to 'console.log' are not allowed.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "a15267ba25fe1ccc78990ac24cd307c1b10d7a68", original_line: 11, final_line: 11
      }
    },
    {
      id: "no-shadowed-variable",
      path: "range.ts",
      location: { start_line: 1, end_line: 1 },
      message: "Shadowed name: 'range'",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "13aa5b6fac6f6cd30d688f141dc02da60aad8079", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "TSLint", version: default_version },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "with-tslint-json",
  type: "success",
  issues: [
    {
      id: "trailing-comma",
      path: "range.ts",
      location: { start_line: 8, end_line: 8 },
      message: "Missing trailing comma",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "59a44f8e51296f57d8cb1a11c068b15469d2f7ee", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "TSLint", version: default_version },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "npm-install",
  type: "success",
  issues: [
    {
      id: "interface-name",
      path: "hello.tsx",
      location: { start_line: 3, end_line: 3 },
      message: "interface name must start with a capitalized I",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "c882a2e6258a7f201292257388917570591d3ef5", original_line: 3, final_line: 3
      }
    },
    {
      id: "jsx-self-close",
      path: "hello.tsx",
      location: { start_line: 12, end_line: 12 },
      message: "JSX elements with no children must be self-closing",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "75d9a1c7d977206aef6297767f3ec7083cef602e", original_line: 12, final_line: 12
      }
    },
    {
      id: "member-access",
      path: "hello.tsx",
      location: { start_line: 8, end_line: 8 },
      message: "The class method 'render' must be marked either 'private', 'public', or 'protected'",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "81136f795d06ef75a88fa3f209eac8f4aae40925", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.2.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "custom-rules",
  type: "success",
  issues: [
    {
      id: "no-cats",
      path: "cat.ts",
      location: { start_line: 11, end_line: 16 },
      message: "Meow!",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d024389e623260a504954be3bf30211fb019bd0d", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.4.3" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "tsconfig",
  type: "success",
  issues: [
    {
      id: "no-console",
      path: "range.ts",
      location: { start_line: 11, end_line: 11 },
      message: "Calls to 'console.log' are not allowed.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "a15267ba25fe1ccc78990ac24cd307c1b10d7a68", original_line: 11, final_line: 11
      }
    },
    {
      id: "no-shadowed-variable",
      path: "range.ts",
      location: { start_line: 1, end_line: 1 },
      message: "Shadowed name: 'range'",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "e7fb7c6bd23ab8335453709ebc056413e9c86fc8", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "TSLint", version: default_version },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "raise-deprecated",
  type: "failure",
  message: <<~MESSAGE,
    --type-check is deprecated. You only need --project to enable rules which need type information.
    Error at range.ts:2:18: Property 'min' does not exist on type 'string'.
    Error at range.ts:2:31: Property 'middle' does not exist on type 'string'.
    Error at range.ts:2:47: Property 'middle' does not exist on type 'string'.
    Error at range.ts:2:63: Property 'max' does not exist on type 'string'.
    Error at range.ts:11:24: Argument of type '{ min: number; middle: number; max: number; }' is not assignable to parameter of type 'string'.
  MESSAGE
  analyzer: { name: "TSLint", version: default_version },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The support for TSLint is deprecated and will be removed on December 1, 2020.
        Please migrate to ESLint as an alternative. See https://github.com/palantir/tslint/issues/4534
      MSG
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "deprecated-rules",
  type: "success",
  issues: [
    {
      id: "no-unused-variable",
      path: "index.ts",
      location: { start_line: 2, end_line: 2 },
      message: "'a' is declared but its value is never read.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ff081cb5415eddf6d26903d04f001dfc79d24c6b", original_line: 2, final_line: 2
      }
    },
    {
      id: "no-unused-variable",
      path: "index.ts",
      location: { start_line: 2, end_line: 2 },
      message: "'b' is declared but its value is never read.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ff081cb5415eddf6d26903d04f001dfc79d24c6b", original_line: 2, final_line: 2
      }
    },
    {
      id: "no-unused-variable",
      path: "index.ts",
      location: { start_line: 5, end_line: 5 },
      message: "All destructured elements are unused.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "4e197a6014833e2daea6234c92a9a9fe7c604bb9", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.11.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "The value of the attribute `linter.tslint.config` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "with_options",
  type: "success",
  issues: [
    {
      message: "Type declaration of 'any' loses type-safety. Consider replacing it with a more precise type.",
      links: [],
      id: "no-any",
      path: "src/range.ts",
      location: { start_line: 1, end_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "13aa5b6fac6f6cd30d688f141dc02da60aad8079", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "rules-dir",
  type: "success",
  issues: [
    {
      id: "no-cats",
      path: "cat.ts",
      location: { start_line: 11, end_line: 16 },
      message: "Meow!",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d024389e623260a504954be3bf30211fb019bd0d", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "multiple-custom-rules",
  type: "success",
  issues: [
    {
      message: "Meow!",
      links: [],
      id: "no-cats",
      path: "cat.ts",
      location: { start_line: 11, end_line: 16 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d024389e623260a504954be3bf30211fb019bd0d", original_line: 11, final_line: 11
      }
    },
    {
      message: "Bow!",
      links: [],
      id: "no-dogs",
      path: "dog.ts",
      location: { start_line: 11, end_line: 16 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "0201bf4912745003e0006214b745f6b1857092ee", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sideci.yml" }]
)

s.add_test(
  "invalid-tslint-version",
  type: "failure",
  message: "Your TSLint dependencies do not satisfy our constraints `tslint@>=5.0.0 <7.0.0`. Please update them.",
  analyzer: :_,
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "without-tslint-in-package-json",
  type: "success",
  issues: [],
  analyzer: { name: "TSLint", version: default_version },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "without-tslint-and-with-typescript-in-package-json",
  type: "success",
  issues: [],
  analyzer: { name: "TSLint", version: default_version },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "mismatched_package_version",
  type: "failure",
  message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`.",
  analyzer: :_,
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)

s.add_test(
  "tslint-v6",
  type: "success",
  issues: [
    {
      id: "no-console",
      path: "foo.ts",
      location: { start_line: 1, end_line: 1 },
      message: "Calls to 'console.log' are not allowed.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "2972476e78a4fa70fb92bc19e8191c736906cfdb", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "TSLint", version: "6.0.0" },
  warnings: [{ message: /The support for TSLint is deprecated/, file: "sider.yml" }]
)
