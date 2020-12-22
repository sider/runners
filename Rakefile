require "rake/testtask"
require 'erb'
require "aufgaben/release"
require "aufgaben/bump/ruby"

import(*FileList["tasks/**/*.rake"])

task default: [:"steep:check", :test]

ENV["DOCKER_BUILDKIT"] = "1"

Aufgaben::Release.new(:release) do |t|
  t.files = ["lib/runners/version.rb"]
end
task release: [:"dockerfile:verify_devon_rex"]

Aufgaben::Bump::Ruby.new do |t|
  t.files = %w[
    .ruby-version
    .github/workflows/bump_analyzers.yml
  ]
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'].exclude(%r{^test/smokes})
end
