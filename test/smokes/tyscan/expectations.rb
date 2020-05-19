s = Runners::Testing::Smoke

# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#
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
      git_blame_info: nil
    }
  ],
  analyzer: { name: "TyScan", version: "0.2.1" }
)

s.add_test(
  "default_config_not_found",
  type: "success",
  issues: [],
  analyzer: { name: "TyScan", version: "0.3.1" },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        `tyscan.yml` does not exist in your repository.
        
        To start performing analysis, `tyscan.yml` is required.
        See also: https://help.sider.review/tools/javascript/tyscan
      MESSAGE
      file: nil
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
      git_blame_info: nil
    }
  ],
  analyzer: { name: "TyScan", version: "0.3.1" }
)

s.add_test(
  "typescript_not_found",
  type: "failure", message: /Your `tyscan` settings could not satisfy the required constraints/, analyzer: :_
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
      git_blame_info: nil
    }
  ],
  analyzer: { name: "TyScan", version: "0.3.1" }
)

s.add_test(
  "invalid_pattern",
  type: "failure",
  message: "TyScan was failed with the exit status 1 since an unexpected error occurred.",
  analyzer: { name: "TyScan", version: "0.2.1" },
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
      git_blame_info: nil
    },
    {
      path: "frontend/src/index.tsx",
      location: { start_line: 14, start_column: 19, end_line: 14, end_column: 28 },
      id: "com.example.user_name",
      message: "Note that the `name` is not full name, but nickname",
      links: [],
      object: { id: "com.example.user_name", message: "Note that the `name` is not full name, but nickname" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "TyScan", version: "0.2.1" }
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
      git_blame_info: nil
    }
  ],
  analyzer: { name: "TyScan", version: "0.2.1" },
  warnings: [{ message: "`tyscan test` failed. It may cause an unintended match.", file: "tyscan.yml" }]
)

s.add_test(
  "jsx_element",
  type: "success",
  issues: [
    {
      object: { id: "smoke.jsx", message: "Est-ce que nous avons confirmé français au le `id`." },
      git_blame_info: nil,
      message: "Est-ce que nous avons confirmé français au le `id`.",
      links: [],
      id: "smoke.jsx",
      path: "index.tsx",
      location: { start_line: 12, start_column: 7, end_line: 12, end_column: 43 }
    }
  ],
  analyzer: { name: "TyScan", version: "0.2.1" }
)
