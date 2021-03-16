require 'test_helper'

class NodejsTest < Minitest::Test
  include TestHelper

  NpmInstallFailed = Runners::Nodejs::NpmInstallFailed
  YarnInstallFailed = Runners::Nodejs::YarnInstallFailed

  INSTALL_OPTION_NONE = Runners::Nodejs::INSTALL_OPTION_NONE
  INSTALL_OPTION_ALL = Runners::Nodejs::INSTALL_OPTION_ALL
  INSTALL_OPTION_PRODUCTION = Runners::Nodejs::INSTALL_OPTION_PRODUCTION
  INSTALL_OPTION_DEVELOPMENT = Runners::Nodejs::INSTALL_OPTION_DEVELOPMENT

  private

  def processor_class
    @processor_class ||= Class.new(Runners::Processor) do
      include Runners::Nodejs

      def analyzer_bin
        "eslint"
      end

      def analyzer_name
        "ESLint"
      end
    end
  end

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def actual_commands
    trace_writer.writer.map { |entry| entry[:command_line] }.compact
  end

  def actual_errors
    trace_writer.writer.filter_map { |e| e.fetch(:message) if e[:trace] == :error }
  end

  def actual_messages
    trace_writer.writer.filter_map { |e| e.fetch(:message) if e[:trace] == :message }
  end

  def assert_warnings(expected)
    assert_equal expected, processor.warnings
  end

  def processor
    @processor
  end

  def new_processor(workspace:)
    @processor = processor_class.new(
      guid: SecureRandom.uuid,
      working_dir: workspace.working_dir,
      config: config,
      shell: Runners::Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
      trace_writer: trace_writer,
    )
  end

  def stub_const(name, value)
    begin
      saved_value = Runners::Nodejs.const_get(name)
      silence_warnings { Runners::Nodejs.const_set(name, value) }
      yield
    ensure
      silence_warnings { Runners::Nodejs.const_set(name, saved_value) }
    end
  end

  def copy(src, dest)
    FileUtils.copy_file src, dest
  end

  public

  def test_nodejs_analyzer_local_command
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      assert_equal "node_modules/.bin/eslint", processor.nodejs_analyzer_local_command
    end
  end

  def test_nodejs_analyzer_bin
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      assert_equal "eslint", processor.nodejs_analyzer_bin

      (workspace.working_dir / "node_modules/.bin").mkpath
      (workspace.working_dir / "node_modules/.bin/eslint").write("")
      assert_equal "node_modules/.bin/eslint", processor.nodejs_analyzer_bin
    end
  end

  def test_analyzer_version_with_global
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.stub :nodejs_analyzer_locally_installed?, false do
        processor.stub :nodejs_analyzer_global_version, "1.0.0" do
          assert_equal "1.0.0", processor.analyzer_version
        end
      end
    end
  end

  def test_analyzer_version_with_local
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.stub :nodejs_analyzer_locally_installed?, true do
        processor.stub :nodejs_analyzer_local_version, "2.0.0" do
          assert_equal "2.0.0", processor.analyzer_version
        end
      end
    end
  end

  def test_install_nodejs_deps
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ devDependencies: { "eslint" => "5.0.0", "is-string" => "1.0.5" } }.to_json)
      constraints = {
        "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0"),
        "is-string" => Gem::Requirement.new(">= 1.0.0", "< 2.0.0"),
      }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      refute_path_exists processor.package_lock_json_path
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_equal [
        "Installing npm packages...",
        "`node_modules/.bin/eslint` was successfully installed with the version `5.0.0`.",
      ], actual_messages
      assert_empty actual_errors
      assert_equal "5.0.0", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_without_package_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      assert_warnings [{ message: <<~MSG.strip, file: "package.json" }]
        The `npm_install` option is specified in your `sider.yml`, but a `package.json` file is not found in the repository.
        In this case, any npm packages are not installed.
      MSG
      assert_empty actual_commands
      assert_empty actual_messages
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_option_nil_and_without_package_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: nil)
      end

      assert_empty processor.warnings
      assert_empty actual_commands
      assert_empty actual_messages
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_option_nil_and_with_package_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "is-string" => "1.0.5" } }.to_json)
      constraints = { "is-string" => Gem::Requirement.new(">= 1.0.0", "< 2.0.0") }

      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: nil)
      end

      assert_path_exists processor.package_json_path
      refute_path_exists processor.package_lock_json_path
      assert_empty processor.warnings
      refute_empty actual_commands
      refute_empty actual_messages
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_option_none_and_without_package_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_NONE)
      end

      refute_path_exists processor.package_json_path
      assert_empty processor.warnings
      assert_empty actual_commands
      assert_empty actual_messages
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_option_none_and_with_package_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "eslint" => "6.0.0" } }.to_json)
      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_NONE)
      end

      assert_path_exists processor.package_json_path
      assert_empty processor.warnings
      assert_empty actual_commands
      assert_empty actual_messages
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_using_yarn
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "eslint" => "6.0.1" } }.to_json)
      copy data("yarn.lock"), processor.yarn_lock_path

      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      refute_path_exists processor.package_lock_json_path
      assert_empty processor.warnings
      assert_empty actual_errors
      refute_empty actual_commands
      assert_equal "6.0.1", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_with_duplicate_lockfiles
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "eslint" => "6.0.1" } }.to_json)
      copy data("yarn.lock"), processor.yarn_lock_path
      copy data("package-lock.json"), processor.package_lock_json_path

      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0", "< 7.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      assert_warnings [{ message: <<~MSG.strip, file: "yarn.lock" }]
        Two lock files `package-lock.json` and `yarn.lock` are found. Sider uses `yarn.lock` in this case, but please consider deleting either file for more accurate analysis.
      MSG
      refute_empty actual_commands
      refute_empty actual_messages
      assert_empty actual_errors
      assert_equal "6.0.1", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_without_deps
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({}.to_json)
      constraints = { "eslint" => Gem::Requirement.new(">= 5.0.0") }

      processor.stub :nodejs_analyzer_global_version, "5.15.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
      assert_includes actual_messages, "`eslint` is required but not installed (not in your `package.json`)."
      assert_includes actual_messages, "All constraints are not satisfied. The default version `5.15.0` will be used instead."
      assert_equal "5.15.0", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_with_missing_deps
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "classcat" => "5.0.3" }}.to_json)
      constraints = { "is-string" => Gem::Requirement.new(">= 1.0.0") }

      processor.stub :nodejs_analyzer_global_version, "1.0.1" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
      assert_includes actual_messages, "`is-string` is required but not installed (not in your `package.json`)."
      assert_includes actual_messages, "All constraints are not satisfied. The default version `1.0.1` will be used instead."
      assert_equal "1.0.1", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_with_unsatisfied_deps
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { "classcat" => "5.0.3", "is-string" => "1.0.5" }}.to_json)
      constraints = {
        "classcat" => Gem::Requirement.new(">= 6.0.0"),
        "is-string" => Gem::Requirement.new(">= 1.0.0"),
      }

      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: constraints, install_option: INSTALL_OPTION_ALL)
      end

      assert_warnings [{ message: <<~MSG.strip, file: "package.json" }]
        Installed `classcat@5.0.3` does not satisfy our constraint `>=6.0.0`. Please update it as possible.
      MSG
      refute_empty actual_commands
      assert_empty actual_errors
      assert_includes actual_messages, "All constraints are not satisfied. The default version `1.0.0` will be used instead."
      assert_equal "1.0.0", processor.analyzer_version
    end
  end

  def test_install_nodejs_deps_with_hook_script
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ scripts: { postinstall: "exit 1" }, dependencies: { classcat: "5.0.3" } }.to_json)
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_ALL)
      end

      assert_path_exists processor.working_dir / "node_modules" / "classcat"
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_engine_strict
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ engines: { node: "8" }, dependencies: { classcat: "5.0.3" } }.to_json)
      processor.working_dir.join(".npmrc").write("engine-strict = true")
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_ALL)
      end

      assert_path_exists processor.working_dir / "node_modules" / "classcat"
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_production
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { classcat: "5.0.3" }, devDependencies: { "is-string": "1.0.5" } }.to_json)
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_PRODUCTION)
      end

      assert_path_exists processor.working_dir / "node_modules" / "classcat"
      refute_path_exists processor.working_dir / "node_modules" / "is-string"
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_development
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { classcat: "5.0.3" }, devDependencies: { "is-string": "1.0.5" } }.to_json)
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_DEVELOPMENT)
      end

      refute_path_exists processor.working_dir / "node_modules" / "classcat"
      assert_path_exists processor.working_dir / "node_modules" / "is-string"
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_package_lock_json
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { typescript: "^3.5.0" } }.to_json)
      copy data("package-lock.json"), processor.package_lock_json_path
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_ALL)
      end

      assert_path_exists processor.working_dir / "node_modules" / "typescript"
      assert_equal "3.5.3", JSON.parse((processor.working_dir / "node_modules" / "typescript" / "package.json").read)["version"]
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_package_lock_json_production
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { typescript: "^3.5.0" } }.to_json)
      copy data("package-lock.json"), processor.package_lock_json_path
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_PRODUCTION)
      end

      assert_path_exists processor.working_dir / "node_modules" / "typescript"
      assert_equal "3.5.3", JSON.parse((processor.working_dir / "node_modules" / "typescript" / "package.json").read)["version"]
      assert_empty processor.warnings
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_package_lock_json_development
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ devDependencies: { typescript: "^3.5.0" } }.to_json)
      copy data("package-lock.dev.json"), processor.package_lock_json_path
      processor.stub :nodejs_analyzer_global_version, "1.0.0" do
        processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_DEVELOPMENT)
      end

      assert_path_exists processor.working_dir / "node_modules" / "typescript"
      assert_match %r{^3\.\d+\.\d+$}, JSON.parse((processor.working_dir / "node_modules" / "typescript" / "package.json").read)["version"]
      assert_warnings [{ message: <<~MSG.strip, file: "package.json" }]
        The `npm ci --only=development` command does not install anything, so `npm install --only=development` will be used instead.
        If you want to use `npm ci`, please change your install option from `development` to `true`.
        For details about the npm behavior, see https://npm.community/t/npm-ci-only-dev-does-not-install-anything/3068
      MSG
      refute_empty actual_commands
      assert_empty actual_errors
    end
  end

  def test_install_nodejs_deps_with_non_existent_deps
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      processor.package_json_path.write({ dependencies: { foo: "github:sider/foo" } }.to_json)

      error = assert_raises NpmInstallFailed do
        processor.stub :nodejs_analyzer_global_version, "1.0.0" do
          processor.install_nodejs_deps(constraints: {}, install_option: INSTALL_OPTION_ALL)
        end
      end

      expected_error_message = <<~MSG.strip
        `npm install` failed. Please check the log for details.
        If you want to explicitly disable the installation, please set `npm_install: false` on your `sider.yml`.
      MSG
      assert_equal [expected_error_message], actual_errors
      assert_equal expected_error_message, error.message
      refute_path_exists processor.working_dir / "node_modules"
    end
  end

  def test_yarn_install
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      node_modules = processor.node_modules_path
      eslint = node_modules / "eslint"

      yarnrc = (workspace.working_dir / ".yarnrc").tap { _1.write 'yarn-path "foo"' }
      yarnrc_yml = (workspace.working_dir / ".yarnrc.yml").tap { _1.write 'yarnPath: "foo"' }
      yarnrc_yaml = (workspace.working_dir / ".yarnrc.yaml").tap { _1.write 'yarnPath: "foo"' }

      processor.package_json_path.write({ dependencies: { "eslint" => "6.0.1" } }.to_json)
      copy data("yarn.lock"), processor.yarn_lock_path

      processor.send(:yarn_install, INSTALL_OPTION_NONE)
      refute_path_exists eslint
      assert_path_exists yarnrc
      assert_path_exists yarnrc_yml
      assert_path_exists yarnrc_yaml

      processor.send(:yarn_install, INSTALL_OPTION_ALL)
      assert_path_exists eslint
      assert_path_exists yarnrc
      assert_path_exists yarnrc_yml
      assert_path_exists yarnrc_yaml

      eslint.rmtree
      yarnrc_yml.rmtree
      yarnrc_yaml.rmtree
      processor.send(:yarn_install, INSTALL_OPTION_PRODUCTION)
      assert_path_exists eslint
      assert_path_exists yarnrc
      refute_path_exists yarnrc_yml
      refute_path_exists yarnrc_yaml

      node_modules.rmtree
      processor.send(:yarn_install, INSTALL_OPTION_DEVELOPMENT)
      assert_path_exists eslint

      expected_commands = [
        %w[yarn install --ignore-engines --ignore-scripts --no-progress --non-interactive --frozen-lockfile],
        %w[yarn install --ignore-engines --ignore-scripts --no-progress --non-interactive --frozen-lockfile --production],
        %w[yarn install --ignore-engines --ignore-scripts --no-progress --non-interactive --frozen-lockfile],
      ]
      assert_equal expected_commands, actual_commands

      expected_warning = <<~MSG.strip
        Yarn does not have a same feature as `npm install --only=development`, so the option `development` will be ignored.
        See https://github.com/yarnpkg/yarn/issues/3254 for details.
      MSG
      actual_warnings = trace_writer.writer.select { |e| e[:trace] == :warning }.map { |e| e[:message] }
      assert_equal [expected_warning], actual_warnings
      assert_equal [{ message: expected_warning, file: "yarn.lock" }], processor.warnings
    end
  end

  def test_yarn_install_failed
    with_workspace do |workspace|
      new_processor(workspace: workspace)

      # 'yarn install' fails because of incorrect package settings between yarn.lock and package.json
      copy incorrect_yarn_data("yarn.lock"), processor.yarn_lock_path
      copy incorrect_yarn_data("package.json"), processor.package_json_path

      error = assert_raises YarnInstallFailed do
        processor.send(:yarn_install, INSTALL_OPTION_ALL)
      end
      expected_error_message = <<~MSG.strip
        `yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`.
      MSG
      assert_equal expected_error_message, error.message
      assert_equal [expected_error_message], actual_errors
    end
  end
end
