require "runners/analyzers"

namespace :readme do
  desc "Generate README file"
  task :generate do
    analyzers = Runners::Analyzers.new

    list = analyzers.map do |id, analyzer|
      links = [
        "[docker](#{analyzers.docker(id)})",
        "[source](#{analyzers.github(id)})",
        "[doc](#{analyzers.doc(id)})",
      ]
      analyzers.website(id).tap do |url|
        links << "[website](#{url})" if url
      end

      items = [
        analyzers.name(id),
        links.join(", "),
      ]
      items << case
               when analyzers.deprecated?(id)
                 "⚠️ *deprecated*"
               when analyzers.beta?(id)
                 "✅ *beta*"
               else
                 "✅"
               end

      "| #{items.join(' | ')} |"
    end

    generated_content = <<~MARKDOWN
      All **#{analyzers.size}** analyzers are provided as a Docker image:

      | Name | Links | Status |
      |:-----|:------|:------:|
      #{list.sort_by(&:downcase).join("\n")}
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
