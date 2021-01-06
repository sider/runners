module Runners
  class Config
    class Error < UserError
      attr_reader :raw_content

      def initialize(message, raw_content)
        super(message)
        @raw_content = raw_content
      end
    end

    class BrokenYAML < Error; end
    class InvalidConfiguration < Error; end

    CONFIG_FILE_NAME = "sider.yml".freeze
    OLD_CONFIG_FILE_NAME = "sideci.yml".freeze

    def self.load_from_dir(dir)
      file = [
        dir / CONFIG_FILE_NAME,
        dir / OLD_CONFIG_FILE_NAME,
      ].find(&:file?)

      new(file)
    end

    attr_reader :path, :raw_content, :content

    def initialize(path)
      @path = path
      @raw_content = path&.read
      @content = check_schema(parse_yaml).freeze
    end

    def raw_content!
      raw_content or raise "No raw content!"
    end

    def path_name
      path&.basename&.to_path || CONFIG_FILE_NAME
    end

    def path_exist?
      !!path
    end

    def ignore_patterns
      @ignore_patterns ||= Array(content[:ignore])
    end

    def linter(id)
      content.dig(:linter, id.to_sym).freeze || {}
    end

    def linter?(id)
      !!content.dig(:linter, id.to_sym)
    end

    private

    def parse_yaml
      raw_content&.yield_self { |s| YAML.safe_load(s, symbolize_names: true) }
    rescue Psych::SyntaxError => exn
      message = "Your `#{path_name}` is broken at line #{exn.line} and column #{exn.column}. Please fix and retry."
      raise BrokenYAML.new(message, raw_content!)
    end

    def check_schema(object)
      object ? Schema::Config.payload.coerce(object) : {}
    rescue StrongJSON::Type::UnexpectedAttributeError => exn
      attr = "#{exn.path}.#{exn.attribute}".delete_prefix("$.")
      message = "The attribute `#{attr}` in your `#{path_name}` is unsupported. Please fix and retry."
      raise InvalidConfiguration.new(message, raw_content!)
    rescue StrongJSON::Type::TypeError => exn
      attr = exn.path.to_s.delete_prefix("$.")
      message = "The value of the attribute `#{attr}` in your `#{path_name}` is invalid. Please fix and retry."
      raise InvalidConfiguration.new(message, raw_content!)
    end
  end
end
