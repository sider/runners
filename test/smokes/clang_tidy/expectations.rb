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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325712945c407d3c9e9c806676bacebe5948046e", original_line: 6, final_line: 6
      }
    },
    {
      path: "test.c",
      location: { start_line: 5, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 5, final_line: 5
      }
    },
    {
      path: "test.c",
      location: { start_line: 5, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 5, final_line: 5
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325712945c407d3c9e9c806676bacebe5948046e", original_line: 6, final_line: 6
      }
    },
    {
      path: "src/test.CC",
      location: { start_line: 5, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 5, final_line: 5
      }
    },
    {
      path: "src/baz/test.cp",
      location: { start_line: 5, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 5, final_line: 5
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 6, final_line: 6
      }
    },
    {
      path: "src/test.c",
      location: { start_line: 6, start_column: 15 },
      id: "clang-analyzer-deadcode.DeadStores",
      message: "Value stored to 't' during its initialization is never read",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 6, final_line: 6
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "fd7394f2ed4b75fc46ae2751495cefffe70b901b", original_line: 11, final_line: 11
      }
    },
    {
      path: "foo/test.C",
      location: { start_line: 2, start_column: 10 },
      id: "clang-diagnostic-error",
      message: "'bar.h' file not found",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "b3f569d5c43d62134e5dc43d5efd38abddbee0c9", original_line: 2, final_line: 2
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "fd7394f2ed4b75fc46ae2751495cefffe70b901b", original_line: 11, final_line: 11
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325712945c407d3c9e9c806676bacebe5948046e", original_line: 8, final_line: 8
      }
    },
    {
      path: "source/test.c++",
      location: { start_line: 8, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 8, final_line: 8
      }
    },
    {
      path: "source/サンプル/test.CPP",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 9, final_line: 9
      }
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
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325712945c407d3c9e9c806676bacebe5948046e", original_line: 8, final_line: 8
      }
    },
    {
      path: "source/test.c",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 9, final_line: 9
      }
    },
    {
      path: "source/xuq/test.CC",
      location: { start_line: 9, start_column: 3 },
      id: "clang-analyzer-core.uninitialized.Assign",
      message: "Assigned value is garbage or undefined",
      links: [],
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "325e902bbf21dcb5f6ba2e272378d9fa08242c39", original_line: 9, final_line: 9
      }
    },
    {
      path: "source/xuq/inclerr.C++",
      location: { start_line: 1, start_column: 10 },
      id: "clang-diagnostic-error",
      message: "'incl.hh' file not found",
      links: [],
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "8bd9dd0b114f469b14d5cf42599025c17da1eaeb", original_line: 1, final_line: 1
      }
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
