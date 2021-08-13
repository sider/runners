s = Runners::Testing::Smoke

default_version = "0.22.0"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "foo.slim",
      location: { start_line: 1 },
      id: "ControlStatementSpacing",
      message: "Please add a space before and after the `=`",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#controlstatementspacing],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "42229b3500c3d16a805161cc7725da5ec6508be4", original_line: 1, final_line: 1
      }
    },
    {
      path: "foo.slim",
      location: { start_line: 4 },
      id: "LineLength",
      message: "Line is too long. [81/80]",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#linelength],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "84a61674282e916a3d2fb186f5909cbaeb1245f8", original_line: 4, final_line: 4
      }
    },
    {
      path: "rubocop.slim",
      location: { start_line: 2 },
      id: "RuboCop:Lint/UselessAssignment",
      message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`.",
      links: %W[
        https://docs.rubocop.org/rubocop/cops_lint.html#lintuselessassignment
        https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#rubocop
      ],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "d5c5462372be75aeed8a878e413ce34e69e38e58", original_line: 2, final_line: 2
      }
    },
    {
      path: "syntax_error.slim",
      location: { start_line: 1 },
      id: "missing-ID",
      message: "Unknown line indicator",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "bef683a5c483c63bff7acae92ae5ab3042716fd6", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "no_cop_names",
  type: "success",
  issues: [
    {
      path: "rubocop.slim",
      location: { start_line: 2 },
      id: "RuboCop",
      message: "Useless assignment to variable - `unused_variable`.",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#rubocop],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "d5c5462372be75aeed8a878e413ce34e69e38e58", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "with_sider_config",
  type: "success",
  issues: [
    {
      path: "foo.slim",
      location: { start_line: 1 },
      id: "LineLength",
      message: "Line is too long. [14/10]",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#linelength],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "42229b3500c3d16a805161cc7725da5ec6508be4", original_line: 1, final_line: 1
      }
    },
    {
      path: "views/bar.slim",
      location: { start_line: 1 },
      id: "LineLength",
      message: "Line is too long. [14/10]",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#linelength],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "42229b3500c3d16a805161cc7725da5ec6508be4", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "no_target_files",
  type: "success",
  issues: [],
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "invalid_target",
  type: "failure",
  message: "File path 'not_found/' does not exist",
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "invalid_config",
  type: "failure",
  message: "Unable to load configuration from 'not_found.yml': No such file or directory @ rb_sysopen - not_found.yml",
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "default_config",
  type: "success",
  issues: [
    {
      path: "foo.slim",
      location: { start_line: 2 },
      id: "LineLength",
      message: "Line is too long. [201/200]",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#linelength],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "d626bb1e60255b6036c470a4818cf804988c4329", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Slim-Lint", version: default_version }
)

s.add_test(
  "optional_gems",
  type: "success",
  issues: [
    {
      path: "foo.slim",
      location: { start_line: 1 },
      id: "ControlStatementSpacing",
      message: "Please add a space before and after the `=`",
      links: %W[https://github.com/sds/slim-lint/blob/v#{default_version}/lib/slim_lint/linter#controlstatementspacing],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "a745aa127a65767383c35e96e2ea3e5dde882cef", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Slim-Lint", version: default_version }
)
