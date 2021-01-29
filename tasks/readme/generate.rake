require "yaml"

namespace :readme do
  desc "Generate README file"
  task :generate do
    filename = "analyzers.yml"
    analyzers = YAML.safe_load(File.read(filename), filename: filename, symbolize_names: true)
      .fetch(:analyzers)
      .sort_by { |_, analyzer| analyzer.fetch(:name).downcase }

    list = analyzers.map do |id, analyzer|
      links = []
      links << "[docker](https://hub.docker.com/r/sider/runner_#{id})"
      links << "[source](https://github.com/#{analyzer.fetch(:github)})" if analyzer.key?(:github)
      links << "[doc](https://help.sider.review/#{analyzer.fetch(:doc)})" if analyzer.key?(:doc)
      links << "[website](#{analyzer.fetch(:website)})" if analyzer.key?(:website)

      item = []
      item << analyzer.fetch(:name)
      item << (!links.empty? ? links.join(", ") : "-")
      item << (analyzer[:deprecated] ? "⚠️ *deprecated*" : "✅")
      "| #{item.join(' | ')} |"
    end

    generated_content = <<~MARKDOWN
      All **#{analyzers.size}** analyzers are provided as a Docker image:

      | Name | Links | Status |
      |:-----|:------|:------:|
      #{list.join("\n")}
    MARKDOWN

    start_tag = "<!-- AUTO-GENERATED-CONTENT:START (analyzers) -->"
    end_tag = "<!-- AUTO-GENERATED-CONTENT:END (analyzers) -->"

    readme = Pathname("README.md")
    new_content = readme.read.sub(
      /#{Regexp.escape start_tag}.+#{Regexp.escape end_tag}/m,
      "#{start_tag}\n#{generated_content}#{end_tag}"
    )
    readme.write(new_content)

    sh("git", "diff", "--exit-code", readme.to_path) do |ok|
      if ok
        puts "No changes on #{readme}."
      else
        abort <<~MSG
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          ERROR: Changes found on #{readme}. You should commit the changes.
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        MSG
      end
    end
  end
end
