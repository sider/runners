s = Runners::Testing::Smoke

s.add_test(
  "success",
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
)

s.add_test("with_config", type: "success", issues: [], analyzer: { name: "CoffeeLint", version: "1.16.0" })

s.add_test(
  "with_config_deprecated",
  type: "success",
  issues: [],
  analyzer: { name: "CoffeeLint", version: "1.16.0" },
  warnings: [
    {
      message: /The `linter.coffeelint.options` option is deprecated/,
      file: "sideci.yml"
    }
  ]
)

s.add_test(
  "syntax_error",
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
)

s.add_test(
  "v2",
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
)

s.add_test(
  "only_package_json",
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
)

s.add_test(
  "package_lock_json",
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
)

s.add_test(
  "yarn_lock",
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
)
