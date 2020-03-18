Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "config_option",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "DL3026",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
      path: "Dockerfile",
      location: { start_line: 7 },
      message: "Use only an allowed registry in the FROM image",
      object: { severity: "error" },
      git_blame_info: nil
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "Dockerfile",
      location: { start_line: 10 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: "1.17.5" }
)

Smoke.add_test(
  "default",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "src/Dockerfile",
      location: { start_line: 3 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3003",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3003],
      path: "src/Dockerfile",
      location: { start_line: 4 },
      message: "Use WORKDIR to switch to a directory",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "src/Dockerfile",
      location: { start_line: 6 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: "1.17.5" }
)

Smoke.add_test(
  "multi_dockerfile",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "1/Dockerfile",
      location: { start_line: 3 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "2/Dockerfile",
      location: { start_line: 3 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "Dockerfile.production",
      location: { start_line: 3 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "hadolint", version: "1.17.5" }
)

Smoke.add_test(
  "option_ignore",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "hadolint", version: "1.17.5" } }
)

Smoke.add_test(
  "option_ignore_multi",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "hadolint", version: "1.17.5" } }
)

Smoke.add_test(
  "no_dockerfile",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: "No Docker files found",
    analyzer: { name: "hadolint", version: "1.17.5" }
  }
)

Smoke.add_test(
  "trusted_registry",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "DL3026",
        links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
        path: "Dockerfile",
        location: { start_line: 4 },
        message: "Use only an allowed registry in the FROM image",
        object: { severity: "error" },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "hadolint", version: "1.17.5" }
  }
)

Smoke.add_test(
  "trusted_registry_multi",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "DL3026",
        links: %w[https://github.com/hadolint/hadolint/wiki/DL3026],
        path: "Dockerfile",
        location: { start_line: 7 },
        message: "Use only an allowed registry in the FROM image",
        object: { severity: "error" },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "hadolint", version: "1.17.5" }
  }
)
