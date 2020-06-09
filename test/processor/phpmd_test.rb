require "test_helper"

class Runners::Processor::PhpmdTest < Minitest::Test
  include TestHelper

  Phpmd = Runners::Processor::Phpmd

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def subject(workspace, yaml: nil)
    Phpmd.new(guid: SecureRandom.uuid, working_dir: workspace.working_dir, config: config(yaml), git_ssh_path: nil, trace_writer: trace_writer).tap do |s|
      stub(s).analyzer_id { "phpmd" }
    end
  end

  def test_target_files
    with_workspace do |workspace|
      assert_equal ["*.php"], subject(workspace).send(:target_files)
      assert_equal ["*.php"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: php
      YAML
      assert_equal ["*.php", "*.phtml"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: php,phtml
      YAML
      assert_equal ["*.a", "*.b"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: a,b
      YAML
    end
  end
end
