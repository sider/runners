require "runners/analyzers"
require "ostruct"

namespace :readme do
  desc "Generate README file"
  task :generate do
    analyzers = Runners::Analyzers.new

    emoji = OpenStruct.new(active: "✅", deprecated: "⚠️", beta: "🔨").freeze

    list = analyzers.map do |id, analyzer|
      links = ["[docker](#{analyzers.docker(id)})"]
      links << "[source](#{analyzers.github(id)})" if analyzers.github(id)
      links << "[doc](#{analyzers.doc(id)})"

      analyzers.website(id).tap do |url|
        links << "[website](#{url})" if url
      end

      items = [
        analyzers.name(id),
        links.join(", "),
      ]
      items << case
               when analyzers.deprecated?(id)
                 emoji.deprecated
               when analyzers.beta?(id)
                 emoji.beta
               else
                 emoji.active
               end

      "| #{items.join(' | ')} |"
    end

    generated_content = <<~MARKDOWN
      All **#{analyzers.size}** analyzers are provided as a Docker image:

      | Name | Links | Status |
      |:-----|:------|:------:|
      #{list.sort_by(&:downcase).join("\n")}

      #{emoji.active} - active, #{emoji.deprecated} - deprecated, #{emoji.beta} - beta
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
