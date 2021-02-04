require_relative "lib/runners/version"

Gem::Specification.new do |spec|
  spec.name          = "runners"
  spec.version       = Runners::VERSION
  spec.authors       = ["Sider Corporation"]
  spec.email         = ["support@siderlabs.com"]

  spec.summary       = "Sider analyzer framework."
  spec.description   = "Sider Runners is a framework for analysis tools that run on Sider."
  spec.homepage      = "https://github.com/sider/runners"
  spec.license       = "MIT"

  # NOTE: It must be same as devon_rex and .ruby-version
  spec.required_ruby_version = [">= 2.7.2", "< 3.0.0"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "analyzers.yml", "exe/*", "lib/runners/**/*.rb", "sig/runners/**/*.rbs"]
  spec.bindir        = "exe"
  spec.executables   = ["runners"]
  spec.require_paths = ["lib"]

  # standard libraries
  spec.add_dependency "bundler", ">= 2.2.8", "< 2.3.0" # NOTE: It must be same as devon_rex.
  spec.add_dependency "fileutils", ">= 1.5"
  spec.add_dependency "forwardable", ">= 1.3"
  spec.add_dependency "json", ">= 2.5"
  spec.add_dependency "open3", ">= 0.1"
  spec.add_dependency "psych", ">= 3.2" # yaml
  spec.add_dependency "rexml", ">= 3.2"
  spec.add_dependency "strscan", ">= 3.0"

  # 3rd-party libraries
  spec.add_dependency "aws-sdk-s3", ">= 1.87"
  spec.add_dependency "bugsnag", ">= 6.18"
  spec.add_dependency "git_diff_parser", ">= 3.2"
  spec.add_dependency "jsonseq", ">= 0.2"
  spec.add_dependency "retryable", ">= 3.0"
  spec.add_dependency "strong_json", ">= 2.1"

  spec.add_development_dependency "amazing_print"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "parallel"
  spec.add_development_dependency "rainbow"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "unification_assertion"
end
