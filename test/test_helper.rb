require_relative '../lib/runners'

require 'minitest/autorun'
require "unification_assertion"
require "securerandom"

module TestHelper
  include UnificationAssertion
  include Runners::Tmpdir

  def data(file)
    Pathname(__dir__).join("data", file)
  end

  def with_stubbed_env(new_env)
    backup = ENV.slice(*new_env.keys)
    ENV.update(new_env)
    yield
  ensure
    ENV.update(backup)
  end

  def new_source(**source)
    {
      head: "6ba85479fc406a64b7202f7bc3ea8da3ada93084",
      git_url: "https://github.com/sider/runners_test",
      **source,
    }
  end

  def base_commit
    "cd33ab59ef3d75e54e6d49c000bc8f141d94d356"
  end

  def with_workspace(ssh_key: nil, **source_params)
    source = new_source(**source_params)
    options = Runners::Options.new(JSON.dump(source: source, ssh_key: ssh_key), StringIO.new, StringIO.new)
    filter = Runners::SensitiveFilter.new(options: options)
    mktmpdir do |dir|
      yield Runners::Workspace.prepare(options: options, working_dir: dir, trace_writer: new_trace_writer(filter: filter))
    end
  end

  def with_workspace_open(**params)
    with_workspace(**params) do |workspace|
      workspace.open do
        yield workspace
      end
    end
  end

  def config(yaml = "")
    yaml ||= ""
    mktmpdir do |dir|
      file = dir / Runners::Config::FILE_NAME
      file.write(yaml)
      Runners::Config.new(path: file, raw_content: yaml)
    end
  end

  def sensitive_filter
    source = {
      head: "123abc",
      base: "456def",
      git_url: "https://github.com/foo/bar",
      git_url_userinfo: "user:secret",
      refspec: "+refs/pull/1234/head:refs/remotes/pull/1234/head",
    }
    options = Runners::Options.new(JSON.dump(source: source), StringIO.new, StringIO.new)
    Runners::SensitiveFilter.new(options: options)
  end

  def new_trace_writer(filter: sensitive_filter)
    Runners::TraceWriter.new(writer: [], filter: filter)
  end
end
