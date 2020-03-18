Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "target",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "dir1/sample.go",
        location: { start_line: 9 },
        id: "errcheck",
        message: "Error return value of `validate` is not checked",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "dir2/src/sample.go",
        location: { start_line: 9 },
        id: "errcheck",
        message: "Error return value of `validate` is not checked",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 11 },
        id: "bodyclose",
        message: "response body must be closed",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "no_error",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "failure",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    # Error message will change randomly
    message: %r{\/tmp\/.+\/sample.go:4:3: undeclared name: fmt|Running Error},
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "no_go_file",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  },
  { warnings: [{ message: "No Go files to analyze", file: nil }] }
)

Smoke.add_test(
  "config_sample",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 17 },
        id: "lll",
        message: "line is 188 characters",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 11 },
        id: "structcheck",
        message: "`birthDay` is unused",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "disable_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 8 },
        id: "varcheck",
        message: "`unused` is unused",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "enable_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 8 },
        id: "misspell",
        message: "`Amercia` is a misspelling of `America`",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "disable-all_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 8 },
        id: "unused",
        message: "var `unused` is unused",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "disable_default_linter_in_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Can't be disabled and enabled at one moment",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "disable_only",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Must enable at least one linter",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "enable_disable_same_linter",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Can't be disabled and enabled at one moment",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "duplicate_disable",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Can't combine options --disable-all and --disable",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "uniq-by-line",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 20 },
        id: "gocritic:appendCombine",
        message: "appendCombine: can combine chain of 2 appends into one",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 17 },
        id: "gocritic:commentFormatting",
        message: "commentFormatting: put a space between `//` and comment text",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 13 },
        id: "gosec:G401",
        message: "G401: Use of weak cryptographic primitive",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 4 },
        id: "gosec:G505",
        message: "G505: Blacklisted import `crypto/sha1`: weak cryptographic primitive",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 10 },
        id: "gosimple:S1002",
        message: "S1002: should omit comparison to bool constant, can be simplified to `x`",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 10 },
        id: "staticcheck:SA9003",
        message: "SA9003: empty branch",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "sample.go",
        location: { start_line: 18 },
        id: "stylecheck:ST1003",
        message: "ST1003: should not use underscores in Go names; func redundant_append should be redundantAppend",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "tests",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "no-lint",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 8 },
        id: "varcheck",
        message: "`unused` is unused",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "presets",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "sample.go",
        location: { start_line: 4 },
        id: "gofmt",
        message: "File is not `gofmt`-ed with `-s`",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "presets_validate",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Only next presets exist: (bugs|complexity|format|performance|style|unused)",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "no_such_linter",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "No such linter",
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "no-config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "skip-dirs-use-default",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "vendor/third_party.go",
        location: { start_line: 9 },
        id: "errcheck",
        message: "Error return value of `validate` is not checked",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "skip-files",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)

Smoke.add_test(
  "skip-dirs",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "src/libs/sample.go",
        location: { start_line: 9 },
        id: "errcheck",
        message: "Error return value of `validate` is not checked",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "GolangCI-Lint", version: "1.24.0" }
  }
)
