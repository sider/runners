s = Runners::Testing::Smoke

default_version = "1.39.0"

s.add_test(
  "target",
  type: "success",
  issues: [
    {
      path: "dir1/sample.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value is not checked",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "ee2b3811c4ffa606f0741a79c2a116c426f0a634", original_line: 9, final_line: 9
      }
    },
    {
      path: "dir2/src/sample.go",
      location: { start_line: 9, start_column: 10 },
      id: "errcheck",
      message: "Error return value is not checked",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "ee2b3811c4ffa606f0741a79c2a116c426f0a634", original_line: 9, final_line: 9
      }
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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "eb0289be3964dc127bace61751fc7ef20ada1884", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "no_error",
  type: "success",
  issues: [],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "failure",
  type: "success",
  issues: [
    {
      path: "sample.go",
      location: { start_line: 4, start_column: 3 },
      id: "typecheck:undeclared name",
      message: "undeclared name: `fmt`",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "8bdc947f3ad6f7d9a0e5376b9c550341a24b0465", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "no_go_file",
  type: "success",
  issues: [],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "0fb5ba61bf27e1fb9f6a0be47181ae08e5d79b75", original_line: 17, final_line: 17
      }
    },
    {
      path: "sample.go",
      location: { start_line: 11, start_column: 2 },
      id: "structcheck",
      message: "`birthDay` is unused",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "792a9984934b518ba5c0ed58bc266c98bb20c72b", original_line: 11, final_line: 11
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version },
  warnings: [
    { message: "The linter 'interfacer' is deprecated (since v1.38.0) due to: The repository of the linter has been archived by the owner.", file: nil },
    { message: "The linter 'scopelint' is deprecated (since v1.39.0) due to: The repository of the linter has been deprecated by the owner.  Replaced by exportloopref.", file: nil }
  ]
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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "72e52c53dc19bdd90af601902bd01e531ff6b53f", original_line: 8, final_line: 8
      }
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
      object: {
        severity: "",
        replacement: {
          NeedOnlyDelete: false,
          NewLines: nil,
          Inline: { StartCol: 13, Length: 7, NewString: "America" }
        }
      },
      git_blame_info: {
        commit: :_, line_hash: "cb6922ca9909e0da5cd9d3f9256feba2307aecb9", original_line: 8, final_line: 8
      }
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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "72e52c53dc19bdd90af601902bd01e531ff6b53f", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable_default_linter_in_yml",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "disable_only",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "enable_disable_same_linter",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "duplicate_disable",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "8abf46730f036b67189413c4bfbe61ea8becf86c", original_line: 20, final_line: 20
      }
    },
    {
      path: "sample.go",
      location: { start_line: 17, start_column: 1 },
      id: "gocritic:commentFormatting",
      message: "commentFormatting: put a space between `//` and comment text",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "ef19521a896127462566159683262d30dcac3278", original_line: 17, final_line: 17
      }
    },
    {
      path: "sample.go",
      location: { start_line: 18, start_column: 6 },
      id: "golint",
      message: "don't use underscores in Go names; func redundant_append should be redundantAppend",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "b37fc2311b8bf5c18ed289e9bb6709cd402f0abe", original_line: 18, final_line: 18
      }
    },
    {
      path: "sample.go",
      location: { start_line: 13, start_column: 7 },
      id: "gosec:G401",
      message: "G401: Use of weak cryptographic primitive",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "1056c694976d9365e4ef62b0782382c867d6498c", original_line: 13, final_line: 13
      }
    },
    {
      path: "sample.go",
      location: { start_line: 4, start_column: 2 },
      id: "gosec:G505",
      message: "G505: Blocklisted import crypto/sha1: weak cryptographic primitive",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "04da869dc84f676ebb231fa99e070dc4a23134d2", original_line: 4, final_line: 4
      }
    },
    {
      path: "sample.go",
      location: { start_line: 10, start_column: 5 },
      id: "gosimple:S1002",
      message: "S1002: should omit comparison to bool constant, can be simplified to `x`",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "dc87571f33be1d39d3136452e5b1f44946daceac", original_line: 10, final_line: 10
      }
    },
    {
      path: "sample.go",
      location: { start_line: 10, start_column: 2 },
      id: "staticcheck:SA9003",
      message: "SA9003: empty branch",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "dc87571f33be1d39d3136452e5b1f44946daceac", original_line: 10, final_line: 10
      }
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
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "c02fd689ae94e73f9b0d984ede5449deede9bf0d", original_line: 8, final_line: 8
      }
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
      id: "gci",
      message: "File is not `gci`-ed",
      links: [],
      object: {
        severity: "",
        replacement: {
          NeedOnlyDelete: false,
          NewLines: ["\t\"errors\"", "\t\"fmt\""],
          Inline: nil
        }
      },
      git_blame_info: {
        commit: :_, line_hash: "36402d95a34f3cba6826c498785c8b2e82b66437", original_line: 4, final_line: 4
      }
    },
    {
      path: "sample.go",
      location: { start_line: 17, start_column: 0 },
      id: "gofmt",
      message: "File is not `gofmt`-ed with `-s`",
      links: [],
      object: {
        severity: "",
        replacement: {
          NeedOnlyDelete: false,
          NewLines: ["\tif num < 0 {", "\t\treturn errors.New(\"error\")", "\t}", "\tfmt.Println(\"ok\")", "\treturn nil"],
          Inline: nil
        }
      },
      git_blame_info: {
        commit: :_, line_hash: "405ad45b134d4d5eed87fa3e920239cdd543c1fc", original_line: 17, final_line: 17
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "presets_validate",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "no_such_linter",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
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
      message: "Error return value is not checked",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "ee2b3811c4ffa606f0741a79c2a116c426f0a634", original_line: 9, final_line: 9
      }
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
      message: "Error return value is not checked",
      links: [],
      object: { severity: "", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "ee2b3811c4ffa606f0741a79c2a116c426f0a634", original_line: 9, final_line: 9
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

# NOTE: Monorepo is unsupported by GolangCI-Lint.
#       See https://github.com/golangci/golangci-lint/issues/828
s.add_test(
  "monorepo",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "GolangCI-Lint", version: default_version }
)

s.add_test(
  "severity",
  type: "success",
  issues: [
    {
      path: "test.go",
      location: { start_line: 3, start_column: 5 },
      id: "deadcode",
      message: "`unused` is unused",
      links: [],
      object: { severity: "error", replacement: nil },
      git_blame_info: {
        commit: :_, line_hash: "72e52c53dc19bdd90af601902bd01e531ff6b53f", original_line: 3, final_line: 3
      }
    },
    {
      path: "test.go",
      location: { start_line: 6, start_column: 0 },
      id: "gofmt",
      message: "File is not `gofmt`-ed with `-s`",
      links: [],
      object: { severity: "warning", replacement: :_ },
      git_blame_info: {
        commit: :_, line_hash: "19c8a5cdef0f37df1bfbc1c66d27412754169588", original_line: 6, final_line: 6
      }
    }
  ],
  analyzer: { name: "GolangCI-Lint", version: default_version }
)
