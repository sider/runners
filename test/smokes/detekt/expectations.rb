Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "with_broken_sider_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message: "The attribute `$.linter.detekt.cli` in your `sider.yml` is unsupported. Please fix and retry."
  }
)

Smoke.add_test(
  "with_invalid_detekt_config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: { name: "detekt", version: "1.7.0" },
    message: "Your detekt configuration is invalid"
  }
)

Smoke.add_test(
  "with_invalid_sider_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "error",
    class: "RuntimeError",
    backtrace: :_,
    inspect: %r{.*\'non\/exists\/dir\/\' does not exist.*}
  }
)

Smoke.add_test(
  "with_options",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.7.0" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: { severity: "info" },
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "without_options",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.7.0" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: { severity: "info" },
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 48 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: { severity: "warning" },
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 19 },
        message:
          "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: { severity: "error" },
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 22 },
        message:
          "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: { severity: "error" },
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 34 },
        message:
          "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: { severity: "error" },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "with_option_includes",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.7.0" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/main/App.kt",
        location: { start_line: 1 },
        message: "The class or object App is empty.",
        links: [],
        object: { severity: "info" },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "no_files",
  { guid: "test-guid", timestamp: :_, type: "success", analyzer: { name: "detekt", version: "1.7.0" }, issues: [] }
)
