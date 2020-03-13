require "test_helper"

class Runners::Processor::RemarkLintTest < Minitest::Test
  include TestHelper

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def subject
    @subject
  end

  def setup_subject(workspace)
    @subject = Runners::Processor::RemarkLint.new(
      guid: SecureRandom.uuid,
      workspace: workspace,
      config: config,
      trace_writer: trace_writer,
      git_ssh_path: nil
    ).tap do |s|
      stub(s).analyzer_id { "remark_lint" }
    end
  end

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
