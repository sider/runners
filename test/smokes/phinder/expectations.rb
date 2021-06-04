s = Runners::Testing::Smoke

default_version = "0.9.2"

s.add_test(
  "basic",
  type: "success",
  issues: [
    {
      id: "sample.in_array_without_3rd_param",
      path: "index.php",
      location: { start_line: 2, start_column: 5, end_line: 2, end_column: 34 },
      message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
      links: [],
      object: {
        id: "sample.in_array_without_3rd_param",
        message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "de4b6d96069a48879d60815ffc906cf38f77b8bd", original_line: 2, final_line: 2
      }
    },
    {
      id: "sample.var_dump",
      path: "index.php",
      location: { start_line: 3, start_column: 5, end_line: 3, end_column: 21 },
      message: "Do not use var_dump.",
      links: [],
      object: {
        id: "sample.var_dump",
        message: "Do not use var_dump.",
        justifications: ["Allowed when debugging"]
      },
      git_blame_info: {
        commit: :_, line_hash: "45faf064b717bbb6f2069843d548d4f5e910b8e1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "Phinder", version: default_version }
)

s.add_test(
  "options",
  type: "success",
  issues: [
    {
      id: "sample.in_array_without_3rd_param",
      path: "src/index.php",
      location: { start_line: 2, start_column: 5, end_line: 2, end_column: 33 },
      message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
      links: [],
      object: {
        id: "sample.in_array_without_3rd_param",
        message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "9c95ef4a256ddd84ef505705ed9105ab6af9009c", original_line: 2, final_line: 2
      }
    },
    {
      id: "sample.var_dump",
      path: "src/index.php",
      location: { start_line: 3, start_column: 5, end_line: 3, end_column: 21 },
      message: "Do not use var_dump.",
      links: [],
      object: {
        id: "sample.var_dump",
        message: "Do not use var_dump.",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "45faf064b717bbb6f2069843d548d4f5e910b8e1", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "Phinder", version: default_version }
)

s.add_test(
  "test_failed",
  type: "success",
  issues: [
    {
      id: "sample.in_array_without_3rd_param",
      path: "index.php",
      location: { start_line: 2, start_column: 5, end_line: 2, end_column: 33 },
      message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
      links: [],
      object: {
        id: "sample.in_array_without_3rd_param",
        message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "9c95ef4a256ddd84ef505705ed9105ab6af9009c", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Phinder", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        Phinder configuration validation failed.
        Check the following output by `phinder test` command.

        `in_array(2, $arr, false)` does not match the rule sample.in_array_without_3rd_param but should match that rule.
        `in_array(4, $arr)` matches the rule sample.in_array_without_3rd_param but should not match that rule.
      MESSAGE
      file: "phinder.yml"
    }
  ]
)

s.add_test(
  "analyzer_failed",
  type: "failure",
  message: <<~MESSAGE,
    1 error(s) occurred:

    InvalidRule: Invalid id value found in 1st rule in phinder.yml
  MESSAGE
  analyzer: { name: "Phinder", version: default_version }
)

s.add_test(
  "invalid_runner_config",
  type: "failure",
  message: "`linter.phinder.format` in `sideci.yml` is unsupported",
  analyzer: :_
)

s.add_test(
  "ctp_file",
  type: "success",
  issues: [
    {
      message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
      links: [],
      id: "sample.in_array_without_3rd_param",
      path: "view.ctp",
      location: { start_line: 3, start_column: 9, end_line: 3, end_column: 38 },
      object: {
        id: "sample.in_array_without_3rd_param",
        message: "Specify 3rd parameter explicitly when calling in_array to avoid unexpected comparison results.",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "b89ea0165aafb520371b11649aff080a5ea4e56e", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "Phinder", version: default_version }
)

s.add_test(
  "config_not_found",
  type: "success",
  issues: [],
  analyzer: { name: "Phinder", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        Sider could not find the required configuration file `phinder.yml`.
        Please create the file according to the document:
        https://help.sider.review/tools/php/phinder
      MESSAGE
      file: "phinder.yml"
    }
  ]
)

s.add_test(
  "rule_option_as_config_file",
  type: "success",
  issues: [
    {
      id: "no_var_dump",
      path: "index.php",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 17 },
      message: "Do not use `var_dump`",
      links: [],
      object: {
        id: "no_var_dump",
        message: "Do not use `var_dump`",
        justifications: []
      },
      git_blame_info: {
        commit: :_, line_hash: "e82a9aadb7d5ae3da409e8bd32297d93e72da63f", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Phinder", version: default_version }
)
