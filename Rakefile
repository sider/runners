require "rake/testtask"
require 'erb'
require "aufgaben/release"
require "aufgaben/bump/ruby"

import(*FileList["tasks/**/*.rake"])

task default: ["steep:check", :test]

ENV["DOCKER_BUILDKIT"] = "1"

Aufgaben::Release.new(:release, depends: ["dockerfile:verify_devon_rex"]) do |t|
  t.files = ["lib/runners/version.rb", "Gemfile.lock"]
end

Aufgaben::Bump::Ruby.new do |t|
  t.files = [".ruby-version", "runners.gemspec"]
end

desc "Check the current Node.js environment"
task :check_nodejs do
  sh "npm", "install", "--no-progress", "--no-save"
end

Rake::TestTask.new(:test) do |t|
  t.deps = [:check_nodejs]
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'].exclude(%r{^test/smokes})
end
