s = Runners::Testing::Smoke

default_version = "8.36.1"

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
      location: { start_line: 9, start_column: 5 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "97c8f652b768ead8c8ae633a28485000d16ad703", original_line: 9, final_line: 9
      }
    },
    {
      message: "'method def' child has incorrect indentation level 8, expected level should be 4.",
      links: %w[https://checkstyle.org/config_misc.html#Indentation],
      id: "IndentationCheck",
      path: "src/Hello.java",
      location: { start_line: 10, start_column: 9 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "addb4c033c4233fd7e9025796b0a22ff829782f9", original_line: 10, final_line: 10
      }
    },
    {
      message: "'method def rcurly' has incorrect indentation level 4, expected level should be 2.",
      links: %w[https://checkstyle.org/config_misc.html#Indentation],
      id: "IndentationCheck",
      path: "src/Hello.java",
      location: { start_line: 11, start_column: 5 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "e266bf187351d458abacf0d6374d1c6659d82428", original_line: 11, final_line: 11
      }
    },
    {
      message: "The name of the outer type and the file do not match.",
      links: %w[https://checkstyle.org/config_misc.html#OuterTypeFilename],
      id: "OuterTypeFilenameCheck",
      path: "src/Hello.java",
      location: { start_line: 3, start_column: 1 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "b4aa7ff94732722c55d79ff3788d3d5f22b197b2", original_line: 3, final_line: 3
      }
    },
    {
      message: "Javadoc tag '@param' should be preceded with an empty line.",
      links: %w[https://checkstyle.org/config_javadoc.html#RequireEmptyLineBeforeBlockTagGroup],
      id: "RequireEmptyLineBeforeBlockTagGroupCheck",
      path: "src/Hello.java",
      location: { start_line: 7 },
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "c5eac3efafa02a21624306960aebdf27b3ce1706", original_line: 7, final_line: 7
      }
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
      location: { start_line: 5, start_column: 29 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "97c8f652b768ead8c8ae633a28485000d16ad703", original_line: 5, final_line: 5
      }
    },
    {
      message: "Utility classes should not have a public or default constructor.",
      links: %w[https://checkstyle.org/config_design.html#HideUtilityClassConstructor],
      id: "HideUtilityClassConstructorCheck",
      path: "src/Main.java",
      location: { start_line: 3, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b4aa7ff94732722c55d79ff3788d3d5f22b197b2", original_line: 3, final_line: 3
      }
    },
    {
      message: "Missing package-info.java file.",
      links: %w[https://checkstyle.org/config_javadoc.html#JavadocPackage],
      id: "JavadocPackageCheck",
      path: "src/Main.java",
      location: { start_line: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "cbce17a507d2e4fd00c89efee19480c0104e0932", original_line: 1, final_line: 1
      }
    },
    {
      message: "Missing a Javadoc comment.",
      links: %w[https://checkstyle.org/config_javadoc.html#MissingJavadocMethod],
      id: "MissingJavadocMethodCheck",
      path: "src/Main.java",
      location: { start_line: 5, start_column: 5 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "97c8f652b768ead8c8ae633a28485000d16ad703", original_line: 5, final_line: 5
      }
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
    "The value of the attribute `linter.checkstyle.exclude` in your `sideci.yml` is invalid. Please fix and retry.",
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
      git_blame_info: {
        commit: :_, line_hash: "afa68b6d0a9c41c9f18d52c4ad28b1508fb24efd", original_line: 3, final_line: 3
      }
    },
    {
      message: "Line is longer than 50 characters (found 63).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "myruleset.xml",
      location: { start_line: 4 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "69049cc1cd8947386a9354a120e5f88e0abf3c6c", original_line: 4, final_line: 4
      }
    },
    {
      message: "Line is longer than 50 characters (found 54).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "myruleset.xml",
      location: { start_line: 8 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "e7a055561d4d474b6f7e7c701e34f1058cad6dab", original_line: 8, final_line: 8
      }
    },
    {
      message: "Line is longer than 50 characters (found 67).",
      links: %w[https://checkstyle.org/config_sizes.html#LineLength],
      id: "LineLengthCheck",
      path: "src/Main.java",
      location: { start_line: 3 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "871358cf483b1332891606601d5b7c90c6987be0", original_line: 3, final_line: 3
      }
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

s.add_test(
  "deps",
  type: "success",
  issues: [
    {
      message: "Incorrect target: 'CLASS_DEF' for annotation: 'XXX'.",
      links: [],
      id: "com.github.sevntu.checkstyle.checks.annotation.ForbidAnnotationCheck",
      path: "Foo.java",
      location: { start_line: 1, start_column: 1 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "1dc0736e1e427ace652a896ca5c096be7acd8133", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Checkstyle", version: default_version }
)

s.add_test(
  "deps_not_default",
  type: "success",
  issues: [
    {
      message: "Lambda argument has unnecessary parentheses.",
      links: [],
      id: "io.spring.javaformat.checkstyle.check.SpringLambdaCheck",
      path: "Foo.java",
      location: { start_line: 3, start_column: 21 },
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "8dedd49bab7f8372d3784a0d03ee1e6cfa8a61e4", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "Checkstyle", version: "8.32" }
)

s.add_test(
  "deps_invalid_format",
  type: "failure",
  message: <<~MSG,
    An invalid dependency is found in your `sider.yml`: `["com.github.sevntu-checkstyle", "sevntu-checks"]`
    Dependencies should be of the form: `[group, name, version]`
  MSG
  analyzer: :_
)

s.add_test(
  "deps_invalid_definition",
  type: "error",
  class: "Runners::Shell::ExecError",
  backtrace: :_,
  inspect: /#<Runners::Shell::ExecError: type=capture3, args=\["gradle", "--no-build-cache",/,
  analyzer: :_
)
