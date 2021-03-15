require_relative "phpcs3/expectations"

s = Runners::Testing::Smoke

default_version = "3.5.8"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 1, start_column: 1 },
      id: "PSR1.Files.SideEffects.FoundWithSymbols",
      message: "A file should declare new symbols (classes, functions, constants, etc.) and cause no other side effects, or it should execute logic with side effects, but should not do both. The first symbol is defined on line 12 and the first side effect is on line 3.",
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "9166a7b7093b6ef318e436c6b16866e360ab4381", original_line: 1, final_line: 1
      }
    },
    {
      path: "app.php",
      location: { start_line: 15, start_column: 1 },
      id: "PSR12.Classes.ClosingBrace.StatementAfter",
      message: "Closing brace must not be followed by any comment or statement on the same line",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "10ced3b53ec8f72c1f3a89aa9b7f798f2ddd713a", original_line: 15, final_line: 15
      }
    },
    {
      path: "app.php",
      location: { start_line: 15, start_column: 1 },
      id: "PSR2.Classes.ClassDeclaration.CloseBraceSameLine",
      message: "Closing class brace must be on a line by itself",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "10ced3b53ec8f72c1f3a89aa9b7f798f2ddd713a", original_line: 15, final_line: 15
      }
    },
    {
      path: "app.php",
      location: { start_line: 23, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 23, final_line: 23
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
    },
    {
      path: "test/test.php",
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
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test("with_php_version", type: "success", issues: :_, analyzer: { name: "PHP_CodeSniffer", version: default_version })

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message: "`linter.code_sniffer.extension` in `sideci.yml` is unsupported"
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

s.add_test(
  "option_extensions",
  type: "success",
  issues: [
    {
      path: "foo.fcgi",
      location: { start_line: 2, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 2, final_line: 2
      }
    },
    {
      path: "foo.inc",
      location: { start_line: 2, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "option_ignore",
  type: "success",
  issues: [
    {
      path: "src/foo.php",
      location: { start_line: 2, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "option_parallel",
  type: "success",
  issues: [
    {
      path: "a.php",
      location: { start_line: 2, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 2, final_line: 2
      }
    },
    {
      path: "b.php",
      location: { start_line: 2, start_column: 1 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)
