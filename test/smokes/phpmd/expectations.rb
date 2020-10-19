s = Runners::Testing::Smoke

default_version = "2.9.1"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 5, end_line: 5 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "61641764da77c5a5fefa70f73a5685898dc0a081", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "invalid_rule",
  type: "failure", message: 'Invalid rule: "invalid_rule"', analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "valid_options",
  type: "success",
  issues: [
    {
      path: "app/index.php",
      location: { start_line: 23, end_line: 23 },
      id: "BooleanArgumentFlag",
      message:
        "The method bar has a boolean flag argument $flag, which is a certain sign of a Single Responsibility Principle violation.",
      links: %w[https://phpmd.org/rules/cleancode.html#booleanargumentflag],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "091c9d13217fda53898937e9d01a3d7142732e1c", original_line: 23, final_line: 23
      }
    },
    {
      path: "app/index.php",
      location: { start_line: 20, end_line: 20 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "61641764da77c5a5fefa70f73a5685898dc0a081", original_line: 20, final_line: 20
      }
    },
    {
      path: "foo.phtml",
      location: { start_line: 5, end_line: 5 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$var'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "c2aa966ad8070d426963e2f39b6de123dc586db7", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version },
  warnings: [
    {
      message: /The `linter.phpmd.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "syntax_error",
  type: "failure", message: /Unexpected end of token stream in file:/, analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "php_7.1",
  type: "success",
  issues: [
    {
      path: "SomeClass.php",
      location: { start_line: 11, end_line: 11 },
      id: "UnusedPrivateField",
      message: "Avoid unused private fields such as '$unusedVariable'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedprivatefield],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "037cc9f1e1e3dfe9a9f80adb7f04ec61c33479b4", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "php_7.3",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 7, end_line: 7 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "d16fdf5e86fd8d7c574435b5246615635201fbf0", original_line: 7, final_line: 7
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version }
)

s.add_test("with_php_version", type: "success", issues: [], analyzer: { name: "PHPMD", version: default_version })

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.phpmd.minimumpriority` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "custom_rule",
  type: "success",
  issues: [
    {
      path: "foo.php",
      location: { start_line: 3, end_line: 5 },
      id: "NoFunctions",
      message: "Please do not use functions.",
      links: %w[https://example.com/phpmd/rules/no-functions],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "47e7cf244e8c71f8c20bf148eb5416b7ba43010c", original_line: 3, final_line: 3
      }
    },
    {
      path: "Custom_NoFunctions.php",
      location: { start_line: 6, end_line: 9 },
      id: "NoMethods",
      message: "Please do not use methods.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "b23bca1d2b90b0a23d6ad65d44b9b70a198f796c", original_line: 6, final_line: 6
      }
    },
    {
      path: "custom/rules/NoMethods.php",
      location: { start_line: 8, end_line: 11 },
      id: "NoMethods",
      message: "Please do not use methods.",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "b23bca1d2b90b0a23d6ad65d44b9b70a198f796c", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "invalid_output_xml",
  type: "failure",
  message: "Invalid XML was output. See the log for details.",
  analyzer: { name: "PHPMD", version: default_version }
)

s.add_test(
  "array_options",
  type: "success",
  issues: [
    {
      path: "foo.phtml",
      location: { start_line: 5, end_line: 5 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$var'.",
      links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "c2aa966ad8070d426963e2f39b6de123dc586db7", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "PHPMD", version: default_version }
)
