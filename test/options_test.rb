require_relative 'test_helper'

class OptionsTest < Minitest::Test
  include TestHelper

  def setup
    stub(Runners::IO::AwsS3).stub? { true }
  end

  def test_source
    with_runners_options_env(source: source_params) do
      source = Runners::Options.new(stdout, stderr).source
      assert_equal "e07dc104", source.head
      assert_equal "a7c6b27c", source.base
      assert_equal "https://github.com/foo/bar", source.git_url
      assert_equal "user:secret", source.git_url_userinfo
      assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
    end
  end

  def test_source_without_base
    with_runners_options_env(source: source_params.tap { _1.delete(:base) }) do
      source = Runners::Options.new(stdout, stderr).source
      assert_equal "e07dc104", source.head
      assert_nil source.base
      assert_equal "https://github.com/foo/bar", source.git_url
      assert_equal "user:secret", source.git_url_userinfo
      assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
    end
  end

  def test_source_without_userinfo
    with_runners_options_env(source: source_params.tap { _1.delete(:git_url_userinfo) }) do
      source = Runners::Options.new(stdout, stderr).source
      assert_equal "e07dc104", source.head
      assert_equal "a7c6b27c", source.base
      assert_equal "https://github.com/foo/bar", source.git_url
      assert_nil source.git_url_userinfo
      assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
    end
  end

  def test_options_git_source_without_refspec
    with_runners_options_env(source: source_params.tap { _1.delete(:refspec) }) do
      source = Runners::Options.new(stdout, stderr).source
      assert_equal "e07dc104", source.head
      assert_equal "a7c6b27c", source.base
      assert_equal "https://github.com/foo/bar", source.git_url
      assert_equal "user:secret", source.git_url_userinfo
      assert_empty source.refspec
    end
  end

  def test_ssh_key
    with_runners_options_env(ssh_key: 'ssh', source: source_params) do
      assert_equal 'ssh', Runners::Options.new(stdout, stderr).ssh_key
    end
  end

  def test_ssh_key_nil
    with_runners_options_env(ssh_key: nil, source: source_params) do
      assert_nil Runners::Options.new(stdout, stderr).ssh_key
    end
  end

  def test_io
    with_runners_options_env(outputs: %w[stdout stderr], source: source_params) do
      io = Runners::Options.new(stdout, stderr).io
      assert_equal [stdout, stderr], io.ios
    end
  end

  def test_io_with_s3
    with_runners_options_env(outputs: %w[stdout s3://bucket/abc], source: new_source) do
      io = Runners::Options.new(stdout, stderr).io
      assert_equal 2, io.ios.size
      assert_equal stdout, io.ios[0]
      assert_instance_of Runners::IO::AwsS3, io.ios[1]
      assert_equal "s3://bucket/abc", io.ios[1].uri
    end
  end

  def test_io_nil
    with_runners_options_env(outputs: nil, source: new_source) do
      io = Runners::Options.new(stdout, stderr).io
      assert_equal [stdout], io.ios
    end
  end

  def test_invalid_outputs
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
end
