require_relative 'test_helper'

class OptionsTest < Minitest::Test
  include TestHelper

  def setup
    stub(Runners::IO::AwsS3).stub? { true }
  end

  def test_options_git_source
    with_runners_options_env(source: source_params) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal expected_output, options.source.to_h
    end
  end

  def test_options_git_source_without_base
    with_runners_options_env(source: source_params.tap { _1.delete(:base) }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal expected_output.merge(base: nil), options.source.to_h
    end
  end

  def test_options_git_source_without_userinfo
    with_runners_options_env(source: source_params.tap { _1.delete(:git_url_userinfo) }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal expected_output.merge(git_url_userinfo: nil), options.source.to_h
    end
  end

  def test_options_git_source_without_refspec
    with_runners_options_env(source: source_params.tap { _1.delete(:refspec) }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal expected_output.merge(refspec: []), options.source.to_h
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
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal 2, options.io.ios.size
      assert_equal stdout, options.io.ios[0]
      assert_instance_of Runners::IO::AwsS3, options.io.ios[1]
      assert_equal "s3://bucket/abc", options.io.ios[1].uri
    end
  end

  def test_options_without_outputs
    with_runners_options_env(outputs: nil, source: new_source) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout], options.io.ios
    end
  end

  def test_options_with_invalid_outputs
    with_runners_options_env(outputs: ["foo"], source: new_source) do
      error = assert_raises(ArgumentError) { Runners::Options.new(stdout, stderr) }
      assert_equal 'Invalid output option: `"foo"`', error.message
    end
  end

  private

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end

  def source_params
    {
      head: 'e07dc104',
      base: 'a7c6b27c',
      git_url: 'https://github.com/foo/bar',
      git_url_userinfo: 'user:secret',
      refspec: '+refs/pull/1234/head:refs/remotes/pull/1234/head',
    }
  end

  def expected_output
    {
      head: 'e07dc104',
      base: 'a7c6b27c',
      git_url: 'https://github.com/foo/bar',
      git_url_userinfo: 'user:secret',
      refspec: ['+refs/pull/1234/head:refs/remotes/pull/1234/head'],
    }
  end
end
