s = Runners::Testing::Smoke

default_version = "0.37.1"

s.add_test(
  "cli",
  type: "success",
  analyzer: { name: "ktlint", version: default_version },
  issues: [
    {
      id: "18748d47",
      path: "src/Foo.kt",
      location: { start_line: 1 },
      message: "Not a valid Kotlin file (1:1 expecting a top level declaration) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 8 },
      message: "Unexpected indentation (2) (should be 4)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 9 },
      message: "Missing newline before \"}\"",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 9 },
      message: "Unexpected indentation (12) (should be 8)",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "cli_with_options",
  type: "success",
  analyzer: { name: "ktlint", version: default_version },
  issues: [
    {
      id: "experimental:package-name",
      path: "src/App.kt",
      location: { start_line: 1 },
      message: "Package name must not contain underscore (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "no-semi",
      path: "src/App.kt",
      location: { start_line: 6 },
      message: "Unnecessary semicolon",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "gradle",
  type: "success",
  analyzer: { name: "ktlint", version: "0.34.0" },
  issues: [
    {
      id: "0ebc0f91",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 9 },
      message: "Unexpected indentation (12) (it should be 6) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "5e2630c4",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 8 },
      message: "Unexpected indentation (2) (it should be 4) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "gradle_ktlint-gradle-plugin",
  type: "success",
  analyzer: { name: "ktlint", version: "0.34.0" },
  issues: [
    {
      id: "experimental:indent",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 10 },
      message: "Unexpected indentation (6) (should be 4)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "indent",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 10 },
      message: "Unexpected indentation (6) (it should be 8) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "maven",
  type: "success",
  analyzer: { name: "ktlint", version: "0.34.0" },
  issues: [
    {
      id: "indent",
      path: "src/main/App.kt",
      location: { start_line: 8 },
      message: "Unexpected indentation (2) (it should be 4) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      id: "indent",
      path: "src/main/App.kt",
      location: { start_line: 9 },
      message: "Unexpected indentation (12) (it should be 6) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  analyzer: :_,
  message: "The attribute `$.linter.ktlint.gradle` in your `sider.yml` is unsupported. Please fix and retry."
)
