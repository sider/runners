Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "javasee", version: "0.1.3" },
    issues: [
      {
        id: "hello",
        path: "src/Hello.java",
        location: { start_line: 6, start_column: 9, end_line: 6, end_column: 48 },
        message: "Hello world\n",
        links: [],
        object: { id: "hello", message: "Hello world\n", justifications: [] },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "javasee", version: :_ },
    issues: [
      {
        id: "hello",
        path: "src/Main.java",
        location: { start_line: 6, start_column: 9, end_line: 6, end_column: 48 },
        message: "Hello world\n",
        links: [],
        object: { id: "hello", message: "Hello world\n", justifications: [] },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "failure",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: { name: "javasee", version: :_ },
    message: /java.lang.ClassCastException: class java.lang.Integer cannot be cast/
  }
)

Smoke.add_test(
  "broken_sider_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message: "The value of the attribute `$.linter.javasee.dir[2]` of `sider.yml` is invalid."
  }
)

Smoke.add_test(
  "no_config_file",
  { guid: "test-guid", timestamp: :_, type: "success", analyzer: { name: "javasee", version: :_ }, issues: [] },
  {
    warnings: [
      {
        message: <<~MSG,
      Configuration file javasee.yml does not look a file.
      Specify configuration file by -config option.
    MSG
        file: nil
      }
    ]
  }
)

Smoke.add_test(
  "no_linting_files",
  { guid: "test-guid", timestamp: :_, type: "success", analyzer: { name: "javasee", version: :_ }, issues: [] }
)
