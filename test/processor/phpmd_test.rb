require "test_helper"

class Runners::Processor::PhpmdTest < Minitest::Test
  include TestHelper

  Phpmd = Runners::Processor::Phpmd

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def subject(workspace)
    Phpmd.new(guid: SecureRandom.uuid, workspace: workspace, config: config, git_ssh_path: nil, trace_writer: trace_writer)
  end

  def test_target_files
    with_workspace do |workspace|
      assert_equal ["*.php"], subject(workspace).send(:target_files, {})
      assert_equal ["*.php"], subject(workspace).send(:target_files, { suffixes: "php" })
      assert_equal ["*.php", "*.phtml"], subject(workspace).send(:target_files, { suffixes: "php,phtml" })
      assert_equal ["*.a", "*.b"], subject(workspace).send(:target_files, { suffixes: "a,b" })
    end
  end
end
