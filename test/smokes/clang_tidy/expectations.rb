s = Runners::Testing::Smoke

default_version = "10.0.1"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "foo/テスト.cpp",
      location: { start_line: 6, start_column: 5 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "2nd function call argument is an uninitialized value",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "test.c",
      location: { start_line: 5, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "test.c",
      location: { start_line: 5, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_root_dir",
  type: "success",
  issues: [
    {
      path: "src/foo/テスト.C++",
      location: { start_line: 6, start_column: 5 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "2nd function call argument is an uninitialized value",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "src/test.CC",
      location: { start_line: 5, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "src/baz/test.cp",
      location: { start_line: 5, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_string_values",
  type: "success",
  issues: [
    {
      path: "src/test.c",
      location: { start_line: 6, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "src/test.c",
      location: { start_line: 6, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_apt_valid",
  type: "success",
  issues: [
    {
      path: "example.CXX",
      location: { start_line: 11, start_column: 12 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "Passed-by-value struct argument contains uninitialized data (e.g., field: 'dptr')",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "foo/test.C",
      location: { start_line: 2, start_column: 10 },
      id: "clang-diagnostic-error",
      message: "'bar.h' file not found",
      object: {
        severity: "error"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_apt_exclude",
  type: "success",
  issues: [
    {
      path: "example.cc",
      location: { start_line: 11, start_column: 12 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "Passed-by-value struct argument contains uninitialized data (e.g., field: 'dptr')",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  warnings: [
    {
      message: "Installing the package `foobar` is blocked.",
      file: "sider.yml"
    },
    {
      message: "Installing the package `bazqux-dev-bin=1.2.3-4` is blocked.",
      file: "sider.yml"
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_include_path",
  type: "success",
  issues: [
    {
      path: "source/foo/テスト.cp",
      location: { start_line: 8, start_column: 5 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "2nd function call argument is an uninitialized value",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "source/test.c++",
      location: { start_line: 8, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "source/サンプル/test.CPP",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "option_include_path_default",
  type: "success",
  issues: [
    {
      path: "source/foo/テスト.cxx",
      location: { start_line: 8, start_column: 5 },
      id: "clang-analyzer-core.CallAndMessage",
      message: "2nd function call argument is an uninitialized value",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "source/test.c",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "source/xuq/test.CC",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "source/xuq/inclerr.C++",
      location: { start_line: 1, start_column: 10 },
      id: "clang-diagnostic-error",
      message: "'incl.hh' file not found",
      object: {
        severity: "error"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: default_version }
)

s.add_test(
  "no_files",
  type: "success",
  issues: [],
  analyzer: { name: "Clang-Tidy", version: default_version }
)
