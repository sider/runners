s = Runners::Testing::Smoke

default_version = "3.0.1"

s.add_offline_test(
  "success",
  type: "success",
  issues: [
    {
      id: "com.goodcheck.hello",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 22, end_line: 1, end_column: 24 },
      message: "foo is not a good name...",
      links: [],
      object: {
        justifications: [],
        severity: "warn"
      },
      git_blame_info: {
        commit: :_, line_hash: "74914cec8fb77f151285a32e82e35c2c28e584e6", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Goodcheck", version: default_version }
)

s.add_offline_test(
  "with_ci_config",
  type: "success",
  issues: [
    {
      message: "Foo",
      links: [],
      id: "com.sample",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 3 },
      object: {
        justifications: [],
        severity: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "3c061f52aea718c14c209c91cec7e42536b5c368", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Goodcheck", version: default_version }
)

s.add_offline_test(
  "no_config_file",
  type: "success",
  issues: [],
  analyzer: { name: "Goodcheck", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        Sider could not find the required configuration file `goodcheck.yml`.
        Please create the file according to the document:
        https://help.sider.review/tools/others/goodcheck
      MESSAGE
      file: "goodcheck.yml"
    }
  ]
)

s.add_offline_test(
  "invalid_config_file",
  type: "failure",
  message: 'Invalid config: TypeError at $.rules[0]: expected=rule, value="id:foo"',
  analyzer: { name: "Goodcheck", version: default_version }
)

s.add_offline_test(
  "with_invalid_ci_config",
  type: "failure",
  message: "`linter.goodcheck.config` value in `sideci.yml` is invalid",
  analyzer: :_
)

s.add_offline_test(
  "warning_config_file",
  type: "success",
  issues: [],
  analyzer: { name: "Goodcheck", version: default_version },
  warnings: [
    {
      message:
        "Validating your Goodcheck configuration file `goodcheck.yml` failed.",
      file: "goodcheck.yml"
    }
  ]
)

s.add_offline_test(
  "deprecated-options",
  type: "success",
  issues: [],
  analyzer: { name: "Goodcheck", version: default_version },
  warnings: [{ message: "👻 `case_insensitive` option is deprecated. Use `case_sensitive` option instead.", file: nil }]
)

s.add_test(
  "lowest_deps",
  type: "success",
  issues: [
    {
      id: "com.goodcheck.hello",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 21, end_line: 1, end_column: 24 },
      message: "foo is not a good name...",
      links: [],
      object: {
        justifications: [],
        severity: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "74914cec8fb77f151285a32e82e35c2c28e584e6", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Goodcheck", version: "1.0.0" }
)

s.add_offline_test(
  "detect_there_is_no_content",
  type: "success",
  issues: [
    {
      object: {
        justifications: [],
        severity: nil
      },
      git_blame_info: nil,
      message: "Specify frozen_string_literal magic comment.",
      links: [],
      id: "smoke",
      path: "lib/duck.rb",
      location: nil
    }
  ],
  analyzer: { name: "Goodcheck", version: default_version }
)

s.add_offline_test(
  "rules_without_pattern",
  type: "success",
  issues: [
    {
      object: {
        justifications: [],
        severity: nil
      },
      git_blame_info: nil,
      message:
        "Check the following documentation when editing this file.\n" \
          "  * https://example.com/path/to/note",
      links: [],
      id: "com.goodcheck.without_pattern",
      path: "app/checks/example.rb",
      location: nil
    }
  ],
  analyzer: { name: "Goodcheck", version: default_version }
)
