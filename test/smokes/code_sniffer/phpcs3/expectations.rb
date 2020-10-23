s = Runners::Testing::Smoke

default_version = "3.5.8"

s.add_test(
  "phpcs3/success",
  type: "success",
  issues: [
    {
      path: "app.php",
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

s.add_test(
  "phpcs3/specified_dir",
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
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "phpcs3/custom_argument",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 2, start_column: 1 },
      id: "PEAR.Commenting.FileComment.Missing",
      message: "Missing file doc comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 2, final_line: 2
      }
    },
    {
      path: "app.php",
      location: { start_line: 8, start_column: 1 },
      id: "Zend.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "48ee9fdb6490aadc28bbb90cee75350be54532de", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "phpcs3/cakephp",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 2, start_column: 5 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 0 but found 4",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "fe2f6bada61f4694b7151b8639de2e4c6f2b8b2c", original_line: 2, final_line: 2
      }
    },
    {
      path: "app.php",
      location: { start_line: 6, start_column: 5 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 0 but found 4",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "fe2f6bada61f4694b7151b8639de2e4c6f2b8b2c", original_line: 6, final_line: 6
      }
    },
    {
      path: "app.php",
      location: { start_line: 13, start_column: 9 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 4 but found 8",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "192a1cecbb4c97e96d633959f8647bf7840bdf79", original_line: 13, final_line: 13
      }
    },
    {
      path: "app.php",
      location: { start_line: 19, start_column: 1 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 4 but found 0",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "3e409f60925aba65bf78a9bbbcb735e076d1abac", original_line: 19, final_line: 19
      }
    },
    {
      path: "app.php",
      location: { start_line: 5, start_column: 1 },
      id: "PSR2.Namespaces.NamespaceDeclaration.BlankLineAfter",
      message: "There must be one blank line after the namespace declaration",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: {
        commit: :_, line_hash: "68f7bcc539b5ba5aa7e78a9957c469885db007ff", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "phpcs3/wordpress",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 1, start_column: 1 },
      id: "Squiz.Commenting.FileComment.Missing",
      message: "Missing file doc comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "26c1031dd7d15deedfd22038f1641ca2e884601b", original_line: 1, final_line: 1
      }
    },
    {
      path: "app.php",
      location: { start_line: 1, start_column: 7 },
      id: "WordPress.Security.SafeRedirect.wp_redirect_wp_redirect",
      message:
        "wp_redirect() found. Using wp_safe_redirect(), along with the allowed_redirect_hosts filter if needed, can help avoid any chances of malicious redirects within code. It is also important to remember to call exit() after a redirect so that no other unwanted code is executed.",
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "26c1031dd7d15deedfd22038f1641ca2e884601b", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "phpcs3/symfony",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 5, start_column: 1 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "test" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "c8cb27af37b77942435528b680ac46bde70da647", original_line: 5, final_line: 5
      }
    },
    {
      path: "app.php",
      location: { start_line: 14, start_column: 1 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "test" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "c8cb27af37b77942435528b680ac46bde70da647", original_line: 14, final_line: 14
      }
    },
    {
      path: "app.php",
      location: { start_line: 21, start_column: 1 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "testWithCallBack" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "6b3e66adebe67fa065b05c96d889662dbd7f5207", original_line: 21, final_line: 21
      }
    },
    {
      path: "app.php",
      location: { start_line: 4, start_column: 2 },
      id: "Symfony.Commenting.FunctionComment.MissingReturn",
      message: "Missing @return tag in function comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: {
        commit: :_, line_hash: "c4d2345910e458556d6f2ac40076d795da6350c1", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)

s.add_test(
  "phpcs3/with_php_version",
  type: "success",
  issues: :_,
  analyzer: { name: "PHP_CodeSniffer", version: default_version }
)
