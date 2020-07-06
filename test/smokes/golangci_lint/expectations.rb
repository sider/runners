s = Runners::Testing::Smoke

default_version = "1.28.0"

s.add_test(
  "target",
  type: "success",
  issues: [
    {
      path: "dir1/sample.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value of `validate` is not checked",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "dir2/src/sample.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value of `validate` is not checked",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 11, start_column: 23 },
      id: "bodyclose",
      message: "response body must be closed",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test("no_error", type: "success", issues: [], analyzer: { name: "GolangCI-Lint", version: default_version })

s.add_test(
  "failure",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test("no_go_file", type: "success", issues: [], analyzer: { name: "GolangCI-Lint", version: default_version })

s.add_test(
  "config_sample",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 17, start_column: 0 },
      id: "lll",
      message: "line is 188 characters",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 11, start_column: 2 },
      id: "structcheck",
      message: "`birthDay` is unused",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable_option",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 8, start_column: 5 },
      id: "varcheck",
      message: "`unused` is unused",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "enable_option",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 8, start_column: 14 },
      id: "misspell",
      message: "`Amercia` is a misspelling of `America`",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable-all_option",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 8, start_column: 5 },
      id: "unused",
      message: "var `unused` is unused",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable_default_linter_in_yml",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable_only",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "enable_disable_same_linter",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "duplicate_disable",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "uniq-by-line",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 20, start_column: 2 },
      id: "gocritic:appendCombine",
      message: "appendCombine: can combine chain of 2 appends into one",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 17, start_column: 1 },
      id: "gocritic:commentFormatting",
      message: "commentFormatting: put a space between `//` and comment text",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 18, start_column: 6 },
      id: "golint",
      message: "don't use underscores in Go names; func redundant_append should be redundantAppend",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 13, start_column: 7 },
      id: "gosec:G401",
      message: "G401: Use of weak cryptographic primitive",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 4, start_column: 2 },
      id: "gosec:G505",
      message: "G505: Blacklisted import `crypto/sha1`: weak cryptographic primitive",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 10, start_column: 5 },
      id: "gosimple:S1002",
      message: "S1002: should omit comparison to bool constant, can be simplified to `x`",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 10, start_column: 2 },
      id: "staticcheck:SA9003",
      message: "SA9003: empty branch",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test("tests", type: "success", issues: [], analyzer: { name: "GolangCI-Lint", version: default_version })

s.add_test(
  "no-lint",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 8, start_column: 5 },
      id: "varcheck",
      message: "`unused` is unused",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "presets",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 4, start_column: 0 },
      id: "gofmt",
      message: "File is not `gofmt`-ed with `-s`",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "sample.go",
      location: { start_line: 22, start_column: 0 },
      id: "gofumpt",
      message: "File is not `gofumpt`-ed",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "presets_validate",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "no_such_linter",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test("no-config", type: "success", issues: [], analyzer: { name: "GolangCI-Lint", version: default_version })

s.add_test(
  "skip-dirs-use-default",
  type: "success",
  issues: [
    {
      path: "vendor/third_party.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value of `validate` is not checked",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test("skip-files", type: "success", issues: [], analyzer: { name: "GolangCI-Lint", version: default_version })

s.add_test(
  "skip-dirs",
  type: "success",
  issues: [
    {
      path: "src/libs/sample.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value of `validate` is not checked",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

# NOTE: Monorepo is unsupported by GolangCI-Lint.
#       See https://github.com/golangci/golangci-lint/issues/828
s.add_test(
  "monorepo",
  type: "failure",
  message: "Analysis failed. See the log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)
