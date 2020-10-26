s = Runners::Testing::Smoke

default_version = "1.14.2"

s.add_test(
  "with_broken_sider_yml",
  type: "failure",
  message: "The attribute `linter.detekt.cli` in your `sider.yml` is unsupported. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "with_invalid_detekt_config",
  type: "failure",
  message: "Your detekt configuration is invalid",
  analyzer: { name: "detekt", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "7494b1780aef71f48580c650d038aaac5f785284", original_line: 2, final_line: 2
      }
    },
    {
      id: "detekt.ForEachOnRange",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 21 },
      message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "1bf72cecb9822789d23028a44c47ea56fae147ab", original_line: 44, final_line: 44
      }
    },
    {
      id: "detekt.FunctionOnlyReturningConstant",
      path: "src/App.kt",
      location: { start_line: 8, start_column: 7 },
      message: "get is returning a constant. Prefer declaring a constant instead.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "6619184f836068051c8c20ecda475e7f8c99ca76", original_line: 8, final_line: 8
      }
    },
    {
      id: "detekt.NestedBlockDepth",
      path: "src/ComplexClass.kt",
      location: { start_line: 9, start_column: 13 },
      message: "Function complex is nested too deeply.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "dd9e211e3f4dc188f60577b9aa455e52ff083a00", original_line: 9, final_line: 9
      }
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
      git_blame_info: {
        commit: :_, line_hash: "7494b1780aef71f48580c650d038aaac5f785284", original_line: 2, final_line: 2
      }
    },
    {
      id: "detekt.ForEachOnRange",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 21 },
      message: "Using the forEach method on ranges has a heavy performance cost. Prefer using simple for loops.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "1bf72cecb9822789d23028a44c47ea56fae147ab", original_line: 44, final_line: 44
      }
    },
    {
      id: "detekt.FunctionOnlyReturningConstant",
      path: "src/App.kt",
      location: { start_line: 8, start_column: 7 },
      message: "get is returning a constant. Prefer declaring a constant instead.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "6619184f836068051c8c20ecda475e7f8c99ca76", original_line: 8, final_line: 8
      }
    },
    {
      id: "detekt.MagicNumber",
      path: "src/ComplexClass.kt",
      location: { start_line: 44, start_column: 17 },
      message: "This expression contains a magic number. Consider defining it to a well named constant.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "1bf72cecb9822789d23028a44c47ea56fae147ab", original_line: 44, final_line: 44
      }
    },
    {
      id: "detekt.MagicNumber",
      path: "src/ComplexClass.kt",
      location: { start_line: 48, start_column: 26 },
      message: "This expression contains a magic number. Consider defining it to a well named constant.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "b930ea0a6f1a6f2812304a3a77152a39face0b43", original_line: 48, final_line: 48
      }
    },
    {
      id: "detekt.NestedBlockDepth",
      path: "src/ComplexClass.kt",
      location: { start_line: 9, start_column: 13 },
      message: "Function complex is nested too deeply.",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "dd9e211e3f4dc188f60577b9aa455e52ff083a00", original_line: 9, final_line: 9
      }
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 19, start_column: 22 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "403615509fbd2f0a1f09f74d9340fc82687c40ee", original_line: 19, final_line: 19
      }
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 22, start_column: 26 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e7fe77bad13349be1e389420c32c32f522bb0ee", original_line: 22, final_line: 22
      }
    },
    {
      id: "detekt.TooGenericExceptionCaught",
      path: "src/ComplexClass.kt",
      location: { start_line: 34, start_column: 26 },
      message:
        "Caught exception is too generic. Prefer catching specific exceptions to the case that is currently handled.",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "3e7fe77bad13349be1e389420c32c32f522bb0ee", original_line: 34, final_line: 34
      }
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
      git_blame_info: {
        commit: :_, line_hash: "4df53f8376184b33e336e5c2d1c675ab922efef8", original_line: 1, final_line: 1
      }
    }
  ]
)

s.add_test("no_files", type: "success", analyzer: { name: "detekt", version: default_version }, issues: [])

s.add_test(
  "deps",
  type: "success",
  analyzer: { name: "detekt", version: "1.11.0" },
  issues: [
    {
      id: "detekt.TooManyFunctions",
      path: "Foo.kt",
      location: { start_line: 1, start_column: 1 },
      message: %r{The file .+/Foo.kt has 11 function declarations. Threshold is specified with 10.},
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e643aae3d233605968d1478dacf8c5d2aa2d8f9", original_line: 1, final_line: 1
      }
    },
    {
      id: "detekt.TooManyFunctionsTwo",
      path: "Foo.kt",
      location: { start_line: 1, start_column: 1 },
      message: %r{The file .+/Foo.kt has 11 function declarations. Threshold is specified with 10.},
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "1e643aae3d233605968d1478dacf8c5d2aa2d8f9", original_line: 1, final_line: 1
      }
    }
  ]
)
