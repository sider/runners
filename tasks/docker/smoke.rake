require_relative "common"
require_relative "../../test/smoke"

namespace :docker do
  desc 'Run smoke test on Docker'
  task :smoke do
    include DockerTaskCommon

    Runners::Testing::Smoke.new(
      docker_image: image_name,
      expectations_path: "test/smokes/#{analyzer}/expectations.rb",
      analyzer: analyzer,
    ).run
  end
end
