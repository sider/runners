require_relative "test_helper"

class ProcessorTest < Minitest::Test
  include TestHelper

  Processor = Runners::Processor
  Results = Runners::Results
  TraceWriter = Runners::TraceWriter
  Analyzer = Runners::Analyzer
  Shell = Runners::Shell

  def trace_writer
    @trace_writer ||= TraceWriter.new(writer: [])
  end

  def test_capture3_env_setup
    mktmpdir do |path|
      mock(Open3).capture3({"RUBYOPT" => nil, "GIT_SSH" => (path + "id_rsa").to_s},
                           "ls",
                           { chdir: path.to_s }) do
        status = Process::Status.allocate

        def status.exited?; true end
        def status.exitstatus; 3 end

        ["", "", status]
      end

      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: (path + "id_rsa").to_s, trace_writer: trace_writer)

      processor.capture3_trace("ls")
    end
  end

  def test_capture3_success
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      stdout, stderr, status = processor.capture3 "/bin/echo", "1", "2", "3"

      # Returns status, stdout, and stderr
      assert_instance_of Process::Status, status
      assert_match "1 2 3\n", stdout
      assert_equal "", stderr

      assert trace_writer.writer.find {|hash| hash[:trace] == 'command_line' && hash[:command_line] == %w(/bin/echo 1 2 3) }
      assert trace_writer.writer.find {|hash| hash[:trace] == 'stdout' && hash[:string] == "1 2 3\n" }
      refute trace_writer.writer.find {|hash| hash[:trace] == 'stderr' }
      assert trace_writer.writer.find {|hash| hash[:trace] == 'status' && hash[:status] == 0 }
    end
  end

  def test_capture3bang_failure
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

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
      assert_equal path, error.dir

      assert trace_writer.writer.find {|hash| hash[:trace] == 'command_line' && hash[:command_line] == ["rmdir", "no such dir"] }
      assert trace_writer.writer.find {|hash| hash[:trace] == 'stderr' }
    end
  end

  def test_capture3_with_retry
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

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
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      # Returns relative path from working_dir
      assert_equal Pathname("foo/bar/baz"), processor.relative_path((path + "foo/bar/baz").to_s)
      # Returns relative path from given path
      assert_equal Pathname("bar/baz"), processor.relative_path((path + "foo/bar/baz").to_s, from: path + "foo")

      # If relative path is given, interpreted from current_dir
      processor.push_dir path + "foo" do
        assert_equal Pathname("foo/bar/baz"), processor.relative_path("bar/baz")
      end
    end
  end

  def test_sider_yml
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      # No sider.yml
      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_nil processor.ci_config

      assert_equal({}, processor.ci_section)
      assert_equal({ "hello" => "world" }, processor.ci_section({ "hello" => "world" }))
    end

    mktmpdir do |path|
      # With an empty sider.yml
      path.join('sider.yml').write('')
      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_equal({}, processor.ci_config)

      assert_equal({}, processor.ci_section)
    end

    mktmpdir do |path|
      # With sider.yml
      (path + "sider.yml").write(YAML.dump({
                                              "linter" => {
                                                "foo_tool" => {
                                                  "root_dir" => "app/bar",
                                                  "options" => {
                                                    "exclude" => ".git",
                                                  },
                                                }
                                              }
                                            }))

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_instance_of Hash, processor.ci_config
      assert_instance_of Hash, processor.ci_section
      assert_equal({ "root_dir" => "app/bar", "options" => { "exclude" => ".git" } }, processor.ci_section)
      assert_equal({ "root_dir" => "app/bar", "options" => { "exclude" => ".git" } }, processor.ci_section("root_dir" => "app/hoge"))
      assert_equal({ "root_dir" => "app/bar", "glob" => "**/*.foo", "options" => { "exclude" => ".git" } }, processor.ci_section("glob" => "**/*.foo"))
      assert_equal({ "root_dir" => "app/bar", "options" => { "exclude" => ".git", "ignore" => "node_modules" } }, processor.ci_section("options" => { "ignore" => "node_modules" }))

      assert(trace_writer.writer.find{|hash|
        hash[:trace] == 'ci_config' && hash[:content] })
      assert(processor.ci_config.is_a?(Hash))
    end

    mktmpdir do |path|
      # With sideci.yml
      (path + "sideci.yml").write(YAML.dump({
                                              "linter" => {
                                                "foo_tool" => {
                                                  "root_dir" => "app"
                                                }
                                              }
                                            }))
      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_equal({ "root_dir" => "app" }, processor.ci_section)
    end

    mktmpdir do |path|
      # With sider.yml and sideci.yml
      (path + "sider.yml").write(YAML.dump({
                                              "linter" => {
                                                "foo_tool" => {
                                                  "root_dir" => "app"
                                                }
                                              }
                                            }))
      (path + "sideci.yml").write(YAML.dump({
                                              "linter" => {
                                                "foo_tool" => {
                                                  "root_dir" => "frontend"
                                                }
                                              }
                                            }))
      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_equal({ "root_dir" => "app" }, processor.ci_section)
    end
  end

  def test_check_root_dir_exist
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "root_dir" => "path/to/unknown" } } }))

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      result = processor.check_root_dir_exist
      assert_instance_of Runners::Results::Failure, result
      assert_equal "`path/to/unknown` directory is not found! Please check `linter.foo_tool.root_dir` in your `sider.yml`", result.message
      assert_nil result.analyzer
    end
  end

  def test_check_root_dir_exist_with_success
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "root_dir" => "abc" } } }))
      (path + "abc").mkpath

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      assert_nil processor.check_root_dir_exist
    end
  end

  def test_push_root_dir_with_config
    # when root_dir is given, run is invoked within the dir

    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "root_dir" => "app/bar" } } }))
      (path + "app/bar").mkpath

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      run_path = nil
      processor.push_root_dir do
        run_path = processor.current_dir
      end

      assert_equal path + "app/bar", run_path
    end
  end

  def test_push_root_dir_without_config
    # when root_dir is not given, run is invoked within the working_dir

    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "app/bar").mkpath

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      run_path = nil
      processor.push_root_dir do
        run_path = processor.current_dir
      end


      assert_equal path, run_path
    end
  end

  def test_add_warning
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      processor.add_warning('piyopiyo')
      processor.add_warning('hogehogehoge', file: 'path/to/hogehoge.rb')

      assert trace_writer.writer.find {|hash| hash[:trace] == 'warning' && hash[:message] == 'piyopiyo' && hash[:file] == nil }
      assert trace_writer.writer.find {|hash| hash[:trace] == 'warning' && hash[:message] == 'hogehogehoge' && hash[:file] == 'path/to/hogehoge.rb' }

      assert_equal [{message: 'piyopiyo', file: nil}, {message: 'hogehogehoge', file: 'path/to/hogehoge.rb'}], processor.warnings
    end
  end

  def test_ensure_runner_config_schema_with_expected_fields
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "root_dir" => "app/bar" } } }))

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      config = processor.ensure_runner_config_schema(StrongJSON.new { let :config, object(root_dir: string?) }.config) { |c| c }
      assert_equal({ root_dir: "app/bar" }, config)
    end
  end

  def test_ensure_runner_config_schema_with_unexpected_fields
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "npm_install" => true } } }))

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      result = processor.ensure_runner_config_schema(StrongJSON.new { let :config, object(root_dir: string?) }.config) { |c| c }
      assert_instance_of Runners::Results::Failure, result
      assert_equal "Invalid configuration in `sider.yml`: unknown attribute at config: `$.linter.foo_tool`", result.message
      assert_nil result.analyzer
    end
  end

  def test_ensure_runner_config_schema_with_unexpected_type
    klass = Class.new(Processor) do
      def self.ci_config_section_name
        "foo_tool"
      end
    end

    mktmpdir do |path|
      (path + "sider.yml").write(YAML.dump({ "linter" => { "foo_tool" => { "root_dir" => true } } }))

      processor = klass.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)
      result = processor.ensure_runner_config_schema(StrongJSON.new { let :config, object(root_dir: string?) }.config) { |c| c }
      assert_instance_of Runners::Results::Failure, result
      assert_equal "Invalid configuration in `sider.yml`: unexpected value at config: `$.linter.foo_tool.root_dir`", result.message
      assert_nil result.analyzer
    end
  end

  def test_abort_capture3
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      # Simulate aborted status
      stub(Open3).capture3 do
        status = Process::Status.allocate.tap do |object|
          def object.exited?
            false
          end

          def object.exitstatus
            nil
          end
        end

        ["", "", status]
      end

      _, _, status = processor.capture3 "/bin/echo"

      # Returns status, stdout, and stderr
      assert_instance_of Process::Status, status

      refute trace_writer.writer.find {|hash| hash[:trace] == 'status' && hash[:status] == 0 }
      assert trace_writer.writer.find {|hash| hash[:trace] == 'error' && hash[:message] =~ /Process aborted or coredumped:/ }
    end
  end

  def test_env_hash
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil }, processor.env_hash)

      processor.push_env_hash({ "RBENV_VERSION" => "2.5.0" }) do
        assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil, "RBENV_VERSION" => "2.5.0" },
                     processor.env_hash)
      end

      assert_equal({ "RUBYOPT" => nil, "GIT_SSH" => nil }, processor.env_hash)
    end
  end

  def test_directory_traversal_attack?
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      assert processor.directory_traversal_attack?("../../etc/passwd")
      assert processor.directory_traversal_attack?("config/../../../etc/passwd")
      refute processor.directory_traversal_attack?("foo")
      refute processor.directory_traversal_attack?("foo/bar")
    end
  end

  def test_analyzer_version
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      error = assert_raises(NotImplementedError) { processor.analyzer_version }
      assert_equal <<~MSG, error.message
        A typical implementation:

        def analyzer_version
          @analyzer_version ||= extract_version! "some_command"
        end
      MSG
    end
  end

  def test_extract_version!
    mktmpdir do |path|
      processor = Processor.new(guid: SecureRandom.uuid, working_dir: path, git_ssh_path: nil, trace_writer: trace_writer)

      # from stdout
      mock(processor).capture3!("foo", "--version") { ["Foo v10.20.1", ""] }
      assert_equal "10.20.1", processor.extract_version!("foo")

      # from stderr
      mock(processor).capture3!("foo", "bar", "version") { ["", "7.8.20 version\n"] }
      assert_equal "7.8.20", processor.extract_version!("foo", ["bar", "version"])

      # non semver
      mock(processor).capture3!("foo", "--version") { ["Foo 1.2", ""] }
      assert_equal "1.2", processor.extract_version!("foo")

      # change pattern
      mock(processor).capture3!("foo", "bar", "-v") { ["ver 1.2", ""] }
      assert_equal "1.2", processor.extract_version!("foo", ["bar", "-v"], pattern: /ver (\d+.\d+)\b/)

      # not found
      mock(processor).capture3!("foo", "-v") { ["no version", ""] }
      error = assert_raises { processor.extract_version!("foo", "-v") }
      assert_equal "Not found version from 'foo -v'", error.message
    end
  end
end
