s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "foo/テスト.cpp",
      location: { start_line: 6, start_column: 5, end_line: 6, end_column: 5 },
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
      location: { start_line: 5, start_column: 3, end_line: 5, end_column: 3 },
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
      location: { start_line: 5, start_column: 15, end_line: 5, end_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: "7.0.1" }
)

s.add_test(
  "root_dir",
  type: "success",
  issues: [
    {
      path: "src/foo/テスト.C++",
      location: { start_line: 6, start_column: 5, end_line: 6, end_column: 5 },
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
      location: { start_line: 5, start_column: 3, end_line: 5, end_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    },
    {
      path: "test.cp",
      location: { start_line: 5, start_column: 15, end_line: 5, end_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      object: {
        severity: "warning"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: "7.0.1" }
)

s.add_test(
  "option_apt_valid",
  type: "success",
  issues: [
    {
      path: "example.CXX",
      location: { start_line: 11, start_column: 12, end_line: 11, end_column: 12 },
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
      location: { start_line: 2, start_column: 10, end_line: 2, end_column: 10 },
      id: "clang-diagnostic-error",
      message: "'bar.h' file not found",
      object: {
        severity: "error"
      },
      git_blame_info: nil,
      links: []
    }
  ],
  analyzer: { name: "Clang-Tidy", version: "7.0.1" }
)
