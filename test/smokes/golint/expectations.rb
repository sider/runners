Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "main.go",
        location: { start_line: 6 },
        id: "edf57ab64b4d061a5cefa2b2ee80ea5de31c58d2",
        message: "don't use underscores in Go names; var awesome_text should be awesomeText",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "golint", version: "3.0.0" }
  },
  warnings: [
    {
      message: <<~MSG.strip,
        DEPRECATION WARNING!!!
        The support for golint is deprecated. Sider will drop these versions on March 31, 2020.
        Please consider using an alternative tool GolangCi-Lint.
      MSG
      file: "sider.yml"
    }
  ]
)
