s = Runners::Testing::Smoke

default_version = "0.7.2"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      id: "SC2006",
      path: "test_script",
      location: { start_line: 3, start_column: 3, end_line: 3, end_column: 8 },
      message: "Use $(...) notation instead of legacy backticked `...`.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2006],
      object: { code: 2_006, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "6349a055fa89495662ad06e698cbbff2cb10f333", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2020",
      path: "test.bash",
      location: { start_line: 3, start_column: 25, end_line: 3, end_column: 32 },
      message: "tr replaces sets of chars, not words (mentioned due to duplicates).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2020],
      object: { code: 2_020, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "d2db53cf3fa4454a0a29f39ca8aa354dd951939a", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2034",
      path: "test-bats",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 2 },
      message: "a appears unused. Verify use (or export if used externally).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2034],
      object: { code: 2_034, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "86eda770a6060824b090dd4df091e3bd4121279c", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2034",
      path: "test.ksh",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 7 },
      message: "arr appears unused. Verify use (or export if used externally).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2034],
      object: { code: 2_034, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "f0e5360a9638525ed05e9fcf6903bac42290d0c2", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2060",
      path: "test.dash",
      location: { start_line: 3, start_column: 8, end_line: 3, end_column: 17 },
      message: "Quote parameters to tr to prevent glob expansion.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2060],
      object: { code: 2_060, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "199bb17d2f828d4ba1740af6274baf6848d0a9c8", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2086",
      path: "test.bats",
      location: { start_line: 5, start_column: 5, end_line: 5, end_column: 12 },
      message: "Double quote to prevent globbing and word splitting.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2086],
      object: {
        code: 2_086,
        severity: "info",
        fix: {
          replacements: [
            {
              line: 5,
              column: 5,
              endLine: 5,
              endColumn: 5,
              precedence: 12,
              insertionPoint: "afterEnd",
              replacement: '"'
            },
            {
              line: 5,
              column: 12,
              endLine: 5,
              endColumn: 12,
              precedence: 12,
              insertionPoint: "beforeStart",
              replacement: '"'
            }
          ]
        }
      },
      git_blame_info: {
        commit: :_, line_hash: "c43d82810fc5692d7c8746beef184e2204ebf718", original_line: 5, final_line: 5
      }
    },
    {
      id: "SC2162",
      path: "src/test_script2",
      location: { start_line: 4, start_column: 1, end_line: 4, end_column: 5 },
      message: "read without -r will mangle backslashes.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2162],
      object: { code: 2_162, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "36705e76c7c5c929aac77ce04526c31b338a6a46", original_line: 4, final_line: 4
      }
    },
    {
      id: "SC3010",
      path: "foo.sh/bar.sh",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 17 },
      message: "In POSIX sh, [[ ]] is undefined.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC3010],
      object: { code: 3010, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "b36d60537db197eefd58519460f7f928406e4355", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC3010",
      path: "test.sh",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 17 },
      message: "In POSIX sh, [[ ]] is undefined.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC3010],
      object: { code: 3010, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "b36d60537db197eefd58519460f7f928406e4355", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "shellcheckrc",
  type: "success",
  issues: [
    {
      id: "SC1091",
      path: "test.bash",
      location: { start_line: 7, start_column: 3, end_line: 7, end_column: 9 },
      message: "Not following: lib.sh was not specified as input (see shellcheck -x).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC1091],
      object: { code: 1_091, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "8282b43229c51955b8e027b3425f27983b2167bc", original_line: 7, final_line: 7
      }
    },
    {
      id: "SC2249",
      path: "test.bash",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 36 },
      message: "Consider adding a default *) case, even if it just exits with error.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2249],
      object: { code: 2_249, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "4e2a9dce0a22ee65fdda237ef284d207c9f1d684", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "ShellCheck", version: default_version })

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      id: "SC1113",
      path: "src/test.sh",
      location: { start_line: 1, start_column: 2, end_line: 1, end_column: 2 },
      message: "Use #!, not just #, for the shebang.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC1113],
      object: { code: 1_113, severity: "error", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "7d26a596679314d26805db4f3caa5f006b81f686", original_line: 1, final_line: 1
      }
    },
    {
      id: "SC1113",
      path: "test.bash",
      location: { start_line: 1, start_column: 2, end_line: 1, end_column: 2 },
      message: "Use #!, not just #, for the shebang.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC1113],
      object: { code: 1_113, severity: "error", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "c2e2f259c47d1f693132a98ca8991a5b41f7cf8e", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_target_complex",
  type: "success",
  issues: [
    {
      id: "SC2034",
      path: "test.sh",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      message: "foo appears unused. Verify use (or export if used externally).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2034],
      object: { code: 2_034, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "5bddd8336e5f711bfa499383fc73c17560c6250b", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_include",
  type: "success",
  issues: [
    {
      id: "SC2104",
      path: "test.bash",
      location: { start_line: 6, start_column: 5, end_line: 6, end_column: 10 },
      message: "In functions, use return instead of break.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2104],
      object: { code: 2_104, severity: "error", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "49bd5e4806986f9bdd01fc9536d7c7d573671816", original_line: 6, final_line: 6
      }
    },
    {
      id: "SC2105",
      path: "test.bash",
      location: { start_line: 13, start_column: 5, end_line: 13, end_column: 10 },
      message: "break is only valid in loops.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2105],
      object: { code: 2_105, severity: "error", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "49bd5e4806986f9bdd01fc9536d7c7d573671816", original_line: 13, final_line: 13
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_exclude",
  type: "success",
  issues: [
    {
      id: "SC2034",
      path: "test.bash",
      location: { start_line: 12, start_column: 5, end_line: 12, end_column: 12 },
      message: "verbose appears unused. Verify use (or export if used externally).",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2034],
      object: { code: 2_034, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "252591f9ad6e80b27b3f41b18dc55cd49385ee8c", original_line: 12, final_line: 12
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_enable",
  type: "success",
  issues: [
    {
      id: "SC2248",
      path: "test.bash",
      location: { start_line: 6, start_column: 6, end_line: 6, end_column: 10 },
      message: "Prefer double quoting even when variables don't contain special characters.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2248],
      object: { code: 2_248, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "81066c1e51d5171f63742b8c6dbb554d1edd4a77", original_line: 6, final_line: 6
      }
    },
    {
      id: "SC2249",
      path: "test.bash",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 36 },
      message: "Consider adding a default *) case, even if it just exits with error.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2249],
      object: { code: 2_249, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "4e2a9dce0a22ee65fdda237ef284d207c9f1d684", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_enable_all",
  type: "success",
  issues: [
    {
      id: "SC2248",
      path: "test.bash",
      location: { start_line: 6, start_column: 6, end_line: 6, end_column: 10 },
      message: "Prefer double quoting even when variables don't contain special characters.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2248],
      object: { code: 2_248, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "81066c1e51d5171f63742b8c6dbb554d1edd4a77", original_line: 6, final_line: 6
      }
    },
    {
      id: "SC2249",
      path: "test.bash",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 36 },
      message: "Consider adding a default *) case, even if it just exits with error.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2249],
      object: { code: 2_249, severity: "info", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "4e2a9dce0a22ee65fdda237ef284d207c9f1d684", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC2250",
      path: "test.bash",
      location: { start_line: 6, start_column: 6, end_line: 6, end_column: 10 },
      message: "Prefer putting braces around variable references even when not strictly required.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2250],
      object: { code: 2_250, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "81066c1e51d5171f63742b8c6dbb554d1edd4a77", original_line: 6, final_line: 6
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_shell",
  type: "success",
  issues: [
    {
      id: "SC3010",
      path: "test.bash",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 12 },
      message: "In POSIX sh, [[ ]] is undefined.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC3010],
      object: { code: 3010, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "44d113a34cde5ecd8df6d9aaba8e37bb91eee2c2", original_line: 3, final_line: 3
      }
    },
    {
      id: "SC3010",
      path: "test.sh",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 12 },
      message: "In POSIX sh, [[ ]] is undefined.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC3010],
      object: { code: 3010, severity: "warning", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "44d113a34cde5ecd8df6d9aaba8e37bb91eee2c2", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test(
  "option_severity",
  type: "success",
  issues: [
    {
      id: "SC2104",
      path: "test.bash",
      location: { start_line: 6, start_column: 5, end_line: 6, end_column: 10 },
      message: "In functions, use return instead of break.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2104],
      object: { code: 2_104, severity: "error", fix: nil },
      git_blame_info: {
        commit: :_, line_hash: "49bd5e4806986f9bdd01fc9536d7c7d573671816", original_line: 6, final_line: 6
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)

s.add_test("option_norc", type: "success", issues: [], analyzer: { name: "ShellCheck", version: default_version })

# Test specified files with the `ignore` options will be ignored.
s.add_test(
  "with_ignore",
  type: "success",
  issues: [
    {
      path: "abc.bash",
      location: { start_line: 3, start_column: 3, end_line: 3, end_column: 8 },
      id: "SC2006",
      message: "Use $(...) notation instead of legacy backticked `...`.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2006],
      object: { code: 2_006, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "6349a055fa89495662ad06e698cbbff2cb10f333", original_line: 3, final_line: 3
      }
    },
    {
      path: "abc.sh",
      location: { start_line: 3, start_column: 3, end_line: 3, end_column: 8 },
      id: "SC2006",
      message: "Use $(...) notation instead of legacy backticked `...`.",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2006],
      object: { code: 2_006, severity: "style", fix: { replacements: :_ } },
      git_blame_info: {
        commit: :_, line_hash: "6349a055fa89495662ad06e698cbbff2cb10f333", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "ShellCheck", version: default_version }
)
