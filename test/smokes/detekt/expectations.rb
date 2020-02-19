Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "cli",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.5.1" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 48 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 19 },
        message: "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 22 },
        message: "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.TooGenericExceptionCaught",
        path: "src/ComplexClass.kt",
        location: { start_line: 34 },
        message: "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
    ]
  }
)

Smoke.add_test(
  "cli_with_options",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.5.1" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
    ]
  }
)

Smoke.add_test(
  "gradle-plain-task",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.5.1" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.MagicNumber",
        path: "src/ComplexClass.kt",
        location: { start_line: 48 },
        message: "This expression contains a magic number. Consider defining it to a well named constant.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
    ]
  }
)

# Smoke.add_test(
#   "gradle_ktlint-gradle-plugin",
#   {
#     guid: "test-guid",
#     timestamp: :_,
#     type: "success",
#     analyzer: { name: "ktlint", version: "0.34.0" },
#     issues: [
#       {
#         id: "experimental:indent",
#         path: "src/main/kotlin/gradle/App.kt",
#         location: { start_line: 10 },
#         message: "Unexpected indentation (6) (should be 4)",
#         links: [],
#         object: nil,
#         git_blame_info: nil
#       },
#       {
#         id: "indent",
#         path: "src/main/kotlin/gradle/App.kt",
#         location: { start_line: 10 },
#         message: "Unexpected indentation (6) (it should be 8) (cannot be auto-corrected)",
#         links: [],
#         object: nil,
#         git_blame_info: nil
#       }
#     ]
#   }
# )

Smoke.add_test(
  "maven",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "detekt", version: "1.5.1" },
    issues: [
      {
        id: "detekt.EmptyClassBlock",
        path: "src/FilteredClass.kt",
        location: { start_line: 2 },
        message: "The class or object FilteredClass is empty.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.ForEachOnRange",
        path: "src/ComplexClass.kt",
        location: { start_line: 44 },
        message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.FunctionOnlyReturningConstant",
        path: "src/App.kt",
        location: { start_line: 8 },
        message: "get is returning a constant. Prefer declaring a constant instead.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        id: "detekt.NestedBlockDepth",
        path: "src/ComplexClass.kt",
        location: { start_line: 9 },
        message: "Function complex is nested too deeply.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
    ]
  }
)

Smoke.add_test(
  "broken_sider_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message: "Invalid configuration in `sider.yml`: unknown attribute at config: `$.linter.detekt`"
  }
)
