s = Runners::Testing::Smoke

default_version = "8.30"

s.add_test(
  "normal_case",
  {
    type: "success",
    analyzer: { name: "LineCounter", version: default_version },
    issues: [],
    metrics: [
      path: "dummy.txt",
      type: "physical_loc",
      object: {
        loc: 5
      }
    ]
  }
)
