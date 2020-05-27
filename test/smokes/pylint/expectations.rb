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
      id: "C0114",
      path: "bad.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "C0326",
      path: "bad.py",
      location: {
        start_line: 3
      },
      message: "No space allowed before bracket\n        print (\"{} * {} = {}\".format(i, j, i*j))\n              ^",
      object: {
        severity: "convention"
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
      id: "C0114",
      path: "folder/bad1.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "C0114",
      path: "folder/bad2.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention"
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
      id: "C0114",
      path: "bad.py",
      location: {
        start_line: 1
      },
      message: "Missing module docstring",
      object: {
        severity: "convention"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "C0326",
      path: "bad.py",
      location: {
        start_line: 3
      },
      message: "No space allowed before bracket\n        print (\"{} * {} = {}\".format(i, j, i*j))\n              ^",
      object: {
        severity: "convention"
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
      id: "E0211",
      path: "bad.py",
      location: {
        start_line: 4
      },
      message: "Method has no argument",
      object: {
        severity: "error"
      },
      links: [],
      git_blame_info: nil
    },
    {
      id: "E0602",
      path: "bad.py",
      location: {
        start_line: 2
      },
      message: "Undefined variable 'temp'",
      object: {
        severity: "error"
      },
      links: [],
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Pylint", version: "2.5.2" }
)
