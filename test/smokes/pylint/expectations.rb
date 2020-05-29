s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "failure",
  type: "success",
  issues: [
    {
      id: "bad-whitespace",
      path: "bad.py",
      location: {
        start_line: 3
      },
      message: "No space allowed before bracket\n        print (\"{} * {} = {}\".format(i, j, i*j))\n              ^",
      object: {
        severity: "convention",
        "message-id": "C0326",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "target",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "folder/bad1.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad1",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "missing-module-docstring",
      path: "folder/bad2.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad2",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "rcfile",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "ignore",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "errors_only",
  type: "success",
  issues: [
    {
      id: "no-method-argument",
      path: "bad.py",
      location: {
        start_line: 4
      },
      message: "Method has no argument",
      object: {
        severity: "error",
        "message-id": "E0211",
        module: "bad",
        obj: "TestFile.temp_method"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "undefined-variable",
      path: "bad.py",
      location: {
        start_line: 2
      },
      message: "Undefined variable 'temp'",
      object: {
        severity: "error",
        "message-id": "E0602",
        module: "bad",
        obj: "TestFile"
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "flask",
  type: "success",
  issues: [
    {
      id: "missing-function-docstring",
      path: "hello.py",
      location: {
        start_line: 6
      },
      message: "Missing function or method docstring",
      object: {
        severity: "convention",
        "message-id": "C0116",
        module: "hello",
        obj: "hello_world"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "missing-module-docstring",
      path: "hello.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "hello",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "django_test",
  type: "success",
  issues: [
    {
      id: "import-outside-toplevel",
      path: "manage.py",
      location: {
        start_line: 10
      },
      message: "Import outside toplevel (django.core.management.execute_from_command_line)",
      object: {
        severity: "convention",
        "message-id": "C0415",
        module: "manage",
        obj: "main"
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "requests",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "tensorflow",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "test.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "test",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)

s.add_test(
  "opencv",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "test.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "test",
        obj: ""
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)
