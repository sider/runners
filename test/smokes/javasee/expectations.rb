s = Runners::Testing::Smoke

default_version = "0.1.3"

s.add_test(
  "success",
  type: "success",
  analyzer: { name: "JavaSee", version: default_version },
  issues: [
    {
      id: "hello",
      path: "src/Hello.java",
      location: { start_line: 6, start_column: 9, end_line: 6, end_column: 48 },
      message: "Hello world\n",
      links: [],
      object: { id: "hello", message: "Hello world\n", justifications: [] },
      git_blame_info: {
        commit: :_, line_hash: "addb4c033c4233fd7e9025796b0a22ff829782f9", original_line: 6, final_line: 6
      }
    }
  ]
)

s.add_test(
  "config",
  type: "success",
  analyzer: { name: "JavaSee", version: default_version },
  issues: [
    {
      id: "hello",
      path: "src/Main.java",
      location: { start_line: 6, start_column: 9, end_line: 6, end_column: 48 },
      message: "Hello world\n",
      links: [],
      object: { id: "hello", message: "Hello world\n", justifications: [] },
      git_blame_info: {
        commit: :_, line_hash: "addb4c033c4233fd7e9025796b0a22ff829782f9", original_line: 6, final_line: 6
      }
    }
  ]
)

s.add_test(
  "failure",
  type: "failure",
  analyzer: { name: "JavaSee", version: default_version },
  message: /java.lang.ClassCastException: class java.lang.Integer cannot be cast/
)

s.add_test(
  "broken_sider_yml",
  type: "failure",
  analyzer: :_,
  message: "The value of the attribute `linter.javasee.dir` in your `sider.yml` is invalid. Please fix and retry."
)

s.add_test(
  "no_config_file",
  type: "success",
  analyzer: { name: "JavaSee", version: default_version },
  issues: [],
  warnings: [
    {
      message: <<~MSG.strip,
        Sider could not find the required configuration file `javasee.yml`.
        Please create the file according to the following documents:
        - https://github.com/sider/JavaSee
        - https://help.sider.review/tools/java/javasee
      MSG
      file: "javasee.yml"
    }
  ]
)

s.add_test("no_linting_files", type: "success", analyzer: { name: "JavaSee", version: default_version }, issues: [])
