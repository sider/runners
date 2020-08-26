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
        @options.source.git_url_userinfo.tap do |info|
          list << info if info
        end
        list
      end
    end
  end
end
