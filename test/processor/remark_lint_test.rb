require "test_helper"

class Runners::Processor::RemarkLintTest < Minitest::Test
  include TestHelper

  private

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def subject
    @subject
  end

  def setup_subject(workspace)
    @subject = Runners::Processor::RemarkLint.new(
      guid: SecureRandom.uuid,
      working_dir: workspace.working_dir,
      config: config,
      shell: Runners::Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
      trace_writer: trace_writer,
    ).tap do |s|
      def s.analyzer_id
        "remark_lint"
      end
    end
  end

  public

  def test_no_rc_files?
    with_workspace do |workspace|
      setup_subject(workspace)

      assert subject.send(:no_rc_files?)

      (subject.current_dir / ".remarkrc").tap do |f|
        f.write ""
        refute subject.send(:no_rc_files?)
        f.delete
      end

      (subject.current_dir / ".remarkrc.js").tap do |f|
        f.write ""
        refute subject.send(:no_rc_files?)
        f.delete
      end

      (subject.current_dir / "foo" / ".remarkrc.yml").tap do |f|
        f.parent.mkdir
        f.write ""
        refute subject.send(:no_rc_files?)
        f.delete
      end
    end
  end
end
