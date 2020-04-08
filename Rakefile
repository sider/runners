require "rake/testtask"
require 'erb'
require "aufgaben/release"
require "aufgaben/bump/ruby"
require_relative "lib/tasks/bump/analyzers"
require_relative "lib/tasks/bump/devon_rex"
require_relative "lib/tasks/docker/timeout_test"
require_relative "lib/tasks/readme/generate"

Aufgaben::Release.new do |t|
  t.files = ["lib/runners/version.rb"]
end

Aufgaben::Bump::Ruby.new do |t|
  t.files = %w[
    .ruby-version
    .github/workflows/bump_analyzers.yml
  ]
end

ANALYZERS = begin
  Dir.chdir("images") do
    Dir.glob("*").select { |f| File.directory? f }.freeze
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb'].exclude(%r{^test/smokes})
end

task :default => [:test, :typecheck]

task :typecheck do
  # FIXME: Must check all files.
  files = Dir.glob("lib/runners/**/*.rb").reject { |f| f.include? "processor/" }
  sh "steep", "check", *files
end

namespace :dockerfile do
  def render_erb(file, analyzer: ENV.fetch('ANALYZER'))
    locals = {
      analyzer: analyzer,
      chown: '${RUNNER_USER}:${RUNNER_GROUP}',
    }

    res = ERB.new(File.read(file), trim_mode: "<>").result_with_hash(locals)
    "\n#{res.strip}\n" # Ensure to start with one newline and end with one newline
  end

  desc 'Generate Dockerfile from a template'
  task :generate do
    ANALYZERS.each do |analyzer|
      backup_analyzer = ENV['ANALYZER']
      ENV['ANALYZER'] = analyzer
      dir = Pathname('images') / analyzer
      file = dir / 'Dockerfile.erb'
      content = <<~EOD
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
        # PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #{render_erb(file, analyzer: analyzer).strip}
      EOD
      (dir / 'Dockerfile').write(content)
    ensure
      if backup_analyzer
        ENV['ANALYZER'] = backup_analyzer
      else
        ENV.delete 'ANALYZER'
      end
    end
  end

  desc 'Verify Dockerfile is committed'
  task :verify do
    system('git diff --exit-code') or
      abort "\nError: Run `bundle exec rake dockerfile:generate` and include the changes in commit"
  end
end

namespace :docker do
  def image_name(t = tag)
    "sider/runner_#{analyzer}:#{t}"
  end

  def build_context
    Pathname('images') / analyzer
  end

  def analyzer
    key = 'ANALYZER'
    ENV[key].tap do |value|
      abort <<~MSG if value.nil? || value.empty?
        Error: `#{key}` environment variable must be required. For example, run as follow:

            $ #{key}=rubocop bundle exec rake docker:build
      MSG
    end
  end

  def tag
    ENV.fetch('TAG') { 'dev' }
  end

  def docker_user
    ENV.fetch('DOCKER_USER')
  end

  def docker_password
    ENV.fetch('DOCKER_PASSWORD')
  end

  desc 'Run docker build'
  task :build => 'dockerfile:generate' do
    sh "docker", "build", "--tag", image_name, "--file", "#{build_context}/Dockerfile", "."
  end

  desc 'Run smoke test on Docker'
  task :smoke do
    sh "bin/runners_smoke", image_name, "test/smokes/#{analyzer}/expectations.rb"
  end

  desc 'Run docker push'
  task :push do
    sh "docker", "login", "--username", docker_user, "--password", docker_password
    begin
      sh "docker", "push", image_name
      if ENV["TAG_LATEST"] == "true"
        image_name_with_new_tag = image_name("latest")
        sh "docker", "tag", image_name, image_name_with_new_tag
        sh "docker", "push", image_name_with_new_tag
      end
    ensure
      sh "docker", "logout"
    end
  end

  desc 'Run interactive shell in the specified Docker container'
  task :shell, [:bash_extra_args] do |_task, args|
    run_args = (args[:bash_extra_args] || "").split(/\s+/)
    sh "docker", "run", "-it", "--rm", "--entrypoint=bash", "--volume=#{Dir.pwd}:/workdir", *run_args, image_name
  end
end
