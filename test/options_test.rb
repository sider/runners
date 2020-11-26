require 'test_helper'

class OptionsTest < Minitest::Test
  include TestHelper

  def run
    Runners::IO::AwsS3.stub(:stub?, true) { super }
  end

  def test_source
    json = options_json(source: source_params)
    source = Runners::Options.new(json, stdout, stderr).source
    assert_equal "e07dc104", source.head
    assert_equal "a7c6b27c", source.base
    assert_equal "https://github.com/foo/bar", source.git_url
    assert_equal "user:secret", source.git_url_userinfo
    assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
  end

  def test_source_without_base
    json = options_json(source: source_params.tap { _1.delete(:base) })
    source = Runners::Options.new(json, stdout, stderr).source
    assert_equal "e07dc104", source.head
    assert_nil source.base
    assert_equal "https://github.com/foo/bar", source.git_url
    assert_equal "user:secret", source.git_url_userinfo
    assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
  end

  def test_source_without_userinfo
    json = options_json(source: source_params.tap { _1.delete(:git_url_userinfo) })
    source = Runners::Options.new(json, stdout, stderr).source
    assert_equal "e07dc104", source.head
    assert_equal "a7c6b27c", source.base
    assert_equal "https://github.com/foo/bar", source.git_url
    assert_nil source.git_url_userinfo
    assert_equal ["+refs/pull/1234/head:refs/remotes/pull/1234/head"], source.refspec
  end

  def test_options_git_source_without_refspec
    json = options_json(source: source_params.tap { _1.delete(:refspec) })
    source = Runners::Options.new(json, stdout, stderr).source
    assert_equal "e07dc104", source.head
    assert_equal "a7c6b27c", source.base
    assert_equal "https://github.com/foo/bar", source.git_url
    assert_equal "user:secret", source.git_url_userinfo
    assert_empty source.refspec
  end

  def test_ssh_key
    json = options_json(ssh_key: 'ssh', source: source_params)
    assert_equal 'ssh', Runners::Options.new(json, stdout, stderr).ssh_key
  end

  def test_ssh_key_nil
    json = options_json(ssh_key: nil, source: source_params)
    assert_nil Runners::Options.new(json, stdout, stderr).ssh_key
  end

  def test_io
    json = options_json(outputs: %w[stdout stderr], source: source_params)
    io = Runners::Options.new(json, stdout, stderr).io
    assert_equal [stdout, stderr], io.ios
  end

  def test_io_with_s3
    json = options_json(outputs: %w[stdout s3://bucket/abc], source: new_source)
    io = Runners::Options.new(json, stdout, stderr).io
    assert_equal 2, io.ios.size
    assert_equal stdout, io.ios[0]
    assert_instance_of Runners::IO::AwsS3, io.ios[1]
    assert_equal "s3://bucket/abc", io.ios[1].uri
  end

  def test_io_nil
    json = options_json(outputs: nil, source: new_source)
    io = Runners::Options.new(json, stdout, stderr).io
    assert_equal [stdout], io.ios
  end

  def test_invalid_outputs
    json = options_json(outputs: ["foo"], source: new_source)
    error = assert_raises(ArgumentError) { Runners::Options.new(json, stdout, stderr) }
    assert_equal 'Invalid output option: `"foo"`', error.message
  end

  def test_new_issue_schema
    assert_nil Runners::Options.new(options_json(source: source_params), stdout, stderr).new_issue_schema
    assert_equal true, Runners::Options.new(options_json(source: source_params, new_issue_schema: true), stdout, stderr).new_issue_schema
    assert_equal false, Runners::Options.new(options_json(source: source_params, new_issue_schema: false), stdout, stderr).new_issue_schema
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

  def options_json(options)
    JSON.dump(options)
  end
end
