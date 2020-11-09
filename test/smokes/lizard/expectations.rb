s = Runners::Testing::Smoke

default_version = "1.17.7"

s.add_test(
  "success",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: default_version }
)
