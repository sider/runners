module Runners
  class Config
    class Error < UserError
      attr_reader :path_name
      attr_reader :raw_content

      def initialize(message, path_name:, raw_content:)
        super(message)
        @path_name = path_name
        @raw_content = raw_content
      end
    end

    class BrokenYAML < Error
      attr_reader :line
      attr_reader :column

      def initialize(message, path_name:, raw_content:, line:, column:)
        super(message, path_name: path_name, raw_content: raw_content)
        @line = line
        @column = column
      end
    end

    class InvalidConfiguration < Error
      attr_reader :attribute

      def initialize(message, path_name:, raw_content:, attribute:)
        super(message, path_name: path_name, raw_content: raw_content)
        @attribute = attribute
      end
    end

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
      @path = path ? Pathname(path) : path
      @raw_content = raw_content
    end

    def raw_content!
      raw_content or raise "No raw content!"
    end

    def content
      @content ||= check_schema(parse).freeze
    end
    alias validate content

    def valid?
      validate
      true
    rescue Error
      false
    end

    def invalid?
      !valid?
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

    def check_unsupported_linters(linter_ids)
      list = linter_ids.filter { |id| linter?(id) }

      if list.empty?
        ""
      else
        list = list.map { |id| "- `linter.#{id}`" }.join("\n")
        <<~MSG
          The following linters in your `#{path_name}` are no longer supported. Please remove them.
          #{list}
        MSG
      end
    end

    def exclude_branch?(branch)
      Array(content.dig(:branches, :exclude)).any? do |pattern|
        # @type var pattern: String
        match = pattern.match(%r{\A/(.+)/(i)?\z})
        if match
          pat, ignorecase = match.captures
          if pat
            Regexp.compile(pat, !!ignorecase).match?(branch)
          else
            raise "Unexpected regexp: #{match.inspect}"
          end
        else
          pattern == branch
        end
      end
    end

    def parse
      yaml = raw_content || ""
      begin
        YAML.safe_load(yaml, symbolize_names: true, filename: path_name)
      rescue Psych::SyntaxError => exn
        raise BrokenYAML.new(
          "`#{exn.file}` is broken at line #{exn.line} and column #{exn.column}",
          path_name: path_name, raw_content: yaml, line: exn.line, column: exn.column,
        )
      end
    end

    private

    def check_schema(object)
      object ? Schema::Config.payload.coerce(object) : {}
    rescue StrongJSON::Type::UnexpectedAttributeError => exn
      attr = [exn.path, exn.attribute].join(".")
      raise InvalidConfiguration.new(
        "`#{attr.delete_prefix('$.')}` in `#{path_name}` is unsupported",
        path_name: path_name, raw_content: raw_content || "", attribute: attr,
      )
    rescue StrongJSON::Type::TypeError => exn
      attr = exn.path.to_s
      raise InvalidConfiguration.new(
        "`#{attr.delete_prefix('$.')}` value in `#{path_name}` is invalid",
        path_name: path_name, raw_content: raw_content || "", attribute: attr,
      )
    end
  end
end
