Smoke = Runners::Testing::Smoke

# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#
Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        id: "camel_case_classes",
        path: "test.coffee",
        location: { start_line: 3 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line exceeds maximum allowed length Length is 84, max is 80",
        links: [],
        id: "max_line_length",
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line ends with trailing whitespace",
        links: [],
        id: "no_trailing_whitespace",
        path: "test.coffee",
        location: { start_line: 2 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "1.16.0" }
  }
)

Smoke.add_test(
  "with_config",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "CoffeeLint", version: "1.16.0" } }
)

Smoke.add_test(
  "with_config_deprecated",
  {
    guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "CoffeeLint", version: "1.16.0" }
  },
  warnings: [
    {
      message: <<~MSG
        DEPRECATION WARNING!!!
        The `$.linter.coffeelint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
        Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/javascript/coffeelint ).
      MSG
        .strip,
      file: "sideci.yml"
    }
  ]
)

Smoke.add_test(
  "syntax_error",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        id: "camel_case_classes",
        path: "test.coffee",
        location: { start_line: 3 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "[stdin]:1:7: error: unexpected <\n" + "foo = <%= something %>\n" + "      ^",
        links: [],
        id: "coffeescript_error",
        path: "er.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line exceeds maximum allowed length Length is 84, max is 80",
        links: [],
        id: "max_line_length",
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line ends with trailing whitespace",
        links: [],
        id: "no_trailing_whitespace",
        path: "test.coffee",
        location: { start_line: 2 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "1.16.0" }
  }
)

Smoke.add_test(
  "v2",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        id: "camel_case_classes",
        path: "test.coffee",
        location: { start_line: 3 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line exceeds maximum allowed length Length is 84, max is 80",
        links: [],
        id: "max_line_length",
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "Line ends with trailing whitespace",
        links: [],
        id: "no_trailing_whitespace",
        path: "test.coffee",
        location: { start_line: 2 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "2.0.6" }
  }
)

Smoke.add_test(
  "only_package_json",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "camel_case_classes",
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "2.0.3" }
  }
)

Smoke.add_test(
  "package_lock_json",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "camel_case_classes",
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "1.16.2" }
  }
)

Smoke.add_test(
  "yarn_lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "camel_case_classes",
        message: "Class name should be UpperCamelCased class name: foo",
        links: [],
        path: "test.coffee",
        location: { start_line: 1 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "CoffeeLint", version: "2.0.5" }
  }
)
