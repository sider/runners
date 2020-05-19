s = Runners::Testing::Smoke

s.add_test(
  "phpcs3/success",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 6 },
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
  "phpcs3/specified_dir",
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
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "phpcs3/custom_argument",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 2 },
      id: "PEAR.Commenting.FileComment.Missing",
      message: "Missing file doc comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 8 },
      id: "Zend.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "phpcs3/cakephp",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 2 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 0 but found 4",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 6 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 0 but found 4",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 13 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 4 but found 8",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 19 },
      id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
      message: "Doc block not aligned with code; expected indentation of 4 but found 0",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 5 },
      id: "PSR2.Namespaces.NamespaceDeclaration.BlankLineAfter",
      message: "There must be one blank line after the namespace declaration",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: true },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "phpcs3/wordpress",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 1 },
      id: "Squiz.Commenting.FileComment.Missing",
      message: "Missing file doc comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 1 },
      id: "WordPress.Security.SafeRedirect.wp_redirect_wp_redirect",
      message:
        "wp_redirect() found. Using wp_safe_redirect(), along with the allowed_redirect_hosts filter if needed, can help avoid any chances of malicious redirects within code. It is also important to remember to call exit() after a redirect so that no other unwanted code is executed.",
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "phpcs3/symfony",
  type: "success",
  issues: [
    {
      path: "app.php",
      location: { start_line: 5 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "test" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 14 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "test" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 21 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: 'Consider putting global function "testWithCallBack" in a static class',
      links: [],
      object: { type: "WARNING", severity: 5, fixable: false },
      git_blame_info: nil
    },
    {
      path: "app.php",
      location: { start_line: 4 },
      id: "Symfony.Commenting.FunctionComment.MissingReturn",
      message: "Missing @return tag in function comment",
      links: [],
      object: { type: "ERROR", severity: 5, fixable: false },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)

s.add_test(
  "phpcs3/with_php_version",
  type: "success", issues: :_, analyzer: { name: "PHP_CodeSniffer", version: "3.5.5" }
)
