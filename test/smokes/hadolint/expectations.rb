s = Runners::Testing::Smoke

default_version = "1.18.0"

s.add_test(
  "config_option",
  type: "success",
  issues: [
    {
      id: "DL3026",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
      path: "Dockerfile",
      location: { start_line: 7, start_column: 1 },
      message: "Use only an allowed registry in the FROM image",
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "Dockerfile",
      location: { start_line: 10, start_column: 1 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)

s.add_test(
  "default",
  type: "success",
  issues: [
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "src/Dockerfile",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3003",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3003],
      path: "src/Dockerfile",
      location: { start_line: 4, start_column: 1 },
      message: "Use WORKDIR to switch to a directory",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "src/Dockerfile",
      location: { start_line: 6, start_column: 1 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)

s.add_test(
  "multi_dockerfile",
  type: "success",
  issues: [
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "1/Dockerfile",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "2/Dockerfile",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "Dockerfile.production",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)

s.add_test("option_ignore", type: "success", issues: [], analyzer: { name: "hadolint", version: default_version })

s.add_test("option_ignore_multi", type: "success", issues: [], analyzer: { name: "hadolint", version: default_version })

s.add_test("no_dockerfile", type: "success", issues: [], analyzer: { name: "hadolint", version: default_version })

s.add_test(
  "invalid_option_target",
  type: "failure", message: "Invalid Dockerfile(s) specified.", analyzer: { name: "hadolint", version: default_version }
)

s.add_test(
  "trusted_registry",
  type: "success",
  issues: [
    {
      id: "DL3026",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
      path: "Dockerfile",
      location: { start_line: 4, start_column: 1 },
      message: "Use only an allowed registry in the FROM image",
      object: { severity: "error" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)

s.add_test(
  "trusted_registry_multi",
  type: "success",
  issues: [
    {
      id: "DL3026",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
      path: "Dockerfile",
      location: { start_line: 7, start_column: 1 },
      message: "Use only an allowed registry in the FROM image",
      object: { severity: "error" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)
