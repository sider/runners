Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "com.goodcheck.hello",
        path: "app/foo.rb",
        location: { start_line: 1, start_column: 21, end_line: 1, end_column: 24 },
        message: "foo is not a good name...",
        links: [],
        object: { id: "com.goodcheck.hello", message: "foo is not a good name...", justifications: [] },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Goodcheck", version: "2.5.1" }
  }
)

Smoke.add_test(
  "with_ci_config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        object: { id: "com.sample", message: "Foo", justifications: [] },
        git_blame_info: nil,
        message: "Foo",
        links: [],
        id: "com.sample",
        path: "app/foo.rb",
        location: { start_line: 1, start_column: 0, end_line: 1, end_column: 3 }
      }
    ],
    analyzer: { name: "Goodcheck", version: "2.5.1" }
  }
)

Smoke.add_test(
  "no_config_file",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "Goodcheck", version: "2.5.1" } },
  warnings: [
    {
      message: <<~MESSAGE
        Sider cannot find the required configuration file `goodcheck.yml`.
        Please set up Goodcheck by following the instructions, or you can disable it in the repository settings.

        - https://github.com/sider/goodcheck
        - https://help.sider.review/tools/others/goodcheck
      MESSAGE
        .strip,
      file: nil
    }
  ]
)

Smoke.add_test(
  "invalid_config_file",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Invalid config: TypeError at $.rules[0]: expected=rule, value=\"id:foo\"",
    analyzer: { name: "Goodcheck", version: "2.5.1" }
  }
)

Smoke.add_test(
  "with_invalid_ci_config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message:
      "The value of the attribute `$.linter.goodcheck.config` in your `sideci.yml` is invalid. Please fix and retry.",
    analyzer: nil
  }
)

Smoke.add_test(
  "warning_config_file",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "Goodcheck", version: "2.5.1" } },
  warnings: [
    {
      message:
        "The validation of your Goodcheck configuration file failed. Check the output of `goodcheck test` command.",
      file: "goodcheck.yml"
    }
  ]
)

Smoke.add_test(
  "deprecated-options",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "Goodcheck", version: "2.5.1" } },
  warnings: [{ message: "👻 `case_insensitive` option is deprecated. Use `case_sensitive` option instead.", file: nil }]
)

Smoke.add_test(
  "lowest_deps",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "com.goodcheck.hello",
        path: "app/foo.rb",
        location: { start_line: 1, start_column: 21, end_line: 1, end_column: 24 },
        message: "foo is not a good name...",
        links: [],
        object: { id: "com.goodcheck.hello", message: "foo is not a good name...", justifications: [] },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Goodcheck", version: "1.0.0" }
  }
)

Smoke.add_test(
  "detect_there_is_no_content",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        object: { id: "smoke", message: "Specify frozen_string_literal magic comment.", justifications: [] },
        git_blame_info: nil,
        message: "Specify frozen_string_literal magic comment.",
        links: [],
        id: "smoke",
        path: "lib/duck.rb",
        location: nil
      }
    ],
    analyzer: { name: "Goodcheck", version: "2.5.1" }
  }
)

Smoke.add_test(
  "rules_without_pattern",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        object: {
          id: "com.goodcheck.without_pattern",
          message: <<~MESSAGE
            Check the following documentation when editing this file.
              * https://example.com/path/to/note
          MESSAGE
            .strip,
          justifications: []
        },
        git_blame_info: nil,
        message: /Check the following documentation when editing this file/,
        links: [],
        id: "com.goodcheck.without_pattern",
        path: "app/checks/example.rb",
        location: nil
      }
    ],
    analyzer: { name: "Goodcheck", version: "2.5.1" }
  }
)
