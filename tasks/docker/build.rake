require_relative "common"

namespace :docker do
  desc 'Run docker build'
  task :build => 'dockerfile:generate' do
    include DockerTaskCommon
    sh "docker", "build", "--tag", image_name, "--file", "#{build_context}/Dockerfile", "."
  end
end
