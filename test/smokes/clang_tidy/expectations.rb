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
