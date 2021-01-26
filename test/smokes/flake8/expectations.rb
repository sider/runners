s = Runners::Testing::Smoke

default_version = "3.8.4"

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
      git_blame_info: {
        commit: :_, line_hash: "8d97b13e6750c908c25104463cd720d809a07218", original_line: 6, final_line: 6
      }
    },
    {
      path: "app1/admin.py",
      location: { start_line: 1, start_column: 1 },
      id: "F401",
      message: "'django.contrib.admin' imported but unused",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "323e9186fe895db31fee87b1cbda4b79d86b10b0", original_line: 1, final_line: 1
      }
    },
    {
      path: "app1/tests.py",
      location: { start_line: 1, start_column: 1 },
      id: "F401",
      message: "'django.test.TestCase' imported but unused",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "2e6e5fc64eb95df32294d8c3103ca2477604b051", original_line: 1, final_line: 1
      }
    },
    {
      path: "manage.py",
      location: { start_line: 14, start_column: 13 },
      id: "F401",
      message: "'django' imported but unused",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "9ff1054c627a227b994bd510bb69cdd202bda7bd", original_line: 14, final_line: 14
      }
    },
    {
      path: "app1/models.py",
      location: { start_line: 15, start_column: 13 },
      id: "F601",
      message: "dictionary key 'name' repeated with different values",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "1fb678efd219c18480db8dc1392e235b29560904", original_line: 15, final_line: 15
      }
    },
    {
      path: "app1/models.py",
      location: { start_line: 16, start_column: 13 },
      id: "F601",
      message: "dictionary key 'name' repeated with different values",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "dcd1a8b7b5f4dae176f5b0f730de8073335bc7a7", original_line: 16, final_line: 16
      }
    },
    {
      path: "app1/models.py",
      location: { start_line: 12, start_column: 15 },
      id: "F821",
      message: "undefined name 'ok'",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "89b0230e73fd52472e6c0badc2e2d6a7c53f7502", original_line: 12, final_line: 12
      }
    },
    {
      path: "app1/models.py",
      location: { start_line: 13, start_column: 9 },
      id: "F841",
      message: "local variable 'foo' is assigned to but never used",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "9e3d0eef894b284f69520605de2ae527421a9c2b", original_line: 13, final_line: 13
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2cb0bdaaa71ae90979f04f8ee6b55858b985dd1e", original_line: 2, final_line: 2
      }
    },
    {
      path: "foo.py",
      location: { start_line: 2, start_column: 1 },
      id: "W191",
      message: "indentation contains tabs",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "2cb0bdaaa71ae90979f04f8ee6b55858b985dd1e", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "no_user_config_enabled",
  type: "success",
  issues: [], # W191 is not issued.
  analyzer: { name: "Flake8", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "7685a618e081e273bac47658d6b0e4dbf76597a6", original_line: 2, final_line: 2
      }
    },
    {
      path: "foo2.py",
      location: { start_line: 3, start_column: 6 },
      id: "TAE002",
      message: "too complex annotation (4 > 3)",
      links: [],
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "de436b94e2ba3f59e974ac43c742803eede574cf", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "2adffcc2bb7a4a05843fc22fc672d085c41a6c0d", original_line: 4, final_line: 4
      }
    },
    {
      message: "local variable 'a' is assigned to but never used",
      links: [],
      id: "F841",
      path: "foo.py",
      location: { start_line: 5, start_column: 5 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "1eeb052376bc86f6fb9bf908aadec569ad534173", original_line: 5, final_line: 5
      }
    },
    {
      message: "local variable 'b' is assigned to but never used",
      links: [],
      id: "F841",
      path: "foo.py",
      location: { start_line: 6, start_column: 5 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "f1f53757c0a24473a4af28ec28bfd545d2bf98f4", original_line: 6, final_line: 6
      }
    },
    {
      message: "blank line at end of file",
      links: [],
      id: "W391",
      path: "foo.py",
      location: { start_line: 8, start_column: 1 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709", original_line: 8, final_line: 8
      }
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message: "`linter.flake8.plugins` value in `sideci.yml` is invalid",
  analyzer: :_
)

s.add_test(
  "python2",
  type: "failure",
  message: "`linter.flake8.version` in `sider.yml` is unsupported",
  analyzer: :_
)

s.add_test("dot_python_version", type: "success", issues: [], analyzer: { name: "Flake8", version: default_version })

s.add_test(
  "dot_python_version_2",
  type: "success",
  issues: [],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "option_config",
  type: "success",
  issues: [],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      message: "local variable 'a' is assigned to but never used",
      links: [],
      id: "F841",
      path: "src/bar.py",
      location: { start_line: 2, start_column: 5 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "1eeb052376bc86f6fb9bf908aadec569ad534173", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)

s.add_test(
  "option_target_multiple",
  type: "success",
  issues: [
    {
      message: "local variable 'a' is assigned to but never used",
      links: [],
      id: "F841",
      path: "lib/baz.py",
      location: { start_line: 2, start_column: 5 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "1eeb052376bc86f6fb9bf908aadec569ad534173", original_line: 2, final_line: 2
      }
    },
    {
      message: "local variable 'a' is assigned to but never used",
      links: [],
      id: "F841",
      path: "src/bar.py",
      location: { start_line: 2, start_column: 5 },
      object: nil,
      git_blame_info: {
        commit: :_, line_hash: "1eeb052376bc86f6fb9bf908aadec569ad534173", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Flake8", version: default_version }
)
