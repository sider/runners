s = Runners::Testing::Smoke

default_version = "2.9.6"

s.add_test(
  "success",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "failure",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "8c8f23cfb0c26eaf47a78c98f6e90533b229116a", original_line: 1, final_line: 1
      }
    },
    {
      id: "too-many-format-args",
      path: "bad.py",
      location: { start_line: 3, start_column: 15 },
      message: "Too many arguments for format string",
      object: {
        severity: "error",
        "message-id": "E1305",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "d114f06295e290e37f11d1dbadbac862d2dc0071", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "target",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "folder/bad1.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad1",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "272701334ce58ed8041b1b1e0216b9431842025c", original_line: 1, final_line: 1
      }
    },
    {
      id: "missing-module-docstring",
      path: "folder/bad2.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad2",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "272701334ce58ed8041b1b1e0216b9431842025c", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "rcfile",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "ignore",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "8c8f23cfb0c26eaf47a78c98f6e90533b229116a", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "errors_only",
  type: "success",
  issues: [
    {
      id: "no-method-argument",
      path: "bad.py",
      location: { start_line: 4, start_column: 4 },
      message: "Method has no argument",
      object: {
        severity: "error",
        "message-id": "E0211",
        module: "bad",
        obj: "TestFile.temp_method"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "220bf0aa0692d91f99ee0790fa61938fc09c2c4d", original_line: 4, final_line: 4
      }
    },
    {
      id: "undefined-variable",
      path: "bad.py",
      location: { start_line: 2, start_column: 11 },
      message: "Undefined variable 'temp'",
      object: {
        severity: "error",
        "message-id": "E0602",
        module: "bad",
        obj: "TestFile"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "6af676d6e34026fd28cc6bc81c840bd76ac0d3f2", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "flask",
  type: "success",
  issues: [
    {
      id: "missing-function-docstring",
      path: "hello.py",
      location: { start_line: 6, start_column: 0 },
      message: "Missing function or method docstring",
      object: {
        severity: "convention",
        "message-id": "C0116",
        module: "hello",
        obj: "hello_world"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "a3a7f8f418d186dcf9849a0109ed2cfb1c24c0c6", original_line: 6, final_line: 6
      }
    },
    {
      id: "missing-module-docstring",
      path: "hello.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "hello",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "cc9c88711b0517823e90ce00baaa3863a4bfba30", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "django_test",
  type: "success",
  issues: [
    {
      id: "import-outside-toplevel",
      path: "manage.py",
      location: { start_line: 10, start_column: 8 },
      message: "Import outside toplevel (django.core.management.execute_from_command_line)",
      object: {
        severity: "convention",
        "message-id": "C0415",
        module: "manage",
        obj: "main"
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "96d7a1723fd96637fe38d110e9e262372287d404", original_line: 10, final_line: 10
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "requests",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "bad.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "bad",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "e142e4ed031418d66622829a170aaf5acbefa151", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "tensorflow",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "test.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "test",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "10a66dce57db9d83a6f85691b6412012c7699632", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "opencv",
  type: "success",
  issues: [
    {
      id: "missing-module-docstring",
      path: "test.py",
      location: { start_line: 1, start_column: 0 },
      message: "Missing module docstring",
      object: {
        severity: "convention",
        "message-id": "C0114",
        module: "test",
        obj: ""
      },
      links: [],
      git_blame_info: {
        commit: :_, line_hash: "2b51dcf04711ede250a847c5e503850d6e9b8ad0", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Pylint", version: default_version }
)

s.add_test(
  "no_file",
  type: "success",
  issues: [],
  analyzer: { name: "Pylint", version: default_version }
)
