s = Runners::Testing::Smoke

default_version = "1.23.0"

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
      git_blame_info: {
        commit: :_, line_hash: "278b3d6f700478d9b4f4aa83d7f28c41c3327af2", original_line: 7, final_line: 7
      }
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "Dockerfile",
      location: { start_line: 10, start_column: 1 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: {
        commit: :_, line_hash: "70c4be007ce1997b606c977d7c7848b2cde751d5", original_line: 10, final_line: 10
      }
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
      git_blame_info: {
        commit: :_, line_hash: "da2e7862fe70b923317ff6e1618427fe9042e2f0", original_line: 3, final_line: 3
      }
    },
    {
      id: "DL3003",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3003],
      path: "src/Dockerfile",
      location: { start_line: 4, start_column: 1 },
      message: "Use WORKDIR to switch to a directory",
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "5ce64e3cdf80180d43ccdc2ad8ca56e7a3d5d678", original_line: 4, final_line: 4
      }
    },
    {
      id: "DL3031",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3031],
      path: "src/Dockerfile",
      location: { start_line: 8, start_column: 1 },
      message: "Do not use yum update.",
      object: { severity: "error" },
      git_blame_info: {
        commit: :_, line_hash: "c6292a1322790770c4eed92927df26b55be75c67", original_line: 8, final_line: 8
      }
    },
    {
      id: "SC2028",
      links: %w[https://github.com/koalaman/shellcheck/wiki/SC2028],
      path: "src/Dockerfile",
      location: { start_line: 6, start_column: 1 },
      message: "echo may not expand escape sequences. Use printf.",
      object: { severity: "info" },
      git_blame_info: {
        commit: :_, line_hash: "70c4be007ce1997b606c977d7c7848b2cde751d5", original_line: 6, final_line: 6
      }
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
      git_blame_info: {
        commit: :_, line_hash: "da2e7862fe70b923317ff6e1618427fe9042e2f0", original_line: 3, final_line: 3
      }
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "2/Dockerfile",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "da2e7862fe70b923317ff6e1618427fe9042e2f0", original_line: 3, final_line: 3
      }
    },
    {
      id: "DL3002",
      links: %w[https://github.com/hadolint/hadolint/wiki/DL3002],
      path: "Dockerfile.production",
      location: { start_line: 3, start_column: 1 },
      message: "Last USER should not be root",
      object: { severity: "warning" },
      git_blame_info: {
        commit: :_, line_hash: "da2e7862fe70b923317ff6e1618427fe9042e2f0", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "278b3d6f700478d9b4f4aa83d7f28c41c3327af2", original_line: 4, final_line: 4
      }
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
      git_blame_info: {
        commit: :_, line_hash: "278b3d6f700478d9b4f4aa83d7f28c41c3327af2", original_line: 7, final_line: 7
      }
    }
  ],
  analyzer: { name: "hadolint", version: default_version }
)
