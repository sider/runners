require_relative "phpcs3/expectations.rb"

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app.php",
        location: { start_line: 18 },
        id: "PSR2.Files.ClosingTag.NotAllowed",
        message: "A closing tag is not permitted at the end of a PHP file",
        links: [],
        object: { type: "ERROR", severity: 5, fixable: true },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  }
)

Smoke.add_test(
  "specified_dir",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app/app.php",
        location: { start_line: 6 },
        id: "PSR2.Files.ClosingTag.NotAllowed",
        message: "A closing tag is not permitted at the end of a PHP file",
        links: [],
        object: { type: "ERROR", severity: 5, fixable: true },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  },
  warnings: [
    {
      message: <<~MSG
        DEPRECATION WARNING!!!
        The `$.linter.code_sniffer.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
        Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/php/codesniffer ).
      MSG
        .strip,
      file: "sideci.yml"
    }
  ]
)

# Regression test for large output
# See https://github.com/sideci/runner_code_sniffer/pull/27
Smoke.add_test(
  "sideci_php_sandbox",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: :_,
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  }
)

Smoke.add_test(
  "with_php_version",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: :_,
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message:
      "The attribute `$.linter.code_sniffer.extension` in your `sideci.yml` is unsupported. Please fix and retry."
  }
)

Smoke.add_test(
  "version_2",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app.php",
        location: { start_line: 18 },
        id: "PSR2.Files.ClosingTag.NotAllowed",
        message: "A closing tag is not permitted at the end of a PHP file",
        links: [],
        object: { type: "ERROR", severity: 5, fixable: true },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  },
  warnings: [
    {
      message:
        "Sider has no longer supported PHP_CodeSniffer v2. Sider executes v3 even if putting `2` as `version` option.",
      file: "sider.yml"
    }
  ]
)

Smoke.add_test(
  "autodetect_cakephp",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "app/test.php",
        location: { start_line: 2 },
        id: "CakePHP.Commenting.FunctionComment.Missing",
        message: "Missing doc comment for function foo()",
        links: [],
        object: { type: "ERROR", severity: 5, fixable: false },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  }
)

Smoke.add_test(
  "autodetect_symfony",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "src/test.php",
        location: { start_line: 2 },
        id: "Squiz.Functions.GlobalFunction.Found",
        message: "Consider putting global function \"foo\" in a static class",
        links: [],
        object: { type: "WARNING", severity: 5, fixable: false },
        git_blame_info: nil
      },
      {
        path: "src/test.php",
        location: { start_line: 2 },
        id: "Symfony.Commenting.FunctionComment.Missing",
        message: "Missing doc comment for function foo()",
        links: [],
        object: { type: "ERROR", severity: 5, fixable: false },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "PHP_CodeSniffer", version: "3.5.4" }
  }
)
