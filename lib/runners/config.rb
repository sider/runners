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
      attr_reader :problem

      def initialize(message, path_name:, raw_content:, line:, column:, problem:)
        super(message, path_name: path_name, raw_content: raw_content)
        @line = line
        @column = column
        @problem = problem
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

    def self.register_warnings(&block)
      @warning_checkers ||= []
      @warning_checkers << block
    end

    def self.check_warnings(config)
      @warning_checkers.each do |checker|
        checker.call(config)
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

    def validate
      content # load
      self.class.check_warnings(self)
    end

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
      parsed_content = parse # must not do schema-check
      ids = linter_ids.map(&:to_sym).filter { |id| parsed_content&.dig(:linter, id) }

      if ids.empty?
        ""
      else
        list = ids.map { |id| "- `#{linter_field_path(id)}`" }.join("\n")
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
          "`#{exn.file}` is broken at line #{exn.line} and column #{exn.column} (#{exn.problem})",
          path_name: path_name, raw_content: yaml, line: exn.line, column: exn.column, problem: exn.problem,
        )
      end
    end

    def field_path(*fields)
      fields.map(&:to_s).join(".")
    end

    def linter_field_path(*fields)
      field_path(:linter, *fields)
    end

    def warnings
      @warnings ||= Warnings.new
    end

    def add_warning_for_deprecated_option(analyzer:, old:, new:)
      linter = linter(analyzer)
      return unless linter[old]

      old_path = linter_field_path(analyzer, old)
      new_path = linter_field_path(analyzer, new)
      warnings.add "The `#{old_path}` option is deprecated. Please use the `#{new_path}` option instead in your `#{path_name}`.", file: path_name
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
