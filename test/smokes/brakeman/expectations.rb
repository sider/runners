s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "Gemfile.lock",
      location: { start_line: 81 },
      id: "Cross-Site Scripting-102",
      message:
        "Rails 4.2.7 content_tag does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 66 },
      id: "Cross-Site Scripting-106",
      message: "Loofah 2.0.3 is vulnerable (CVE-2018-8048). Upgrade to 2.1.2",
      links: %w[https://github.com/flavorjones/loofah/issues/144],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 98 },
      id: "Cross-Site Scripting-107",
      message: "rails-html-sanitizer 1.0.3 is vulnerable (CVE-2018-3741). Upgrade to 1.0.4",
      links: %w[https://groups.google.com/d/msg/rubyonrails-security/tP7W3kLc5u4/uDy2Br7xBgAJ],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 81 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: "4.3.1" }
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
        "Rails 4.2.7 content_tag does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 66 },
      id: "Cross-Site Scripting-106",
      message: "Loofah 2.0.3 is vulnerable (CVE-2018-8048). Upgrade to 2.1.2",
      links: %w[https://github.com/flavorjones/loofah/issues/144],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 98 },
      id: "Cross-Site Scripting-107",
      message: "rails-html-sanitizer 1.0.3 is vulnerable (CVE-2018-3741). Upgrade to 1.0.4",
      links: %w[https://groups.google.com/d/msg/rubyonrails-security/tP7W3kLc5u4/uDy2Br7xBgAJ],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "rails_app/Gemfile.lock",
      location: { start_line: 81 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: "4.3.1" }
)

s.add_test("not_rails", type: "failure", message: :_, analyzer: { name: "Brakeman", version: "4.3.1" })

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
      object: nil,
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: nil,
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
        "Rails 4.2.7 content_tag does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "Gemfile.lock",
      location: { start_line: 63 },
      id: "SQL Injection-103",
      message: "Rails 4.2.7 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1",
      links: %w[https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Brakeman", version: "4.3.1" },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        `brakeman 4.3.1` is installed instead of `4.4.0` in your `Gemfile.lock`.
        Because `4.4.0` does not satisfy our constraints `>= 4.0.0, < 4.4.0`.

        If you want to use a different version of `brakeman`, please do either:
        - Update your `Gemfile.lock` to satisfy the constraint
        - Set the `linter.brakeman.gems` option in your `sider.yml`
      MESSAGE
      file: nil
    }
  ]
)
