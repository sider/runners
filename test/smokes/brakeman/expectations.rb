s = Runners::Testing::Smoke

default_version = "4.8.2"

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "Gemfile.lock",
      location: { start_line: 81 },
      id: "Cross-Site Scripting-102",
      message:
        "Rails 4.2.7 `content_tag` does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 66 },
      id: "Cross-Site Scripting-106",
      message: "loofah gem 2.0.3 is vulnerable (CVE-2018-8048). Upgrade to 2.2.1",
      links: %w[https://github.com/flavorjones/loofah/issues/144],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 98 },
      id: "Cross-Site Scripting-107",
      message: "rails-html-sanitizer 1.0.3 is vulnerable (CVE-2018-3741). Upgrade to rails-html-sanitizer 1.0.4",
      links: %w[https://groups.google.com/d/msg/rubyonrails-security/tP7W3kLc5u4/uDy2Br7xBgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 81 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: { severity: "High" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: default_version }
)

s.add_test(
  "subdir",
  type: "success",
  issues: [
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 81 },
      id: "Cross-Site Scripting-102",
      message:
        "Rails 4.2.7 `content_tag` does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 66 },
      id: "Cross-Site Scripting-106",
      message: "loofah gem 2.0.3 is vulnerable (CVE-2018-8048). Upgrade to 2.2.1",
      links: %w[https://github.com/flavorjones/loofah/issues/144],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 98 },
      id: "Cross-Site Scripting-107",
      message: "rails-html-sanitizer 1.0.3 is vulnerable (CVE-2018-3741). Upgrade to rails-html-sanitizer 1.0.4",
      links: %w[https://groups.google.com/d/msg/rubyonrails-security/tP7W3kLc5u4/uDy2Br7xBgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 81 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: { severity: "High" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: default_version }
)

s.add_test(
  "not_rails",
  type: "success",
  issues: [],
  analyzer: { name: "Brakeman", version: default_version },
  warnings: [{ message: <<~MSG.strip, file: "sider.yml" }]
    Brakeman is for Rails only. Your repository may not have a Rails application.
    If your Rails is not located in the root directory, configure your `sider.yml` as follows:

    ```yaml
    linter:
      brakeman:
        root_dir: "path/to/your/rails/root"
    ```
  MSG
)

s.add_test(
  "lowest_deps",
  type: "success",
  issues: [
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "Cross-Site Scripting-102",
      message:
        "Rails 4.2.7 content_tag does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: { severity: "High" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: "4.0.0" }
)

# Brakeman v4.4.0 and later is distributed under a non-OSS license.
# See https://brakemanscanner.org/blog/2019/01/17/brakeman-4-dot-4-dot-0-released
s.add_test(
  "new_licensed",
  type: "success",
  issues: [
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "Cross-Site Scripting-102",
      message:
        "Rails 4.2.7 `content_tag` does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: { severity: "Medium" },
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to Rails 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: { severity: "High" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: "4.4.0" }
)

s.add_test(
  "config_file",
  type: "success",
  issues: [
    {
      path: "app/models/user.rb",
      location: { start_line: 2 },
      id: "Authentication-101",
      message: "Hardcoded value for `SECRET` in source code",
      links: %w[https://brakemanscanner.org/docs/warning_types/authentication/],
      object: { severity: "Medium" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: default_version }
)
