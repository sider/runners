Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "src/HelloWorld.php",
        location: {start_line: 7},
        id: "Call to method format() on an unknown class DateTimeImutable.",
        message: "Call to method format() on an unknown class DateTimeImutable.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "src/HelloWorld.php",
        location: {start_line: 5},
        id: "Parameter $date of method HelloWorld::sayHello() has invalid typehint type DateTimeImutable.",
        message: "Parameter $date of method HelloWorld::sayHello() has invalid typehint type DateTimeImutable.",
        links: [],
        object: nil,
        git_blame_info: nil
        }
      ],
    analyzer: {name: "phpstan", version: "0.12.12"}
  }
)

Smoke.add_test(
  "with_config_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "HelloWorld.php",
        location: {start_line: 7},
        id: "Call to method format() on an unknown class DateTimeImutable.",
        message: "Call to method format() on an unknown class DateTimeImutable.",
        links: [],
        object: nil,
        git_blame_info: nil
      },
      {
        path: "HelloWorld.php",
        location: {start_line: 5},
        id: "Parameter $date of method HelloWorld::sayHello() has invalid typehint type DateTimeImutable.",
        message: "Parameter $date of method HelloWorld::sayHello() has invalid typehint type DateTimeImutable.",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: {name: "phpstan", version: "0.12.12"
    }
  }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.phpstan.configuration`",
    analyzer: nil
  }
)
