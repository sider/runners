require_relative "phpcs3/expectations"

s = Runners::Testing::Smoke

default_version = "3.5.7"

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
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 18, final_line: 18
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 6, final_line: 6
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version },
  warnings: [
    {
      message: /The `linter.code_sniffer.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_test("with_php_version", type: "success", issues: :_, analyzer: { name: "PHP_CodeSniffer", version: default_version })

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
      git_blame_info: {
        commit: :_, line_hash: "d17640b09a222cb552b20361eb18540d7d3029f0", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "d17640b09a222cb552b20361eb18540d7d3029f0", original_line: 2, final_line: 2
      }
    },
    {
      path: "src/test.php",
      location: { start_line: 2, start_column: 1 },
      id: "Symfony.Commenting.FunctionComment.Missing",
      message: "Missing doc comment for function foo()",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "d17640b09a222cb552b20361eb18540d7d3029f0", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)
