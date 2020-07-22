s = Runners::Testing::Smoke

default_version = "0.37.2"

s.add_test(
  "cli",
  type: "success",
  analyzer: { name: "ktlint", version: default_version },
  issues: [
    {
      id: "18748d47ed6c20995492c1190b0fb829b794f8c1",
      path: "src/Foo.kt",
      location: { start_line: 1, start_column: 1 },
      message: "Not a valid Kotlin file (1:1 expecting a top level declaration) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "cad1ff561173d394b00a49d1e560957407f7e67e", original_line: 1, final_line: 1
      }
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 8, start_column: 1 },
      message: "Unexpected indentation (2) (should be 4)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "6619184f836068051c8c20ecda475e7f8c99ca76", original_line: 8, final_line: 8
      }
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 9, start_column: 1 },
      message: "Unexpected indentation (12) (should be 8)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ddc2894c7106b9ca6e77785379c79ce5ce003dfd", original_line: 9, final_line: 9
      }
    },
    {
      id: "indent",
      path: "src/App.kt",
      location: { start_line: 9, start_column: 34 },
      message: "Missing newline before \"}\"",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ddc2894c7106b9ca6e77785379c79ce5ce003dfd", original_line: 9, final_line: 9
      }
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
      location: { start_line: 1, start_column: 1 },
      message: "Package name must not contain underscore (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "35ccf42827417452a774c61c25dd5c4acc237dba", original_line: 1, final_line: 1
      }
    },
    {
      id: "no-semi",
      path: "src/App.kt",
      location: { start_line: 6, start_column: 19 },
      message: "Unnecessary semicolon",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "dc20f32a34163054351b7e66b73309435842aad6", original_line: 6, final_line: 6
      }
    }
  ]
)

s.add_test(
  "gradle",
  type: "success",
  analyzer: { name: "ktlint", version: "0.34.0" },
  issues: [
    {
      id: "0ebc0f91e8cfb83e28a81acd00e39d30d1ca76d6",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 9, start_column: 1 },
      message: "Unexpected indentation (12) (it should be 6) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ddc2894c7106b9ca6e77785379c79ce5ce003dfd", original_line: 9, final_line: 9
      }
    },
    {
      id: "5e2630c41b5d03f9b8c0e413a08de2a8d3e8aa1d",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 8, start_column: 1 },
      message: "Unexpected indentation (2) (it should be 4) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "6619184f836068051c8c20ecda475e7f8c99ca76", original_line: 8, final_line: 8
      }
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
      location: { start_line: 10, start_column: 1 },
      message: "Unexpected indentation (6) (should be 4)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "6b4ed2d2f4e1b65177a4abd4b147b8cb6064c18a", original_line: 10, final_line: 10
      }
    },
    {
      id: "indent",
      path: "src/main/kotlin/gradle/App.kt",
      location: { start_line: 10, start_column: 1 },
      message: "Unexpected indentation (6) (it should be 8) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "6b4ed2d2f4e1b65177a4abd4b147b8cb6064c18a", original_line: 10, final_line: 10
      }
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
      location: { start_line: 8, start_column: 1 },
      message: "Unexpected indentation (2) (it should be 4) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "a7efb26ba5408fc562917a1e5f23e6413ce55af2", original_line: 8, final_line: 8
      }
    },
    {
      id: "indent",
      path: "src/main/App.kt",
      location: { start_line: 9, start_column: 1 },
      message: "Unexpected indentation (12) (it should be 6) (cannot be auto-corrected)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "ddc2894c7106b9ca6e77785379c79ce5ce003dfd", original_line: 9, final_line: 9
      }
    }
  ]
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  analyzer: :_,
  message: "The attribute `linter.ktlint.gradle` in your `sider.yml` is unsupported. Please fix and retry."
)
