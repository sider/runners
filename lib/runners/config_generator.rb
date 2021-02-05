module Runners
  class ConfigGenerator
    def generate(tools: [])
      content = load_template(tools)
      validate(content)
    end

    private

    def load_template(tools)
      filename = "config_template.yml.erb"
      erb = ERB.new((Pathname(__dir__.to_s) / filename).read, trim_mode: "-")
      erb.filename = filename
      erb.result_with_hash({
        tools: tools,
        analyzers: Analyzers.new,
        tool_examples: tools.each_with_object({}) do |tool, examples|
          examples[tool] = (_ = Processor.children.fetch(tool)) # TODO: Ignored Steep error
            .config_example
            .then { |hash| deep_stringify_keys(hash) }
            .to_yaml
            .delete_prefix("---")
            .strip
            .lines(chomp: true)
        end
      })
    end

    def validate(content)
      Config.new(path: Config::FILE_NAME, raw_content: content).validate
      content
    end

    # @see https://github.com/rails/rails/blob/c03933af23557945dd7d5d1359779d2ea461542c/activesupport/lib/active_support/core_ext/hash/keys.rb#L116
    def deep_stringify_keys(object)
      case object
      when Hash
        object.each_with_object({}) do |entry, result|
          key, value = entry
          result[key.to_s] = deep_stringify_keys(value)
        end
      when Array
        object.map { |elem| deep_stringify_keys(elem) }
      else
        object
      end
    end
  end
end
