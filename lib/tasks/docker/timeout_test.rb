require "open3"
require "tmpdir"

namespace :docker do
  desc 'Run timeout_test to ensure timeout(1) stops Runners'
  task :timeout_test do
    # NOTE: Either analyzer is fine, I chose it because of its lightness.
    ENV['ANALYZER'] = 'code_sniffer'
    ENV['RUNNERS_TIMEOUT'] = '5s'

    # Build docker images with dummy code
    Dir.mktmpdir do |dir|
      FileUtils.cp_r('.', dir)
      Dir.chdir(dir) do
        File.write('lib/runners/cli.rb', runners_cli_code)
        Rake::Task['docker:build'].invoke
      end
    end

    # Change the Docker image and include "rr"
    sh "docker", "run", "--name", container_name, "--entrypoint", "gem", image_name, "install", "rr"
    sh "docker", "commit", "--change", "ENTRYPOINT #{entrypoint}", "--change", "CMD []", container_name, image_name

    _, stderr, status = Open3.capture3 "docker", "run", "--rm", image_name
    status.exitstatus == 124 or abort "Expected exit status is 124, but the actual value is #{res.exitstatus}"
    !stderr.include?('unexpected method invocation') or abort "Bugsnag is expected to be called"
    sh "pgrep", "sleep" do |ok|
      abort "sleep(1) still remains! It's unexpected." if ok
    end
  ensure
    sh "docker", "rm", "--force", container_name
  end

  def container_name
    "runners_timeout_test"
  end

  def entrypoint
    stdout, _, _ = Open3.capture3 "docker inspect -f '{{ range $item := .Config.Entrypoint }}{{ $item }} {{ end }}' #{image_name}"
    stdout.split.inspect
  end

  def runners_cli_code
    <<~EOF
      require 'rr'
      include RR::DSL

      module Runners
        class CLI
          def initialize(**args)
          end

          def run
            Open3.capture3('sleep 10')
          end
        end
      end

      mock(Bugsnag).notify.with_any_args.once
      at_exit { verify }
    EOF
  end
end
