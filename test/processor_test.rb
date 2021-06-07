require "test_helper"

class ProcessorTest < Minitest::Test
  include TestHelper

  Processor = Runners::Processor
  Results = Runners::Results
  Analyzer = Runners::Analyzer
  Shell = Runners::Shell

  private

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def processor_class
    @processor_class ||= Class.new(Runners::Processor) do
      def analyzer_id
        :eslint
      end
    end
  end

  def new_processor(workspace:, config_yaml: nil)
    processor_class.new(
      guid: "test-guid",
      working_dir: workspace.working_dir,
      config: config(config_yaml),
      shell: Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
      trace_writer: trace_writer,
    )
  end

  public

  def test_capture3_success
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      stdout, stderr, status = processor.capture3 "/bin/echo", "1", "2", "3"

      # Returns status, stdout, and stderr
      assert_instance_of Process::Status, status
      assert_equal "1 2 3\n", stdout
      assert_equal "", stderr

      assert trace_writer.writer.find {|hash| hash[:trace] == :command_line && hash[:command_line] == ["/bin/echo", "1", "2", "3"] }
      assert trace_writer.writer.find {|hash| hash[:trace] == :stdout && hash[:string] == "1 2 3" }
      refute trace_writer.writer.find {|hash| hash[:trace] == :stderr }
      assert trace_writer.writer.find {|hash| hash[:trace] == :status && hash[:status] == 0 }
    end
  end

  def test_capture3bang_failure
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      error = begin
        processor.capture3! "rmdir", "no such dir"
      rescue => exn
        exn
      end

      assert_instance_of Shell::ExecError, error

      assert_equal :capture3, error.type
      assert_equal ["rmdir", "no such dir"], error.args
      assert_instance_of String, error.stdout_str
      assert_instance_of String, error.stderr_str
      assert_instance_of Process::Status, error.status
      assert_equal workspace.working_dir, error.dir

      assert trace_writer.writer.find {|hash| hash[:trace] == :command_line && hash[:command_line] == ["rmdir", "no such dir"] }
      assert trace_writer.writer.find {|hash| hash[:trace] == :stderr }
    end
  end

  def test_capture3_with_retry
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert_raises(Shell::ExecError) do
        processor.capture3_with_retry! "rmdir", "no such dir"
      end

      assert_equal 2, trace_writer.writer.count {|trace| trace[:message] == 'Command failed. Retrying...'}
    end
  end

  def test_error_inspection
    _, _, status = Open3.capture3("rmdir", "/no/such/path")
    error = Shell::ExecError.new(type: :capture3, args: ["/bin/echo", "hello"], stdout_str: "hello", stderr_str: "some error message", status: status, dir: Pathname("/"))

    assert_equal "#<Runners::Shell::ExecError: type=capture3, args=[\"/bin/echo\", \"hello\"], status=#{status.inspect}, dir=#<Pathname:/>, stdout_str=..., stderr_str=...>", error.inspect
  end

  def test_relative_path_from
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      # Returns relative path from working_dir
      assert_equal Pathname("foo/bar/baz"), processor.relative_path((workspace.working_dir / "foo/bar/baz").to_s)
      # Returns relative path from given path
      assert_equal Pathname("bar/baz"), processor.relative_path((workspace.working_dir / "foo/bar/baz").to_s, from: workspace.working_dir / "foo")

      # If relative path is given, interpreted from current_dir
      dir = (workspace.working_dir / "foo").tap(&:mkpath)
      processor.chdir(dir) do
        assert_equal Pathname("foo/bar/baz"), processor.relative_path("bar/baz")
      end
    end
  end

  def test_check_root_dir_exist
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          eslint:
            root_dir: path/to/unknown
      YAML
      result = processor.check_root_dir_exist
      assert_instance_of Runners::Results::Failure, result
      assert_equal "`path/to/unknown` directory is not found! Please check `linter.eslint.root_dir` in your `sider.yml`", result.message
      assert_nil result.analyzer
    end
  end

  def test_check_root_dir_exist_with_success
    with_workspace do |workspace|
      (workspace.working_dir / "abc").mkpath

      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          eslint:
            root_dir: abc
      YAML
      assert_nil processor.check_root_dir_exist
    end
  end

  def test_in_root_dir_with_config
    # when root_dir is given, run is invoked within the dir
    with_workspace do |workspace|
      (workspace.working_dir / "app/bar").mkpath

      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          eslint:
            root_dir: app/bar
      YAML

      processor.in_root_dir do |dir|
        assert_equal workspace.working_dir / "app/bar", dir
      end
    end
  end

  def test_in_root_dir_without_config
    # when root_dir is not given, run is invoked within the working_dir
    with_workspace do |workspace|
      (workspace.working_dir / "app/bar").mkpath

      processor = new_processor(workspace: workspace)

      processor.in_root_dir do |dir|
        assert_equal workspace.working_dir, dir
      end
    end
  end

  def test_add_warning
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      processor.add_warning('piyopiyo')
      processor.add_warning('hogehogehoge', file: 'path/to/hogehoge.rb')

      assert trace_writer.writer.find {|hash| hash[:trace] == :warning && hash[:message] == 'piyopiyo' && hash[:file] == nil }
      assert trace_writer.writer.find {|hash| hash[:trace] == :warning && hash[:message] == 'hogehogehoge' && hash[:file] == 'path/to/hogehoge.rb' }

      assert_equal [{message: 'piyopiyo', file: nil}, {message: 'hogehogehoge', file: 'path/to/hogehoge.rb'}], processor.warnings.as_json
    end
  end

  def test_abort_capture3
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      # Simulate aborted status
      mock_status = Minitest::Mock.new
      mock_status.expect(:success?, false)
      mock_status.expect(:exited?, false)
      mock_status.expect(:termsig, Signal.list.fetch('ABRT'))

      Open3.stub :capture3, ["", "", mock_status] do
        processor.capture3 "/bin/echo"

        assert_mock mock_status

        refute trace_writer.writer.find {|hash| hash[:trace] == :status && hash[:status] == 0 }
        assert trace_writer.writer.find {|hash| hash[:trace] == :error && hash[:message].include?("Process aborted or coredumped:") }
      end
    end
  end

  def test_timeout_capture3
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      # Simulate timeout status
      mock_status = Minitest::Mock.new
      mock_status.expect(:success?,  false)
      mock_status.expect(:exited?, false)
      mock_status.expect(:termsig, Signal.list.fetch('USR2'))

      Open3.stub :capture3, ["", "", mock_status] do
        ENV.stub :fetch, "20s" do
          processor.capture3 "/bin/echo"
        end

        assert_mock mock_status

        refute trace_writer.writer.find {|hash| hash[:trace] == :status && hash[:status] == 0 }
        assert trace_writer.writer.find {|hash| hash[:trace] == :error && hash[:message].include?("Analysis timeout (20s)")}
      end
    end
  end

  def test_directory_traversal_attack?
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert processor.directory_traversal_attack?("../../etc/passwd")
      assert processor.directory_traversal_attack?("config/../../../etc/passwd")
      refute processor.directory_traversal_attack?("foo")
      refute processor.directory_traversal_attack?("foo/bar")
    end
  end

  def test_analyzer_bin
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert_equal "eslint", processor.analyzer_bin
    end
  end

  def test_analyzer_version
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      processor.stub :capture3!, ["1.2.3", ""] do
        assert_equal "1.2.3", processor.analyzer_version
      end
    end
  end

  def test_extract_version
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      # from stdout
      processor.stub :capture3!, ["Foo v10.20.1", ""] do
        assert_equal "10.20.1", processor.extract_version!("foo")
      end

      # from stderr
      processor.stub :capture3!, ["", "7.8.20 version\n"] do
        assert_equal "7.8.20", processor.extract_version!("foo", ["bar", "version"])
      end

      # non semver
      processor.stub :capture3!, ["Foo 1.2", ""] do
        assert_equal "1.2", processor.extract_version!("foo")
      end

      # change pattern
      processor.stub :capture3!, ["ver 1.2", ""] do
        assert_equal "1.2", processor.extract_version!("foo", ["bar", "-v"], pattern: /ver (\d+.\d+)\b/)
      end

      # receive array command
      processor.stub :capture3!, ["v1.2.3", ""] do
        assert_equal "1.2.3", processor.extract_version!(["foo", "bar"])
      end
    end
  end

  def test_extract_version_failed
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      error = assert_raises(ArgumentError) { processor.extract_version!([]) }
      assert_equal 'Unspecified command: `["--version"]`', error.message

      error = assert_raises(ArgumentError) { processor.extract_version!([], nil) }
      assert_equal "Unspecified command", error.message

      processor.stub :capture3!, ["no version", ""] do
        error = assert_raises(ArgumentError) { processor.extract_version!("foo", "-v") }
        assert_equal "Not found version from the command `foo -v`", error.message
      end
    end
  end

  def test_report_file
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      assert_match(%r{/eslint_report_.+\.txt$}, processor.report_file)
      assert_equal processor.report_file, processor.report_file
    end
  end

  def test_report_file_exist
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      assert processor.report_file_exist?
      FileUtils.remove_file processor.report_file
      refute processor.report_file_exist?
    end
  end

  def test_read_report_file
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file").tap { |f| f.write "foo" }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      assert_equal "foo", processor.read_report_file(file)
    end
  end

  def test_read_report_file_failed
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)
      assert_raises(Errno::ENOENT) { processor.read_report_file("not_found") }
    end
  end

  def test_read_report_xml
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.xml").tap { |f| f.write "<foo></foo>" }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      root = processor.read_report_xml(file)
      assert_instance_of Nokogiri::XML::Document, root
      assert_equal <<~MSG, root.to_s
        <?xml version=\"1.0\"?>
        <foo/>
      MSG
    end
  end

  def test_read_report_xml_failed
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.xml").tap { |f| f.write "" }

      processor = new_processor(workspace: workspace)
      error = assert_raises(Processor::InvalidXML) { processor.read_report_xml(file.to_path) }
      assert_equal 'Empty document', error.message

      file.write "<foo"
      error = assert_raises(Processor::InvalidXML) { processor.read_report_xml(file.to_path) }
      assert_equal "1:5: FATAL: Couldn't find end of Start Tag foo line 1", error.message
    end
  end

  def test_read_report_json
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.json").tap { |f| f.write '{"a":1}' }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      assert_equal({ a: 1 }, processor.read_report_json(file))
    end
  end

  def test_read_report_json_empty
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.json").tap { |f| f.write '' }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      assert_raises(JSON::ParserError) { processor.read_report_json(file) }
      assert_nil processor.read_report_json(file) { nil }
      assert_equal [], processor.read_report_json(file) { [] }
    end
  end

  def test_read_report_json_failed
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.json").tap { |f| f.write '{' }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      assert_raises(JSON::ParserError) { processor.read_report_json(file) }
    end
  end

  def test_comma_separated_list
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert_nil processor.comma_separated_list(nil)
      assert_nil processor.comma_separated_list([])
      assert_nil processor.comma_separated_list("")
      assert_equal "a", processor.comma_separated_list("a")
      assert_equal "a,b", processor.comma_separated_list("a,b")
      assert_equal "a,b", processor.comma_separated_list("a , b")
      assert_equal "a", processor.comma_separated_list(["a"])
      assert_equal "a,b", processor.comma_separated_list(["a", "b"])
      assert_equal "a,b,c", processor.comma_separated_list(["a,b", "c"])
      assert_equal "a,b,c,d,e", processor.comma_separated_list(["a,b", "c", "d , e"])
    end
  end

  def test_extract_urls
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert_equal [], processor.extract_urls(nil)
      assert_equal [], processor.extract_urls("")
      assert_equal ["http://example.com"], processor.extract_urls("http://example.com")
      assert_equal ["https://example.com"], processor.extract_urls("https://example.com")
      assert_equal ["https://example.com/foo", "https://example.com/bar"],
                   processor.extract_urls("(https://example.com/foo, https://example.com/bar)")
      assert_equal [], processor.extract_urls("ftp://example.com foo@example.com")
    end
  end

  def test_children
    assert_equal Runners::Processor::Eslint, Runners::Processor.children[:eslint]
    assert_equal Runners::Processor::RuboCop, Runners::Processor.children[:rubocop]
    assert_nil Runners::Processor.children[:unknown]
  end
end
