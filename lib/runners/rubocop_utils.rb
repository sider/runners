module Runners
  module RuboCopUtils
    # The followings are maintained by the RuboCop organization.
    # @see https://github.com/rubocop
    def official_rubocop_plugins
      @official_rubocop_plugins ||= %w[
        rubocop-md
        rubocop-minitest
        rubocop-performance
        rubocop-rails
        rubocop-rake
        rubocop-rspec
        rubocop-rubycw
        rubocop-sequel
      ].map do |name|
        Ruby::GemInstaller::Spec.new(name)
      end.freeze
    end

    def third_party_rubocop_plugins
      @third_party_rubocop_plugins ||= %w[
        chefstyle
        cookstyle
        deka_eiwakun
        ezcater_rubocop
        fincop
        forkwell_cop
        gc_ruboconfig
        gitlab-styles
        hint-rubocop_style
        mad_rubocop
        meowcop
        onkcop
        otacop
        pulis
        relaxed-rubocop
        rubocop-airbnb
        rubocop-betterment
        rubocop-cask
        rubocop-codetakt
        rubocop-config-umbrellio
        rubocop-discourse
        rubocop-github
        rubocop-govuk
        rubocop-graphql
        rubocop-i18n
        rubocop-jekyll
        rubocop-packaging
        rubocop-rails_config
        rubocop-require_tools
        rubocop-salemove
        rubocop-shopify
        rubocop-sketchup
        rubocop-sorbet
        rubocop-thread_safety
        rubocop-vendor
        salsify_rubocop
        sanelint
        standard
        unasukecop
        unifacop
        ws-style
      ].map do |name|
        Ruby::GemInstaller::Spec.new(name)
      end.freeze
    end

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
