require_relative "common"

namespace :docker do
  desc 'Run interactive shell in the specified Docker container'
  task :shell, [:bash_extra_args] do |_task, args|
    include DockerTaskCommon
    run_args = (args[:bash_extra_args] || "").split(/\s+/)
    workdir = "/work"
    sh "docker", "run", "-it", "--rm", "--entrypoint=bash", "--volume=#{Dir.pwd}:#{workdir}", "--workdir=#{workdir}", *run_args, image_name
  end
end
