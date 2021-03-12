s = Runners::Testing::Smoke

default_version = "0.3.2"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: "0.2.1" }
)

s.add_test(
  "default_config_not_found",
  type: "success",
  issues: [],
  analyzer: { name: "TyScan", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        Sider could not find the required configuration file `tyscan.yml`.
        Please create the file according to the following documents:
        - https://github.com/sider/TyScan
        - https://help.sider.review/tools/javascript/tyscan
      MESSAGE
      file: "tyscan.yml"
    }
  ]
)

s.add_test(
  "package_json_not_found",
  type: "success",
  issues: [
    {
      path: "index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version }
)

s.add_test(
  "typescript_not_found",
  type: "success",
  issues: [
    {
      path: "index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version },
  warnings: [{ message: "Installed `tyscan@0.1.3` does not satisfy our constraint `>=0.2.1 <1.0.0`. Please update it as possible.", file: "package.json" }]
)

s.add_test(
  "tyscan_not_found",
  type: "success",
  issues: [
    {
      path: "index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version }
)

s.add_test(
  "invalid_pattern",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "TyScan", version: default_version },
  warnings: [{ message: "`tyscan test` failed. It may cause an unintended match.", file: "tyscan.yml" }]
)

s.add_test(
  "options",
  type: "success",
  issues: [
    {
      path: "frontend/index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    },
    {
      path: "frontend/src/index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version }
)

s.add_test(
  "tests_failed",
  type: "success",
  issues: [
    {
      path: "index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: {
        commit: :_, line_hash: "f2ac2b1c90b987577202ad96cd4660145c5ae6ff", original_line: 14, final_line: 14
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version },
  warnings: [{ message: "`tyscan test` failed. It may cause an unintended match.", file: "tyscan.yml" }]
)

s.add_test(
  "jsx_element",
  type: "success",
  issues: [
    {
      message: "Est-ce que nous avons confirmé français au le `id`.",
      links: [],
      id: "smoke.jsx",
      path: "index.tsx",
      location: { start_line: 12, start_column: 7, end_line: 12, end_column: 43 },
      object: { id: "smoke.jsx", message: "Est-ce que nous avons confirmé français au le `id`." },
      git_blame_info: {
        commit: :_, line_hash: "1d2b2dfee020f2d6f386721830fec975d4d38953", original_line: 12, final_line: 12
      }
    }
  ],
  analyzer: { name: "TyScan", version: default_version }
)
