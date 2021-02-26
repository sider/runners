module Runners
  class ConfigGenerator
    def generate(tools: [])
      content = load_template(tools.map(&:to_sym))
      validate(content)
    end

    private

    def load_template(tools)
      filename = __FILE__.sub(".rb", ".yml.erb")
      erb = ERB.new(File.read(filename), trim_mode: "-")
      erb.filename = filename
      erb.result_with_hash({
        tools: tools.sort,
        analyzers: Analyzers.new,
        tool_examples: tools.each_with_object({}) do |tool, examples|
          examples[tool] = Processor.children.fetch(tool).config_example.strip.lines(chomp: true)
        end
      })
    end

    def validate(content)
      Config.new(path: Config::FILE_NAME, raw_content: content).validate
      content
    end
  end
end
