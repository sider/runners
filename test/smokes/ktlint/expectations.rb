s = Runners::Testing::Smoke

default_version = "0.37.2"

s.add_test(
  "success",
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
  "with_options",
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
  "broken_sider_yml",
  type: "failure",
  analyzer: :_,
  message: "The attribute `linter.ktlint.cli` in your `sider.yml` is unsupported. Please fix and retry."
)
