require "open3"
require "tmpdir"

namespace :docker do
  desc 'Run timeout_test to ensure timeout(1) stops Runners'
  task :timeout_test do
    # NOTE: Either analyzer is fine, I chose it because of its lightness.
    ENV['ANALYZER'] = 'code_sniffer'

    # Build docker images with dummy code
    Dir.mktmpdir do |dir|
      FileUtils.cp_r('.', dir)
      Dir.chdir(dir) do
        File.write('lib/runners/cli.rb', Pathname(__dir__).join('cli_dummy.rb').read)
        Rake::Task['docker:build'].invoke
      end
    end

    _, stderr, status = Open3.capture3 "docker", "run", "--rm", image_name, '--timeout', '1s'
    status.exitstatus == 124 or abort "Expected exit status is 124, but the actual value is #{status.exitstatus}"
    !stderr.include?('unexpected method invocation') or abort "Bugsnag is expected to be called"
    sh "pgrep", "sleep" do |ok|
      abort "sleep(1) still remains! It's unexpected." if ok
    end
  end
end
