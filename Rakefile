require "rake/testtask"
require 'erb'
require "aufgaben/release"
require "aufgaben/bump/ruby"

import(*FileList["tasks/**/*.rake"])

task default: ["steep:check", :test]

ENV["DOCKER_BUILDKIT"] = "1"

Aufgaben::Release.new(:release, depends: ["dockerfile:verify_devon_rex"]) do |t|
  t.files = ["lib/runners/version.rb"]
end

Aufgaben::Bump::Ruby.new do |t|
  t.files = [".ruby-version", "runners.gemspec"]
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'].exclude(%r{^test/smokes})
end
