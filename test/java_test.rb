require 'test_helper'

class JavaTest < Minitest::Test
  include TestHelper

  def test_install_jvm_deps
    with_workspace do |workspace|
      processor = new_processor workspace, config_yaml: <<~YAML
        linter:
          checkstyle:
            jvm_deps:
              - [com.foo, bar, 1.2.3]
              - [org.foo, baz, 4.9]
      YAML

      dest = (processor.working_dir / "deps").tap(&:mkpath)
      processor.install_jvm_deps to: dest

      assert_equal <<~GRADLE, (dest / "build.gradle").read
        plugins {
          id 'java'
        }
        repositories {
          mavenCentral()
          jcenter()
          google()
        }
        dependencies {
          implementation 'com.foo:bar:1.2.3'
          implementation 'org.foo:baz:4.9'
        }
        task deps(type: Copy) {
          from configurations.compileClasspath
          into '.'
        }
      GRADLE

      assert_includes trace_messages, <<~MSG.strip
        Successfully installed 2 dependencies:
        * com.foo:bar:1.2.3
        * org.foo:baz:4.9
      MSG
      assert_equal 1, processor.warnings.size
      assert_match "The `linter.checkstyle.jvm_deps` option is deprecated. Please use the `linter.checkstyle.dependencies` option",
                   processor.warnings.to_a.first[:message]
    end
  end

  def test_install_jvm_deps_with_dependencies
    with_workspace do |workspace|
      processor = new_processor workspace, config_yaml: <<~YAML
        linter:
          checkstyle:
            dependencies:
              - com.foo:bar:1.2.3
              - { name: "org.foo:baz", version: "3.0" }
      YAML

      dest = (processor.working_dir / "deps").tap(&:mkpath)
      processor.install_jvm_deps to: dest

      assert_match <<~GRADLE, (dest / "build.gradle").read
        dependencies {
          implementation 'com.foo:bar:1.2.3'
          implementation 'org.foo:baz:3.0'
        }
      GRADLE
      assert_includes trace_messages, <<~MSG.strip
        Successfully installed 2 dependencies:
        * com.foo:bar:1.2.3
        * org.foo:baz:3.0
      MSG
      assert_empty processor.warnings
    end
  end

  def test_install_jvm_deps_without_config
    with_workspace do |workspace|
      processor = new_processor workspace, config_yaml: ""
      processor.install_jvm_deps
      refute_includes trace_messages, "Install dependencies..."
    end
  end

  def test_install_jvm_deps_without_value
    with_workspace do |workspace|
      processor = new_processor workspace, config_yaml: <<~YAML
        linter:
          checkstyle:
            jvm_deps:
      YAML
      processor.install_jvm_deps
      refute_includes trace_messages, "Install dependencies..."
    end
  end

  def test_install_jvm_deps_with_invalid_format
    with_workspace do |workspace|
      processor = new_processor workspace, config_yaml: <<~YAML
        linter:
          checkstyle:
            jvm_deps:
              - [a, b]
      YAML

      error = assert_raises Runners::Java::InvalidDependency do
        processor.install_jvm_deps
      end
      assert_equal <<~MSG, error.message
        An invalid dependency is found in your `sider.yml`: `["a", "b"]`
        Dependencies should be of the form: `[group, name, version]`
      MSG
    end
  end

  def test_invalid_config
    with_workspace do |workspace|
      error = assert_raises Runners::Config::InvalidConfiguration do
        new_processor workspace, config_yaml: <<~YAML
          linter:
            checkstyle:
              jvm_deps:
                - [a, b, false]
        YAML
      end
      assert_includes error.message, "`linter.checkstyle.jvm_deps[0][2]`"
    end
  end

  private

  TestProcessor = Class.new(Runners::Processor) do
    include Runners::Java
    def self.analyzer_id; :checkstyle; end
    def analyzer_name; "Checkstyle"; end
    def fetch_deps_via_gradle!
      # noop
    end
  end

  def new_processor(workspace, config_yaml:)
    TestProcessor.new(
      guid: "test-guid",
      working_dir: workspace.working_dir,
      config: config(config_yaml),
      shell: Runners::Shell.new(current_dir: workspace.working_dir, trace_writer: trace_writer),
      trace_writer: trace_writer,
    )
  end

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def trace_messages
    trace_writer.writer.map { _1[:message] }.compact
  end
end
