module Runners
  class SensitiveFilter
    FILTERED = "[FILTERED]".freeze

    def initialize(options:)
      @options = options
    end

    def mask(string)
      sensitives.inject(string) do |result, sensitive|
        result.gsub(sensitive, FILTERED)
      end
    end

    private

    def sensitives
      @sensitives ||= begin
        # @type var list: Array[String]
        list = []
        source = @options.source
        if source.is_a?(Options::GitSource)
          # @type var source: Options::GitSource
          user_info = source.git_url_userinfo
          list << user_info if user_info
        end
        list
      end
    end
  end
end
