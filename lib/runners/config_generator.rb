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
            .config_example.strip.lines(chomp: true)
        end
      })
    end

    def validate(content)
      Config.new(path: Config::FILE_NAME, raw_content: content).validate
      content
    end
  end
end
