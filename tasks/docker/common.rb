module DockerTaskCommon
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
end
