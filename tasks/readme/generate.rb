require "yaml"

namespace :readme do
  desc "Generate README file"
  task :generate do
    root = Pathname(__dir__).join("..", "..")

    analyzers = YAML.safe_load(root.join("analyzers.yml").read, symbolize_names: true).fetch(:analyzers)

    analyzers = analyzers.sort_by { |_, analyzer| analyzer.fetch(:name).downcase }

    list = analyzers.map do |id, analyzer|
      links = []
      links << "[docker](https://hub.docker.com/r/sider/runner_#{id})"
      links << "[source](https://github.com/#{analyzer.fetch(:github)})" if analyzer.key?(:github)
      links << "[website](#{analyzer.fetch(:website)})" if analyzer.key?(:website)
      links << "[doc](https://help.sider.review/#{analyzer.fetch(:doc)})" if analyzer.key?(:doc)

      item = []
      item << analyzer.fetch(:name)
      item << (!links.empty? ? links.join(", ") : "-")
      item << (analyzer[:deprecated] ? "⚠️ *deprecated*" : "✅")
      "| #{item.join(' | ')} |"
    end

    generated_content = <<~MARKDOWN
      All #{analyzers.size} analyzers are provided as a Docker image:

      | Name | Links | Status |
      |:-----|:------|:------:|
      #{list.join("\n")}
    MARKDOWN

    start_tag = "<!-- AUTO-GENERATED-CONTENT:START (analyzers) -->"
    end_tag = "<!-- AUTO-GENERATED-CONTENT:END (analyzers) -->"

    readme = root.join("README.md")
    new_content = readme.read.sub(
      /#{Regexp.escape start_tag}.+#{Regexp.escape end_tag}/m,
      "#{start_tag}\n#{generated_content}#{end_tag}"
    )
    readme.write(new_content)

    if system("git", "diff", "--exit-code", readme.to_path)
      puts "No changes on #{readme.relative_path_from(root)}."
    else
      abort <<~MSG
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ERROR: Changes found on #{readme.relative_path_from(root)}. You should commit the changes.
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      MSG
    end
  end
end
