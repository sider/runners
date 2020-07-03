s = Runners::Testing::Smoke

default_version = "3.8.3"

s.add_test(
  "sandbox_django",
  type: "success",
  issues: [
    {
      path: "app1/views.py",
      location: { start_line: 6, start_column: 12 },
      id: "E999",
      message: "IndentationError: unexpected indent",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/admin.py",
      location: { start_line: 1, start_column: 1 },
      id: "F401",
      message: "'django.contrib.admin' imported but unused",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/tests.py",
      location: { start_line: 1, start_column: 1 },
      id: "F401",
      message: "'django.test.TestCase' imported but unused",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "manage.py",
      location: { start_line: 14, start_column: 13 },
      id: "F401",
      message: "'django' imported but unused",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/models.py",
      location: { start_line: 15, start_column: 13 },
      id: "F601",
      message: "dictionary key 'name' repeated with different values",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/models.py",
      location: { start_line: 16, start_column: 13 },
      id: "F601",
      message: "dictionary key 'name' repeated with different values",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/models.py",
      location: { start_line: 12, start_column: 15 },
      id: "F821",
      message: "undefined name 'ok'",
      links: [],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app1/models.py",
      location: { start_line: 13, start_column: 9 },
      id: "F841",
      message: "local variable 'foo' is assigned to but never used",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "user_config_enabled",
  type: "success",
  issues: [
    {
      path: "foo.py",
      location: { start_line: 2, start_column: 3 },
      id: "E117",
      links: [],
      message: "over-indented",
      object: nil,
      git_blame_info: nil
    },
    {
      path: "foo.py",
      location: { start_line: 2, start_column: 1 },
      id: "W191",
      message: "indentation contains tabs",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "no_user_config_enabled",
  type: "success",
  issues: [],
  analyzer: {
    # W191 is not issued.
    name: "Flake8",
    version: default_version
  }
)

s.add_test(
  "with_plugins",
  type: "success",
  issues: [
    {
      path: "foo.py",
      location: { start_line: 2, start_column: 5 },
      id: "A001",
      message: '"id" is a python builtin and is being shadowed, consider renaming the variable',
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "with_output_options",
  type: "success",
  issues: [
    {
      message: "expected 2 blank lines, found 1",
      links: [],
      id: "E302",
      path: "foo.py",
      location: { start_line: 4, start_column: 1 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "local variable 'a' is assigned to but never used",
      links: [],
      id: "F841",
      path: "foo.py",
      location: { start_line: 5, start_column: 5 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "local variable 'b' is assigned to but never used",
      links: [],
      id: "F841",
      path: "foo.py",
      location: { start_line: 6, start_column: 5 },
      object: nil,
      git_blame_info: nil
    },
    {
      message: "blank line at end of file",
      links: [],
      id: "W391",
      path: "foo.py",
      location: { start_line: 8, start_column: 1 },
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.flake8.plugins` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)

s.add_test(
  "python2",
  type: "success",
  issues: [],
  analyzer: { name: "Flake8", version: default_version },
  warnings: [{ message: "Python 2 is deprecated. Consider migrating to Python 3.", file: nil }]
)

s.add_test("dot_python_version", type: "success", issues: [], analyzer: { name: "Flake8", version: default_version })

s.add_test(
  "dot_python_version_2",
  type: "success",
  issues: [],
  analyzer: { name: "Flake8", version: default_version },
  warnings: [{ message: "Python 2 is deprecated. Consider migrating to Python 3.", file: nil }]
)
