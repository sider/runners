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
    analyzer: { name: "Golint", version: "3.0.0" }
  },
  warnings: [
    {
      message: <<~MSG
        DEPRECATION WARNING!!!
        The support for Golint is deprecated. Sider will drop these versions on April 30, 2020.
        Please consider using an alternative tool GolangCi-Lint. See https://help.sider.review/tools/go/golint
      MSG
        .strip,
      file: "sider.yml"
    }
  ]
)
