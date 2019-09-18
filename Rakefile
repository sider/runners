require "rake/testtask"
require 'erb'
require "aufgaben/release"

Aufgaben::Release.new

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
  files = Dir.glob("lib/**/*.rb").reject { |f| f.include? "processor/" }
  files += Dir.glob("lib/**/cppcheck/**/*.rb")
  sh "steep", "check", *files
end

namespace :dockerfile do
  def render_erb(file)
    ERB.new(File.read(file)).result.chomp
  end

  desc 'Generate Dockerfile from a template'
  task :generate do
    ANALYZERS.each do |analyzer|
      backup_analyzer = ENV['ANALYZER']
      ENV['ANALYZER'] = analyzer
      path = Pathname('images') / analyzer
      template = ERB.new((path / 'Dockerfile.erb').read)
      result = <<~EOD
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
        # PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #{template.result.chomp}
      EOD
      File.write(path / 'Dockerfile', result)
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
  def image_name
    "sider/runner_#{analyzer}:#{tag}"
  end

  def image_name_latest
    "sider/runner_#{analyzer}:latest"
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
    key = 'TAG'
    ENV[key].tap do |value|
      abort <<~MSG if value.nil? || value.empty?
        Error: `#{key}` environment variable must be required. For example, run as follow:

            $ #{key}=dev bundle exec rake docker:build
      MSG
    end
  end

  def docker_user
    ENV.fetch('DOCKER_USER')
  end

  def docker_password
    ENV.fetch('DOCKER_PASSWORD')
  end

  desc 'Run docker build'
  task :build => 'dockerfile:generate' do
    sh "docker build -t #{image_name} -f #{build_context}/Dockerfile ."
  end

  desc 'Run smoke test on Docker'
  task :smoke do
    sh "bin/runners_smoke #{image_name} test/smokes/#{analyzer}/expectations.rb"
  end

  desc 'Run docker push'
  task :push do
    sh "docker login -u #{docker_user} -p #{docker_password}"
    sh "docker tag #{image_name} #{image_name_latest}"
    sh "docker push #{image_name}"
    sh "docker push #{image_name_latest}"
  end
end
