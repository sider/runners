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
          assert_equal "200", Net::HTTP.get_response(URI(url)).code
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

      # minitest
      assert_links.call %w[https://docs.rubocop.org/rubocop-minitest/cops_minitest.html#minitestassertempty], "Minitest/AssertEmpty"

      # performance
      assert_links.call %w[https://docs.rubocop.org/rubocop-performance/cops_performance.html#performancecaller], "Performance/Caller"

      # unknown
      assert_links.call [], "Foo"
      assert_links.call [], "Foo/Bar"
    end
  end
end
