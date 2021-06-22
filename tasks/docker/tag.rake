require_relative "common"

namespace :docker do
  desc 'Run docker tag'
  task :tag do
    include DockerTaskCommon

    sh "docker", "tag", image_name, image_name(tag: ENV["TAG_NEW"], registry: ENV["REGISTRY_NEW"])
  end
end
