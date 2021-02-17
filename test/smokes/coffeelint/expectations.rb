s = Runners::Testing::Smoke

default_version = "4.1.3"

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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 3, final_line: 3
      }
    },
    {
      message: "Line exceeds maximum allowed length Length is 84, max is 80",
      links: [],
      id: "max_line_length",
      path: "test.coffee",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "af5df32577b5771638da7d9919d55433f420248d", original_line: 1, final_line: 1
      }
    },
    {
      message: "Line ends with trailing whitespace",
      links: [],
      id: "no_trailing_whitespace",
      path: "test.coffee",
      location: { start_line: 2 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "3cba81bcb0c193fbff10c92439a0ace9d462a627", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: default_version }
)

s.add_test(
  "with_config",
  type: "success",
  issues: [],
  analyzer: { name: "CoffeeLint", version: default_version }
)

s.add_test(
  "with_config_deprecated",
  type: "success",
  issues: [],
  analyzer: { name: "CoffeeLint", version: default_version },
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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 3, final_line: 3
      }
    },
    {
      message: <<~MSG.strip,
        [stdin]:1:7: error: unexpected <
        foo = <%= something %>
              ^
      MSG
      links: [],
      id: "coffeescript_error",
      path: "er.coffee",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "90c97a042d3ed72698abee8fc4a891fdcc6749b4", original_line: 1, final_line: 1
      }
    },
    {
      message: "Line exceeds maximum allowed length Length is 84, max is 80",
      links: [],
      id: "max_line_length",
      path: "test.coffee",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "af5df32577b5771638da7d9919d55433f420248d", original_line: 1, final_line: 1
      }
    },
    {
      message: "Line ends with trailing whitespace",
      links: [],
      id: "no_trailing_whitespace",
      path: "test.coffee",
      location: { start_line: 2 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "3cba81bcb0c193fbff10c92439a0ace9d462a627", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 3, final_line: 3
      }
    },
    {
      message: "Line exceeds maximum allowed length Length is 84, max is 80",
      links: [],
      id: "max_line_length",
      path: "test.coffee",
      location: { start_line: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "af5df32577b5771638da7d9919d55433f420248d", original_line: 1, final_line: 1
      }
    },
    {
      message: "Line ends with trailing whitespace",
      links: [],
      id: "no_trailing_whitespace",
      path: "test.coffee",
      location: { start_line: 2 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "3cba81bcb0c193fbff10c92439a0ace9d462a627", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: "2.0.6" },
  warnings: [{ message: <<~MSG.strip, file: nil }]
    DEPRECATION WARNING!!!
    The `2.0.6` and older versions are deprecated, and these versions will be dropped in the near future.
    Please consider upgrading to `4.0.0` or a newer version.
  MSG
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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: "2.0.3" },
  warnings: [{ message: /The `2.0.3` and older versions are deprecated/, file: nil }]
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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: "1.16.2" },
  warnings: [{ message: /The `1.16.2` and older versions are deprecated/, file: nil }]
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
      git_blame_info: {
        commit: :_, line_hash: "b084c1fd1e628624a50119e7b7ef7db1fcfa15aa", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "CoffeeLint", version: "2.0.5" },
  warnings: [{ message: /The `2.0.5` and older versions are deprecated/, file: nil }]
)
