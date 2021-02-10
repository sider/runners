require "test_helper"

class Runners::Processor::HamlLintTest < Minitest::Test
  include TestHelper

  def test_config_parallel_with_unsupported_versions
    with_subject do |subject|
      subject.stub :analyzer_version, "0.35.0" do
        assert_equal [], subject.send(:config_parallel)
      end
    end
  end

  def test_config_parallel_with_supported_versions
    with_subject do |subject|
      subject.stub :analyzer_version, "0.36.0" do
        subject.stub :config_linter, {} do
          assert_equal ["--parallel"], subject.send(:config_parallel)
        end

        subject.stub :config_linter, { parallel: true } do
          assert_equal ["--parallel"], subject.send(:config_parallel)
        end

        subject.stub :config_linter, { parallel: nil } do
          assert_equal ["--parallel"], subject.send(:config_parallel)
        end

        subject.stub :config_linter, { parallel: false } do
          assert_equal [], subject.send(:config_parallel)
        end
      end
    end
  end

  private

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def with_subject
    with_workspace do |workspace|
      yield Runners::Processor::HamlLint.new(
        guid: "test-guid",
        working_dir: workspace.working_dir,
        config: config,
        shell: Runners::Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
        trace_writer: trace_writer,
      )
    end
  end
end
