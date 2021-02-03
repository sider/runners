module Runners
  module RuboCopUtils
    def setup_default_rubocop_config
      path = current_dir / ".rubocop.yml"
      return if path.exist?

      path.parent.mkpath
      FileUtils.copy_file(Pathname(Dir.home) / "default_rubocop.yml", path)
      trace_writer.message "Set up the default RuboCop configuration file."
      path
    end

    def build_rubocop_links(cop_name)
      department, *extra = cop_name.split("/")

      if department && !extra.empty?
        case
        when department_to_gem_name.key?(department)
          gem_name = department_to_gem_name.fetch(department)
          fragment = cop_name.downcase.delete("/")
          if extra.size == 1
            return ["https://docs.rubocop.org/#{gem_name}/cops_#{department.downcase}.html##{fragment}"]
          else
            return ["https://docs.rubocop.org/#{gem_name}/cops_#{department.downcase}/#{extra.first&.downcase}.html##{fragment}"]
          end
        when department_to_gem_name_ext.key?(department)
          gem_name = department_to_gem_name_ext.fetch(department)
          return [
            "https://www.rubydoc.info/gems/#{gem_name}/RuboCop/Cop/#{cop_name}",
            *extract_urls(gem_info(gem_name)),
          ]
        end
      end

      []
    end

    private

    def department_to_gem_name
      @department_to_gem_name ||= {
        # rubocop
        "Bundler" => "rubocop",
        "Gemspec" => "rubocop",
        "Layout" => "rubocop",
        "Lint" => "rubocop",
        "Metrics" => "rubocop",
        "Migration" => "rubocop",
        "Naming" => "rubocop",
        "Security" => "rubocop",
        "Style" => "rubocop",

        # rubocop-rails
        "Rails" => "rubocop-rails",

        # rubocop-rspec
        "Capybara" => "rubocop-rspec",
        "FactoryBot" => "rubocop-rspec",
        "RSpec" => "rubocop-rspec",

        # rubocop-minitest
        "Minitest" => "rubocop-minitest",

        # rubocop-performance
        "Performance" => "rubocop-performance",

        # rubocop-packaging
        "Packaging" => "rubocop-packaging",
      }.freeze
    end

    def department_to_gem_name_ext
      @department_to_gem_name_ext ||= {
        "Chef" => "chefstyle",
        "Discourse" => "rubocop-discourse",
        "GitHub" => "rubocop-github",
        "GraphQL" => "rubocop-graphql",
        "I18n" => "rubocop-i18n",
        "Jekyll" => "rubocop-jekyll",
        "Rake" => "rubocop-rake",
        "Rubycw" => "rubocop-rubycw",
        "Sequel" => "rubocop-sequel",
        "SketchupBugs" => "rubocop-sketchup",
        "SketchupDeprecations" => "rubocop-sketchup",
        "SketchupPerformance" => "rubocop-sketchup",
        "SketchupRequirements" => "rubocop-sketchup",
        "SketchupSuggestions" => "rubocop-sketchup",
        "Sorbet" => "rubocop-sorbet",
        "ThreadSafety" => "rubocop-thread_safety",
        "Vendor" => "rubocop-vendor",
      }.freeze
    end
  end
end
