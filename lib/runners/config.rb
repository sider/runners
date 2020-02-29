module Runners
  class Config
    class BrokenYAML < UserError; end
    class InvalidConfiguration < UserError
      attr_reader :input_string

      def initialize(message, input_string)
        super(message)
        @input_string = input_string
      end
    end

    CONFIG_FILE_NAME = "sider.yml".freeze
    OLD_CONFIG_FILE_NAME = "sideci.yml".freeze

    attr_reader :working_dir, :input_string, :content

    def initialize(working_dir)
      @working_dir = working_dir
      @input_string = path&.read
      @content = check_schema(parse_yaml)
    end

    def path_name
      path&.basename&.to_s || CONFIG_FILE_NAME
    end

    def path_exist?
      path
    end

    def ignore
      Array(content&.fetch(:ignore))
    end

    private

    def path
      return @path if defined?(@path)
      @path = [working_dir / CONFIG_FILE_NAME, working_dir / OLD_CONFIG_FILE_NAME].find do |pathname|
        pathname.file?
      end
    end

    def parse_yaml
      input_string&.yield_self { |s| YAML.safe_load(s, symbolize_names: true) }
    rescue Psych::SyntaxError => exn
      message = "Your `#{path_name}` file may be broken (line #{exn.line}, column #{exn.column})."
      raise BrokenYAML, message
    end

    def check_schema(object)
      object ? Schema::Config.payload.coerce(object) : {}
    rescue StrongJSON::Type::UnexpectedAttributeError => exn
      message = "The attribute `#{exn.path}.#{exn.attribute}` of `#{path_name}` cannot exist."
      raise InvalidConfiguration.new(message, input_string)
    rescue StrongJSON::Type::TypeError => exn
      message = "The value of the attribute `#{exn.path}` of `#{path_name}` is invalid."
      raise InvalidConfiguration.new(message, input_string)
    end

  end
end
