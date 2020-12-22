require_relative "common"

namespace :docker do
  desc 'Run smoke test on Docker'
  task :smoke do
    include DockerTaskCommon
    sh "bin/runners_smoke", image_name, "test/smokes/#{analyzer}/expectations.rb"
  end
end
