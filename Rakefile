require "rake/testtask"
require 'erb'
require "aufgaben/release"
require "aufgaben/bump/ruby"

import(*FileList["tasks/**/*.rake"])

ENV["DOCKER_BUILDKIT"] = "1"

Aufgaben::Release.new(:release) do |t|
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
    sh 'git', 'diff', '--exit-code' do |ok|
      unless ok
        abort "\nError: Run `bundle exec rake dockerfile:generate` and include the changes in commit"
      end
    end
  end

  desc 'Verify the devon_rex image tag'
  task :verify_devon_rex do
    disallowed_tag = 'master'
    sh 'git', 'grep', '--quiet', "/devon_rex_.+:#{disallowed_tag}", 'images/' do |found|
      if found
        abort "\nError: Disallow to release with the `#{disallowed_tag}` tag of the devon_rex images."
      end
    end
  end
end

task :release => "dockerfile:verify_devon_rex"

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
    workdir = "/work"
    sh "docker", "run", "-it", "--rm", "--entrypoint=bash", "--volume=#{Dir.pwd}:#{workdir}", "--workdir=#{workdir}", *run_args, image_name
  end
end
