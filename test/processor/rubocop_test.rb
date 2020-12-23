require "test_helper"

class Runners::Processor::RuboCopTest < Minitest::Test
  include TestHelper

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def subject
    @subject
  end

  def setup_subject(workspace)
    @subject = Runners::Processor::RuboCop.new(
      guid: SecureRandom.uuid,
      working_dir: workspace.working_dir,
      config: config,
      trace_writer: trace_writer,
      git_ssh_path: nil
    ).tap do |s|
      def s.analyzer_id
        "rubocop"
      end
    end
  end

  def test_build_cop_links
    with_workspace do |workspace|
      setup_subject(workspace)

      assert_links = ->(expected, actual) {
        assert_equal expected, subject.send(:build_cop_links, actual)
        expected.each do |url|
          assert_equal "200", Net::HTTP.get_response(URI(url)).code, url
        end
      }

      # core
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_bundler.html#bundlerduplicatedgem], "Bundler/DuplicatedGem"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_gemspec.html#gemspecduplicatedassignment], "Gemspec/DuplicatedAssignment"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_layout.html#layoutemptylines], "Layout/EmptyLines"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_lint.html#lintdebugger], "Lint/Debugger"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_metrics.html#metricsabcsize], "Metrics/AbcSize"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_migration.html#migrationdepartmentname], "Migration/DepartmentName"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_naming.html#namingaccessormethodname], "Naming/AccessorMethodName"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_security.html#securityeval], "Security/Eval"
      assert_links.call %w[https://docs.rubocop.org/rubocop/cops_style.html#stylealias], "Style/Alias"

      # rails
      assert_links.call %w[https://docs.rubocop.org/rubocop-rails/cops_rails.html#railsactionfilter], "Rails/ActionFilter"

      # rspec
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_capybara.html#capybarafeaturemethods], "Capybara/FeatureMethods"
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_factorybot.html#factorybotcreatelist], "FactoryBot/CreateList"
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_rspec.html#rspecbe], "RSpec/Be"
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_rspec/capybara.html#rspeccapybarafeaturemethods], "RSpec/Capybara/FeatureMethods"
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_rspec/factorybot.html#rspecfactorybotattributedefinedstatically], "RSpec/FactoryBot/AttributeDefinedStatically"
      assert_links.call %w[https://docs.rubocop.org/rubocop-rspec/cops_rspec/rails.html#rspecrailshttpstatus], "RSpec/Rails/HttpStatus"

      # minitest
      assert_links.call %w[https://docs.rubocop.org/rubocop-minitest/cops_minitest.html#minitestassertempty], "Minitest/AssertEmpty"

      # performance
      assert_links.call %w[https://docs.rubocop.org/rubocop-performance/cops_performance.html#performancecaller], "Performance/Caller"

      # packaging
      assert_links.call %w[https://docs.rubocop.org/rubocop-packaging/cops_packaging.html#packagingbundlersetupintests], "Packaging/BundlerSetupInTests"

      # extensions...
      assert_links.call %w[https://www.rubydoc.info/gems/chefstyle/RuboCop/Cop/Chef/Ruby/GemspecRequireRubygems], "Chef/Ruby/GemspecRequireRubygems"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-discourse/RuboCop/Cop/Discourse/NoChdir], "Discourse/NoChdir"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-github/RuboCop/Cop/GitHub/RailsApplicationRecord], "GitHub/RailsApplicationRecord"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-graphql/RuboCop/Cop/GraphQL/ArgumentName], "GraphQL/ArgumentName"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-i18n/RuboCop/Cop/I18n/RailsI18n/DecorateString], "I18n/RailsI18n/DecorateString"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-jekyll/RuboCop/Cop/Jekyll/NoPAllowed], "Jekyll/NoPAllowed"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-rake/RuboCop/Cop/Rake/Desc], "Rake/Desc"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-rubycw/RuboCop/Cop/Rubycw/Rubycw], "Rubycw/Rubycw"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sequel/RuboCop/Cop/Sequel/ColumnDefault], "Sequel/ColumnDefault"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sketchup/RuboCop/Cop/SketchupBugs/RenderMode], "SketchupBugs/RenderMode"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sketchup/RuboCop/Cop/SketchupDeprecations/AddSeparatorToMenu], "SketchupDeprecations/AddSeparatorToMenu"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sketchup/RuboCop/Cop/SketchupPerformance/OpenSSL], "SketchupPerformance/OpenSSL"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sketchup/RuboCop/Cop/SketchupRequirements/Exit], "SketchupRequirements/Exit"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sketchup/RuboCop/Cop/SketchupSuggestions/AddGroup], "SketchupSuggestions/AddGroup"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-sorbet/RuboCop/Cop/Sorbet/FalseSigil], "Sorbet/FalseSigil"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-thread_safety/RuboCop/Cop/ThreadSafety/NewThread], "ThreadSafety/NewThread"
      assert_links.call %w[https://www.rubydoc.info/gems/rubocop-vendor/RuboCop/Cop/Vendor/RollbarLog], "Vendor/RollbarLog"

      # unknown
      assert_links.call [], "Foo"
      assert_links.call [], "Foo/Bar"
    end
  end
end
