require_relative "phpcs3/expectations.rb"

s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 18, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "specified_dir",
  type: "success",
  issues: [
    {
      path: "app/app.php",
      location: { start_line: 6, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The following options in your `sideci.yml` are deprecated and will be removed.
        See https://help.sider.review/tools/php/code-sniffer for details.
        - `linter.code_sniffer.options`
      MSG
      file: "sideci.yml"
    }
  ]
)

# Regression test for large output
# See https://github.com/sideci/runner_code_sniffer/pull/27
s.add_test("sideci_php_sandbox", type: "success", issues: :_, analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" })

s.add_test("with_php_version", type: "success", issues: :_, analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" })

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message: "The attribute `linter.code_sniffer.extension` in your `sideci.yml` is unsupported. Please fix and retry."
)

s.add_test(
  "autodetect_cakephp",
  type: "success",
  issues: [
    {
      path: "app/test.php",
      location: { start_line: 2, start_column: 1 },
      id: "CakePHP.Commenting.FunctionComment.Missing",
      message: "Missing doc comment for function foo()",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "autodetect_symfony",
  type: "success",
  issues: [
    {
      path: "src/test.php",
      location: { start_line: 2, start_column: 1 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "foo" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "src/test.php",
      location: { start_line: 2, start_column: 1 },
      id: "Symfony.Commenting.FunctionComment.Missing",
      message: "Missing doc comment for function foo()",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)
