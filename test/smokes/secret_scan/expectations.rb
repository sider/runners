s = Runners::Testing::Smoke

version = "3.0.3"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "sider.goodcheck-rules.typo.querly",
      message: 'Did you mean "Querly"?',
      path: "bad.rb",
      location: { start_line: 1, start_column: 10, end_line: 1, end_column: 15 },
      links: [],
      object: { justifications: [], severity: nil },
      git_blame_info: { commit: :_, line_hash: :_, original_line: 1, final_line: 1 }
    }
  ],
  analyzer: { name: "Secret Scan", version: version }
)

s.add_test(
  "no_files",
  type: "success",
  issues: [],
  analyzer: { name: "Secret Scan", version: version }
)
