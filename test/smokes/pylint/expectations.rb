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
