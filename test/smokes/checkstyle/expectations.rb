s = Runners::Testing::Smoke

default_version = "8.33"

s.add_test(
  "success",
  type: "success",
  analyzer: { name: "Checkstyle", version: default_version },
  issues: [
    {
      message: "'method def modifier' has incorrect indentation level 4, expected level should be 2.",
      links: %w[https://checkstyle.org/config_misc.html#Indentation],
      id: "IndentationCheck",
      path: "src/Hello.java",
      location: { start_line: 5 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      message: "'method def' child has incorrect indentation level 8, expected level should be 4.",
      links: %w[https://checkstyle.org/config_misc.html#Indentation],
      id: "IndentationCheck",
      path: "src/Hello.java",
      location: { start_line: 6 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      message: "'method def rcurly' has incorrect indentation level 4, expected level should be 2.",
      links: %w[https://checkstyle.org/config_misc.html#Indentation],
      id: "IndentationCheck",
      path: "src/Hello.java",
      location: { start_line: 7 },
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      message: "The name of the outer type and the file do not match.",
      links: %w[https://checkstyle.org/config_misc.html#OuterTypeFilename],
      id: "OuterTypeFilenameCheck",
      path: "src/Hello.java",
      location: { start_line: 3 },
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "config",
  type: "success",
  analyzer: { name: "Checkstyle", version: default_version },
  issues: [
    {
      message: "Parameter args should be final.",
      links: %w[https://checkstyle.org/config_misc.html#FinalParameters],
      id: "FinalParametersCheck",
      path: "src/Main.java",
      location: { start_line: 5 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Utility classes should not have a public or default constructor.",
      links: %w[https://checkstyle.org/config_design.html#HideUtilityClassConstructor],
      id: "HideUtilityClassConstructorCheck",
      path: "src/Main.java",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Missing package-info.java file.",
      links: %w[https://checkstyle.org/config_javadoc.html#JavadocPackage],
      id: "JavadocPackageCheck",
      path: "src/Main.java",
      location: { start_line: 1 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Missing a Javadoc comment.",
      links: %w[https://checkstyle.org/config_javadoc.html#MissingJavadocMethod],
      id: "MissingJavadocMethodCheck",
      path: "src/Main.java",
      location: { start_line: 5 },
      object: { severity: "error" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "failure",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "Checkstyle", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `$.linter.checkstyle.exclude` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "properties",
  type: "success",
  issues: [
    {
      message: "Line is longer than 50 characters (found 57).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "myruleset.xml",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Line is longer than 50 characters (found 63).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "myruleset.xml",
      location: { start_line: 4 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Line is longer than 50 characters (found 54).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "myruleset.xml",
      location: { start_line: 8 },
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      message: "Line is longer than 50 characters (found 67).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "src/Main.java",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Checkstyle", version: default_version }
)

s.add_test(
  "syntax_error",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "Checkstyle", version: default_version }
)
