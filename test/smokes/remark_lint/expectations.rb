s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 3 },
      id: "no-undefined-references",
      message: "Found reference to undefined definition",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "docs/zzz.markdown",
      location: { start_line: 1 },
      id: "no-unused-definitions",
      message: "Found unused definition",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "remark-lint", version: "8.0.0" })

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      path: "src/foo.md",
      location: { start_line: 3 },
      id: "heading-increment",
      message: "Heading levels should increment by one level at a time",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "docs/bar.md",
      location: { start_line: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test(
  "option_ext",
  type: "success",
  issues: [
    {
      path: "readme.markdown",
      location: { start_line: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "readme.mdown",
      location: { start_line: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test(
  "option_rc_path",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 4 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test(
  "option_ignore_path",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 1 },
      id: "no-auto-link-without-protocol",
      message: "All automatic links must start with a protocol",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
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
      object: nil,
      git_blame_info: nil
    },
    {
      path: "readme.markdown",
      location: { start_line: 1 },
      id: "no-heading-punctuation",
      message: "Don’t add a trailing `:` to headings",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test(
  "external_rules",
  type: "success",
  issues: [
    {
      path: "readme.md",
      location: { start_line: 1 },
      id: "books-links",
      message: "Missing PDF indication",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "readme.md",
      location: { start_line: 1 },
      id: "books-links",
      message: "Missing a space before author",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "readme.md",
      location: { start_line: 2 },
      id: "books-links",
      message: "Missing PDF indication",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "7.0.0" }
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  message:
    "The value of the attribute `$.linter.remark_lint.rc-path` in your `sider.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "broken_remarkrc",
  type: "failure",
  message: "2 error(s) reported. See the log for details.",
  analyzer: { name: "remark-lint", version: "8.0.0" }
)

s.add_test("with_remark_lint_package", type: "success", issues: [], analyzer: { name: "remark-lint", version: "8.0.0" })

s.add_test(
  "without_remark_lint_package",
  type: "success",
  issues: [
    {
      path: "foo.md",
      location: { start_line: 1 },
      id: "first-heading-level",
      message: "First heading level should be `1`",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "remark-lint", version: "8.0.0" }
)
