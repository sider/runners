$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'runners'

require 'minitest/autorun'
require "unification_assertion"
require "pp"
require "rr"

module TestHelper
  include UnificationAssertion

  def mktmpdir
    Dir.mktmpdir do |dir|
      yield Pathname(dir)
    end
  end

  def data(file)
    Pathname(__dir__).join("data", file)
  end

  def incorrect_yarn_data(file)
    Pathname(__dir__).join("incorrect_yarn_data", file)
  end

  def with_stubbed_env(name, value)
    backup = ENV[name]
    ENV[name] = value
    yield
  ensure
    ENV[name] = backup
  end

  def with_runners_options_env(hash)
    with_stubbed_env('RUNNERS_OPTIONS', JSON.dump(hash)) do
      yield
    end
  end

  def with_workspace(ssh_key: nil, **source_params)
    source = {
      head: (Pathname(__dir__) + "data/foo.tgz").to_s,
      **source_params
    }.select { |_k, v| v }
    with_runners_options_env(source: source, ssh_key: ssh_key) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      Dir.mktmpdir do |dir|
        workspace = Runners::Workspace.prepare(options: options, working_dir: Pathname(dir), trace_writer: Runners::TraceWriter.new(writer: []))
        yield workspace
      end
    end
  end

  def config(yaml = nil)
    mktmpdir do |path|
      (path / 'sider.yml').write(yaml) if yaml
      Runners::Config.new(path)
    end
  end
end
