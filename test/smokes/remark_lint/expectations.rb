s = Runners::Testing::Smoke

default_version = "9.0.0"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 3, start_column: 1 },
      id: "no-undefined-references",
      message: "Found reference to undefined definition",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "11c9e17a625f0f49ee882984b899de6138aaf42a", original_line: 3, final_line: 3
      }
    },
    {
      path: "docs/zzz.markdown",
      location: { start_line: 1, start_column: 1 },
      id: "no-unused-definitions",
      message: "Found unused definition",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "6a1ffe4280b5ec6d4163a2645edc897b9ac925ec", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "remark-lint", version: default_version })

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      path: "src/foo.md",
      location: { start_line: 3, start_column: 1 },
      id: "heading-increment",
      message: "Heading levels should increment by one level at a time",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "72b6cc4a9c09c56769437494c7927618eaf3487a", original_line: 3, final_line: 3
      }
    },
    {
      path: "docs/bar.md",
      location: { start_line: 1, start_column: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "199e2f13f55a8fb033b64171aa00876a1ecbee25", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test(
  "option_ext",
  type: "success",
  issues: [
    {
      path: "readme.markdown",
      location: { start_line: 1, start_column: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "199e2f13f55a8fb033b64171aa00876a1ecbee25", original_line: 1, final_line: 1
      }
    },
    {
      path: "readme.mdown",
      location: { start_line: 1, start_column: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "199e2f13f55a8fb033b64171aa00876a1ecbee25", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test(
  "option_rc_path",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 4, start_column: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "199e2f13f55a8fb033b64171aa00876a1ecbee25", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test(
  "option_ignore_path",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 1, start_column: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "199e2f13f55a8fb033b64171aa00876a1ecbee25", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test(
  "option_use",
  type: "success",
  issues: [
    {
      path: "readme.markdown",
      location: nil,
      id: "file-extension",
      message: "Incorrect extension: use `md`",
      links: [],
      object: { severity: "warn" },
      git_blame_info: nil
    },
    {
      path: "readme.markdown",
      location: { start_line: 1, start_column: 1 },
      id: "no-heading-punctuation",
      message: "Don’t add a trailing `:` to headings",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "b302e4ad618d311735a3632a6522deed8cc77e48", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test(
  "external_rules",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 1, start_column: 3 },
      id: "books-links",
      message: "Missing PDF indication",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "5b09ffad31eb4e8aa382ff7801b829b6824db8d3", original_line: 1, final_line: 1
      }
    },
    {
      path: "readme.md",
      location: { start_line: 1, start_column: 3 },
      id: "books-links",
      message: "Missing a space before author",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "5b09ffad31eb4e8aa382ff7801b829b6824db8d3", original_line: 1, final_line: 1
      }
    },
    {
      path: "readme.md",
      location: { start_line: 2, start_column: 3 },
      id: "books-links",
      message: "Missing PDF indication",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "00dc69ad287eb73cf52438760d9cc0c49571bd59", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "remark-lint", version: "7.0.0" }
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.remark_lint.rc-path` in your `sider.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "broken_remarkrc",
  type: "failure",
  message: "2 error(s) reported. See the log for details.",
  analyzer: { name: "remark-lint", version: default_version }
)

s.add_test("with_remark_lint_package", type: "success", issues: [], analyzer: { name: "remark-lint", version: default_version })

s.add_test(
  "without_remark_lint_package",
  type: "success",
  issues: [
    {
      path: "foo.md",
      location: { start_line: 1, start_column: 1 },
      id: "first-heading-level",
      message: "First heading level should be `1`",
      links: [],
      object: { severity: "warn" },
      git_blame_info: {
        commit: :_, line_hash: "18c2ad20474bed96b6a042d5cbc1aec43ae7b65a", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "remark-lint", version: default_version }
)
