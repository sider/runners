require "test_helper"

class ProcessorTest < Minitest::Test
  include TestHelper

  Processor = Runners::Processor
  Results = Runners::Results
  Analyzer = Runners::Analyzer
  Shell = Runners::Shell

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def processor_class
    @processor_class ||= Class.new(Runners::Processor) do
      def analyzer_id
        "eslint"
      end
    end
  end

  def new_processor(workspace:, git_ssh_path: nil, config_yaml: nil)
    processor_class.new(
      guid: SecureRandom.uuid,
      working_dir: workspace.working_dir,
      config: config(config_yaml),
      git_ssh_path: git_ssh_path,
      trace_writer: trace_writer,
    )
  end

  def test_capture3_env_setup
    with_workspace do |workspace|
      mock_status = Minitest::Mock.new
      mock_status.expect :success?, false
      mock_status.expect :exited?, true
      mock_status.expect :exitstatus, 3

      mock_capture3 = Minitest::Mock.new
      mock_capture3.expect :call, ["", "", mock_status], [
        { "RUBYOPT" => nil, "GIT_SSH" => (workspace.working_dir / "id_rsa").to_s },
        "ls",
        chdir: workspace.working_dir.to_s, stdin_data: nil
      ]

      Open3.stub :capture3, mock_capture3 do
        processor = new_processor(workspace: workspace, git_ssh_path: (workspace.working_dir / "id_rsa"))
        processor.capture3_trace("ls")

        assert_mock mock_status
        assert_mock mock_capture3
      end
    end
  end

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

      assert_equal [{message: 'piyopiyo', file: nil}, {message: 'hogehogehoge', file: 'path/to/hogehoge.rb'}], processor.warnings
    end
  end

  def test_add_warning_if_deprecated_version
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      def processor.analyzer_version
        '1.0.0'
      end

      processor.add_warning_if_deprecated_version(minimum: '0.9.9')
      processor.add_warning_if_deprecated_version(minimum: '1.0.0')
      processor.add_warning_if_deprecated_version(minimum: '1.0.1')
      processor.add_warning_if_deprecated_version(minimum: '2.0.0', file: "foo")
      processor.add_warning_if_deprecated_version(minimum: '2.0.0', deadline: Time.new(2020, 1, 9))

      expected_message = ->(v) { <<~MSG.strip }
        DEPRECATION WARNING!!!
        The `1.0.0` and older versions are deprecated, and these versions will be dropped in the near future.
        Please consider upgrading to #{v} or a newer version.
      MSG
      expected_message2 = ->(v) { <<~MSG.strip }
        DEPRECATION WARNING!!!
        The `1.0.0` and older versions are deprecated, and these versions will be dropped on January 9, 2020.
        Please consider upgrading to #{v} or a newer version.
      MSG

      assert_equal(
        [
          { trace: :warning, message: expected_message.call("1.0.1"), file: nil },
          { trace: :warning, message: expected_message.call("2.0.0"), file: "foo" },
          { trace: :warning, message: expected_message2.call("2.0.0"), file: nil },
        ],
        trace_writer.writer.map { |hash| hash.slice(:trace, :message, :file) }.select { |hash| hash[:trace] == :warning },
      )
      assert_equal(
        [
          { message: expected_message.call("1.0.1"), file: nil },
          { message: expected_message.call("2.0.0"), file: "foo" },
          { message: expected_message2.call("2.0.0"), file: nil },
        ],
        processor.warnings,
      )
    end
  end

  def test_add_warning_if_deprecated_options
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          eslint:
            options:
              ext: .ts
      YAML

      processor.add_warning_if_deprecated_options

      expected_message = <<~MSG.strip
        DEPRECATION WARNING!!!
        The `linter.eslint.options` option is deprecated. Fix your `sider.yml` as follows:
        See https://help.sider.review/tools/javascript/eslint for details.

        ```diff
         linter:
           eslint:
        -    options:
        -      foo: "bar"
        +    foo: "bar"
        ```
      MSG

      assert_equal(
        [{ trace: :warning, message: expected_message, file: "sider.yml" }],
        trace_writer.writer.map { |hash| hash.slice(:trace, :message, :file) }.select { |hash| hash[:trace] == :warning },
      )
      assert_equal(
        [{ message: expected_message, file: "sider.yml" }],
        processor.warnings,
      )
    end
  end

  def test_add_warning_for_deprecated_option
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace, config_yaml: <<~YAML)
        linter:
          eslint:
            dir: src
      YAML

      processor.add_warning_for_deprecated_option(:dir, to: :target)

      expected_message = <<~MSG.strip
        DEPRECATION WARNING!!!
        The `linter.eslint.dir` option is deprecated. Use the `linter.eslint.target` option instead in your `sider.yml`.
        See https://help.sider.review/tools/javascript/eslint for details.
      MSG

      assert_equal(
        [{ trace: :warning, message: expected_message, file: "sider.yml" }],
        trace_writer.writer.filter_map { |hash| hash.slice(:trace, :message, :file) if hash[:trace] == :warning },
      )
      assert_equal(
        [{ message: expected_message, file: "sider.yml" }],
        processor.warnings,
      )
    end
  end

  def test_add_warning_for_deprecated_linter
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      processor.add_warning_for_deprecated_linter(alternative: "Foo", ref: "https://foo/bar")
      processor.add_warning_for_deprecated_linter(alternative: "Foo", ref: "https://foo/bar", deadline: Time.new(2020, 12, 31))

      expected_message = ->(time) { <<~MSG.strip }
        DEPRECATION WARNING!!!
        The support for ESLint is deprecated and will be removed #{time}.
        Please migrate to Foo as an alternative. See https://foo/bar
      MSG

      assert_equal(
        [
          { trace: :warning, message: expected_message.call("in the near future"), file: "sider.yml" },
          { trace: :warning, message: expected_message.call("on December 31, 2020"), file: "sider.yml" },
        ],
        trace_writer.writer.map { |hash| hash.slice(:trace, :message, :file) }.select { |hash| hash[:trace] == :warning },
      )
      assert_equal(
        [
          { message: expected_message.call("in the near future"), file: "sider.yml" },
          { message: expected_message.call("on December 31, 2020"), file: "sider.yml" },
        ],
        processor.warnings,
      )
    end
  end

  def test_abort_capture3
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      # Simulate aborted status
      mock_status = Minitest::Mock.new
      mock_status.expect(:success?, false)
      mock_status.expect(:exited?, false)

      Open3.stub :capture3, ["", "", mock_status] do
        processor.capture3 "/bin/echo"

        assert_mock mock_status

        refute trace_writer.writer.find {|hash| hash[:trace] == :status && hash[:status] == 0 }
        assert trace_writer.writer.find {|hash| hash[:trace] == :error && hash[:message].include?("Process aborted or coredumped:") }
      end
    end
  end

  def test_env_hash
    with_workspace do |workspace|
      processor = new_processor(workspace: workspace)

      assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil }, processor.env_hash)

      processor.push_env_hash({ "RBENV_VERSION" => "2.5.0" }) do
        assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil, "RBENV_VERSION" => "2.5.0" },
                     processor.env_hash)
      end

      assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil }, processor.env_hash)
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
      assert_instance_of REXML::Document, processor.read_report_xml(file)
    end
  end

  def test_read_report_xml_failed
    with_workspace do |workspace|
      file = (workspace.working_dir / "a_file.xml").tap { |f| f.write "" }.then(&:to_path)

      processor = new_processor(workspace: workspace)
      error = assert_raises(Processor::InvalidXML) { processor.read_report_xml(file) }
      assert_equal "Output XML is invalid from #{file}", error.message

      File.write file, "<foo"
      assert_raises(REXML::ParseException) { processor.read_report_xml(file) }
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
end
