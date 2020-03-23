Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app.php",
        location: { start_line: 5, end_line: 5 },
        id: "UnusedLocalVariable",
        message: "Avoid unused local variables such as '$hoge'.",
        links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "invalid_rule",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Invalid rule: \"invalid_rule\"",
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "valid_options",
  {
    guid: "test-guid",
    timestamp: :_,
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
        git_blame_info: nil
      },
      {
        path: "app/index.php",
        location: { start_line: 20, end_line: 20 },
        id: "UnusedLocalVariable",
        message: "Avoid unused local variables such as '$hoge'.",
        links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "foo.phtml",
        location: { start_line: 5, end_line: 5 },
        id: "UnusedLocalVariable",
        message: "Avoid unused local variables such as '$var'.",
        links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHPMD", version: "2.8.1" }
  },
  {
    warnings: [
      {
        message: <<~MSG
          DEPRECATION WARNING!!!
          The `$.linter.phpmd.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
          Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/php/phpmd ).
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
    type: "failure",
    message: /Unexpected end of token stream in file:/,
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "php_7.1",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "SomeClass.php",
        location: { start_line: 11, end_line: 11 },
        id: "UnusedPrivateField",
        message: "Avoid unused private fields such as '$unusedVariable'.",
        links: %w[https://phpmd.org/rules/unusedcode.html#unusedprivatefield],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "php_7.3",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app.php",
        location: { start_line: 7, end_line: 7 },
        id: "UnusedLocalVariable",
        message: "Avoid unused local variables such as '$hoge'.",
        links: %w[https://phpmd.org/rules/unusedcode.html#unusedlocalvariable],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "with_php_version",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "PHPMD", version: "2.8.1" } }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message:
      "The value of the attribute `$.linter.phpmd.minimumpriority` in your `sideci.yml` is invalid. Please fix and retry.",
    analyzer: nil
  }
)

Smoke.add_test(
  "custom_rule",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "foo.php",
        location: { start_line: 3, end_line: 5 },
        id: "NoFunctions",
        message: "Please do not use functions.",
        links: %w[https://example.com/phpmd/rules/no-functions],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "Custom_NoFunctions.php",
        location: { start_line: 6, end_line: 9 },
        id: "NoMethods",
        message: "Please do not use methods.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "custom/rules/NoMethods.php",
        location: { start_line: 8, end_line: 11 },
        id: "NoMethods",
        message: "Please do not use methods.",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)

Smoke.add_test(
  "invalid_output_xml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Invalid XML was output. See the log for details.",
    analyzer: { name: "PHPMD", version: "2.8.1" }
  }
)
