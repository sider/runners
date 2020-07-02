s = Runners::Testing::Smoke

default_version = "1.10.0"

s.add_test(
  "with_broken_sider_yml",
  type: "failure",
  analyzer: :_,
  message: "The attribute `linter.detekt.cli` in your `sider.yml` is unsupported. Please fix and retry."
)

s.add_test(
  "with_invalid_detekt_config",
  type: "failure", analyzer: { name: "detekt", version: default_version }, message: "Your detekt configuration is invalid"
)

s.add_test(
  "with_invalid_sider_option",
  type: "error",
  class: "RuntimeError",
  backtrace: :_,
  inspect: %r{.*'non/exists/dir/' does not exist.*},
  analyzer: { name: "detekt", version: default_version }
)

s.add_test(
  "with_options",
  type: "success",
  analyzer: { name: "detekt", version: default_version },
  issues: [
    {
      id: "detekt.EmptyClassBlock",
      path: "src/FilteredClass.kt",
      location: { start_line: 2, start_column: 21 },
      message: "The class or object FilteredClass is empty.",
      links: [],
      object: { severity: "info" },
      git_blame_info: nil
    },
    {
      id: "detekt.ForEachOnRange",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 21 },
      message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.FunctionOnlyReturningConstant",
      path: "src/App.kt",
      location: { start_line: 8, start_column: 7 },
      message: "get is returning a constant. Prefer declaring a constant instead.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.NestedBlockDepth",
      path: "src/ComplexClass.kt",
      location: { start_line: 9, start_column: 13 },
      message: "Function complex is nested too deeply.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "without_options",
  type: "success",
  analyzer: { name: "detekt", version: default_version },
  issues: [
    {
      id: "detekt.EmptyClassBlock",
      path: "src/FilteredClass.kt",
      location: { start_line: 2, start_column: 21 },
      message: "The class or object FilteredClass is empty.",
      links: [],
      object: { severity: "info" },
      git_blame_info: nil
    },
    {
      id: "detekt.ForEachOnRange",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 21 },
      message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.FunctionOnlyReturningConstant",
      path: "src/App.kt",
      location: { start_line: 8, start_column: 7 },
      message: "get is returning a constant. Prefer declaring a constant instead.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.MagicNumber",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 17 },
      message: "This expression contains a magic number. Consider defining it to a well named constant.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.MagicNumber",
      path: "src/ComplexClass.kt",
      location: { start_line: 48, start_column: 26 },
      message: "This expression contains a magic number. Consider defining it to a well named constant.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.NestedBlockDepth",
      path: "src/ComplexClass.kt",
      location: { start_line: 9, start_column: 13 },
      message: "Function complex is nested too deeply.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 19, start_column: 22 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 22, start_column: 26 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 34, start_column: 26 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "with_option_includes",
  type: "success",
  analyzer: { name: "detekt", version: default_version },
  issues: [
    {
      id: "detekt.EmptyClassBlock",
      path: "src/main/App.kt",
      location: { start_line: 1, start_column: 11 },
      message: "The class or object App is empty.",
      links: [],
      object: { severity: "info" },
      git_blame_info: nil
    }
  ]
)

s.add_test("no_files", type: "success", analyzer: { name: "detekt", version: default_version }, issues: [])
