require "test_helper"

class PythonTest < Minitest::Test
  include TestHelper

  def test_pip_install
    with_workspace do |workspace|
      processor = new_processor(workspace, yaml: <<~YAML)
        linter:
          flake8:
            dependencies:
              - flake8-bugbear
              - flake8-builtins==1.4.1
              - git+https://github.com/PyCQA/flake8-import-order.git@51e16f33065512afa1a85a20b2c2d3be768f78ea
              - { name: "flake8-docstrings", version: "==1.6.0" }
      YAML

      args_list = []
      processor.stub :capture3!, ->(*args) { args_list << args } do
        processor.pip_install
      end
      assert_equal [%w[pip install --quiet --only-binary :all: --disable-pip-version-check flake8-bugbear flake8-builtins==1.4.1 git+https://github.com/PyCQA/flake8-import-order.git@51e16f33065512afa1a85a20b2c2d3be768f78ea flake8-docstrings==1.6.0],
                    %w[pip list --verbose --disable-pip-version-check]],
                   args_list
    end
  end

  def test_pip_install_failure
    with_workspace do |workspace|
      processor = new_processor(workspace)

      exec_error = begin
        processor.capture3! "rmdir", "unknown dir"
      rescue => exn
        exn
      end

      error = assert_raises Runners::Python::PipInstallFailed do
        processor.stub :capture3!, ->(*) { raise exec_error } do
          processor.pip_install ["foo", "bar"]
        end
      end
      assert_equal "`pip install` failed: `foo`, `bar`", error.message
    end
  end

  private

  def processor_class
    @processor_class ||= Class.new(Runners::Processor) do
      include Runners::Python

      def analyzer_id; :flake8; end
      def analyzer_bin; "flake8"; end
      def analyzer_name; "Flake8"; end
    end
  end

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def new_processor(workspace, yaml: "")
    processor_class.new(
      guid: "test-guid",
      working_dir: workspace.working_dir,
      config: config(yaml),
      shell: Runners::Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
      trace_writer: trace_writer,
    )
  end
end
