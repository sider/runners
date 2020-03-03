Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [
    {
      message: <<~MSG
        DEPRECATION WARNING!!!
        The support for gometalinter is deprecated. Sider will drop these versions on April 30, 2020.
        Please consider using an alternative tool GolangCi-Lint. See https://github.com/alecthomas/gometalinter/issues/590
      MSG
        .strip,
      file: "sider.yml"
    }
  ]
)

Smoke.add_test(
  "require_install",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "main.go",
        location: { start_line: 12 },
        id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
        message: "[vet] Printf call has arguments but no formatting directives",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [{ message: /The support for gometalinter is deprecated/, file: "sideci.yml" }]
)

Smoke.add_test(
  "private_dependency",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        path: "main.go",
        location: { start_line: 13 },
        id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
        message: "[vet] Printf call has arguments but no formatting directives",
        links: [],
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [{ message: /The support for gometalinter is deprecated/, file: "sideci.yml" }]
) { |config| config.ssh_key = "ssh_key" }

Smoke.add_test(
  "specify_config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "[golint] const Id should be ID",
        links: [],
        id: "36ef88e1b6c2a396d1032b473a93606e91fda03b",
        path: "main.go",
        location: { start_line: 9 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "[golint] comment on exported const Id should be of the form \"Id ...\"",
        links: [],
        id: "5058a11cfd937cc5547f20ededd3629ff875a2ca",
        path: "main.go",
        location: { start_line: 8 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "[golint] comment on exported function NoDocFunc should be of the form \"NoDocFunc ...\"",
        links: [],
        id: "54b8e33e5e4f35fef5654c7280e6e3b24be91de0",
        path: "main.go",
        location: { start_line: 19 },
        object: nil,
        git_blame_info: nil
      },
      {
        message:
          Regexp.new(Regexp.escape("[gotype] could not import os/exec (type-checking package \"os/exec\" failed")),
        links: [],
        id: "6a64372708d696ef4a6634706e74b3d9b69a813c",
        path: "main.go",
        location: { start_line: 5 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: Regexp.new(Regexp.escape("[gotype] could not import fmt (type-checking package \"fmt\" failed")),
        links: [],
        id: "873e123509f57e9ea64859ad99cf4aa3688949cb",
        path: "main.go",
        location: { start_line: 4 },
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [{ message: /The support for gometalinter is deprecated/, file: "sideci.yml" }]
)

Smoke.add_test(
  "install_path",
  {
    guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [
    { message: /The support for gometalinter is deprecated/, file: "sideci.yml" },
    { message: "`install_path` option is deprecated. Use `import_path` instead.", file: "sideci.yml" }
  ]
)

Smoke.add_test(
  "import_path",
  {
    guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [{ message: /The support for gometalinter is deprecated/, file: "sideci.yml" }]
)

Smoke.add_test(
  "import_path_and_install_path",
  {
    guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "gometalinter", version: "2.0.11" }
  },
  warnings: [{ message: /The support for gometalinter is deprecated/, file: "sideci.yml" }]
)
