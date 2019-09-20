Smoke = Runners::Testing::Smoke

# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#
Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
      { path: "index.tsx",
        location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
        id: "com.example.user_name",
        object: { :id => "com.example.user_name",
                  :message => "Note that the `name` is not full name, but nickname" } }
  ],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
})

Smoke.add_test("default_config_not_found", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
}, warnings: [
  { message: <<~MESSAGE, file: nil }
    `tyscan.yml` does not exist in your repository.

    To start performing analysis, `tyscan.yml` is required.
    See also: https://help.sider.review/tools/javascript/tyscan
  MESSAGE
])

Smoke.add_test("package_json_not_found", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "index.tsx",
      location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
      id: "com.example.user_name",
      object: { :id => "com.example.user_name",
                :message => "Note that the `name` is not full name, but nickname" } }
  ],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
})

Smoke.add_test("typescript_not_found", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: /Your `tyscan` settings could not satisfy the required constraints/,
  analyzer: nil,
})

Smoke.add_test("tyscan_not_found", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "index.tsx",
      location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
      id: "com.example.user_name",
      object: { :id => "com.example.user_name",
                :message => "Note that the `name` is not full name, but nickname" } }
  ],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
}, {
  warnings: [
    { message: /No required dependencies for analysis were installed/, file: "package.json" },
  ]
})

Smoke.add_test("invalid_pattern", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: <<~MESSAGE,
    TyScan was failed with status 1 since an unexpected error occurred.

    STDERR:

  MESSAGE
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
}, warnings: [
  { message: '`tyscan test` failed. It may cause an unintended match.', file: "tyscan.yml" }
])

Smoke.add_test("options", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "frontend/index.tsx",
      location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
      id: "com.example.user_name",
      object: { :id => "com.example.user_name",
                :message => "Note that the `name` is not full name, but nickname" } },
    { path: "frontend/src/index.tsx",
      location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
      id: "com.example.user_name",
      object: { :id => "com.example.user_name",
                :message => "Note that the `name` is not full name, but nickname" } },
  ],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
})

Smoke.add_test("tests_failed", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "index.tsx",
      location: { :start_line => 14, :start_column => 19, :end_line => 14, :end_column => 28 },
      id: "com.example.user_name",
      object: { :id => "com.example.user_name",
                :message => "Note that the `name` is not full name, but nickname" } }
  ],
  analyzer: {
    name: 'TyScan',
    version: '0.2.1'
  }
}, warnings: [
  { message: "`tyscan test` failed. It may cause an unintended match.", file: "tyscan.yml" }
])

Smoke.add_test("jsx_element", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      object: {
        id: "smoke.jsx",
        message: "Est-ce que nous avons confirmé français au le `id`."
      },
      id: "smoke.jsx",
      path: "index.tsx",
      location: { start_line: 12, start_column: 7, end_line: 12, end_column: 43 }
    }
  ],
  analyzer: {
    name: "TyScan",
    version: "0.2.1"
  }
})
