module Runners
  class ConfigGenerator
    def generate(tools: [])
      content = load_template(tools.map(&:to_sym))
      validate(content)
    end

    private

    def load_template(tools)
      tools_and_examples = tools.each_with_object({}) do |tool, hash|
        example_lines = Processor.children.fetch(tool).config_example.strip.lines(chomp: true)
        hash[tool] = example_lines unless example_lines.empty?
      end

      filename = __FILE__.gsub(/\.rb\Z/, ".yml.erb")
      erb = ERB.new(File.read(filename), trim_mode: "-")
      erb.filename = filename
      erb.result_with_hash({
        tools: tools_and_examples.keys.sort,
        analyzers: Analyzers.new,
        tool_examples: tools_and_examples,
      })
    end

    def validate(content)
      Config.new(path: Config::FILE_NAME, raw_content: content).validate
      content
    end
  end
end
