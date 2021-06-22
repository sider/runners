module DockerTaskCommon
  def image_name(tag: nil, registry: nil)
    tag ||= (ENV["TAG"] || "dev")
    registry ||= (ENV["REGISTRY"] || "sider") # https://hub.docker.com/u/sider

    "#{registry}/runner_#{analyzer}:#{tag}"
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
end
