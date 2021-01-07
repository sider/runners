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

    FILE_NAME = "sider.yml".freeze
    FILE_NAME_OLD = "sideci.yml".freeze

    def self.load_from_dir(dir)
      file = [
        dir / FILE_NAME,
        dir / FILE_NAME_OLD,
      ].find(&:file?)

      new(path: file, raw_content: file&.read).tap do |config|
        config.content # parse content
      end
    end

    attr_reader :path, :raw_content

    def initialize(path:, raw_content:)
      @path = path
      @raw_content = raw_content
    end

    def raw_content!
      raw_content or raise "No raw content!"
    end

    def content
      @content ||= check_schema(parse_yaml(raw_content || "")).freeze
    end

    def path_name
      path&.basename&.to_path || FILE_NAME
    end

    def path_exist?
      !!path
    end

    def ignore_patterns
      @ignore_patterns ||= Array(content[:ignore])
    end

    def linter(id)
      (content.dig(:linter, id.to_sym) || {}).freeze
    end

    def linter?(id)
      !!content.dig(:linter, id.to_sym)
    end

    private

    def parse_yaml(text)
      YAML.safe_load(text, symbolize_names: true, filename: path_name)
    rescue Psych::SyntaxError => exn
      message = "Your `#{exn.file}` is broken at line #{exn.line} and column #{exn.column}. Please fix and retry."
      raise BrokenYAML.new(message, text)
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
