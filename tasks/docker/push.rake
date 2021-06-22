require_relative "common"

namespace :docker do
  desc 'Run docker push'
  task :push do
    include DockerTaskCommon

    sh "docker", "push", image_name
  end
end
