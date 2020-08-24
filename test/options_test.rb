require_relative 'test_helper'

class OptionsTest < Minitest::Test
  include TestHelper

  def test_options_git_source
    source_params = {
      head: 'head_commit',
      base: 'base_commit',
      git_url: 'https://github.com/foo/bar',
      git_url_userinfo: 'user:secret',
      refspec: "+refs/pull/1234/head:refs/remotes/pull/1234/head",
    }
    with_runners_options_env(source: source_params) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of Runners::Options::GitSource, options.source
      assert_equal source_params, options.source.to_h
    end
  end

  def test_options_git_source_without_base
    source_params = {
      head: 'head_commit',
      git_url: 'https://github.com/foo/bar',
      git_url_userinfo: 'user:secret',
      refspec: "+refs/pull/1234/head:refs/remotes/pull/1234/head",
    }
    with_runners_options_env(source: source_params) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of Runners::Options::GitSource, options.source
      assert_equal source_params.merge(base: nil), options.source.to_h
    end
  end

  def test_options_git_source_without_userinfo
    source_params = {
      head: 'head_commit',
      base: 'base',
      git_url: 'https://github.com/foo/bar',
      refspec: "+refs/pull/1234/head:refs/remotes/pull/1234/head",
    }
    with_runners_options_env(source: source_params) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of Runners::Options::GitSource, options.source
      assert_equal source_params.merge(git_url_userinfo: nil), options.source.to_h
    end
  end

  def test_options_git_source_without_refspecs
    source_params = {
      head: 'head_commit',
      base: 'base',
      git_url: 'https://github.com/foo/bar',
      git_url_userinfo: 'user:secret',
    }
    with_runners_options_env(source: source_params) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of Runners::Options::GitSource, options.source
      assert_equal source_params.merge(refspec: nil), options.source.to_h
    end
  end

  def test_options_with_ssh_key
    with_runners_options_env(ssh_key: 'ssh', source: new_source) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'ssh', options.ssh_key
    end
  end

  def test_options_without_ssh_key
    with_runners_options_env(ssh_key: nil, source: new_source) do
      options = Runners::Options.new(stdout, stderr)
      assert_nil options.ssh_key
    end
  end

  def test_options_with_outputs
    with_runners_options_env(outputs: %w[stdout stderr], source: new_source) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout, stderr], options.io.ios
    end
  end

  def test_options_with_outputs_s3_url
    with_runners_options_env(outputs: %w[stdout s3://bucket/abc], source: new_source) do
      s3_mock = Object.new
      stub(s3_mock).write
      stub(s3_mock).flush
      stub(s3_mock).flush!
      mock(Runners::IO::AwsS3).new("s3://bucket/abc", endpoint: nil) { s3_mock }
      mock.proxy(Runners::IO).new(stdout, s3_mock)

      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout, s3_mock], options.io.ios
    end
  end

  def test_options_without_outputs
    with_runners_options_env(outputs: nil, source: new_source) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout], options.io.ios
    end
  end

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end
end
