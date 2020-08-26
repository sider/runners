require "test_helper"

class AwsS3Test < Minitest::Test
  include TestHelper

  def run
    Runners::IO::AwsS3.stub(:stub?, true) { super }
  end

  def test_initialize
    subject = Runners::IO::AwsS3.new('s3://a_bucket/an_object')

    assert_equal 's3://a_bucket/an_object', subject.uri
    assert_equal 'a_bucket', subject.bucket_name
    assert_equal 'an_object', subject.object_name
    assert_instance_of Tempfile, subject.tempfile
    assert_equal 0, subject.written_items

    config = subject.client.config
    assert_equal 5, config.retry_limit
    assert_equal 1.2, config.retry_base_delay
    assert_equal 5, config.instance_profile_credentials_retries
    assert_equal 3, config.instance_profile_credentials_timeout
    assert_equal URI('https://s3.us-stubbed-1.amazonaws.com'), config.endpoint
    assert_equal false, config.force_path_style
  end

  def test_initialize_with_endpoint
    subject = Runners::IO::AwsS3.new('s3://a_bucket/an_object', endpoint: 'https://s3.example.com')

    config = subject.client.config
    assert_equal URI('https://s3.example.com'), config.endpoint
    assert_equal true, config.force_path_style
  end

  def test_initialize_with_complex_uri
    subject = Runners::IO::AwsS3.new('s3://a_bucket.com/path/to/an_object')

    assert_equal 'a_bucket.com', subject.bucket_name
    assert_equal 'path/to/an_object', subject.object_name
  end

  def test_initialize_with_invalid_uri
    error = assert_raises ArgumentError do
      Runners::IO::AwsS3.new('https://a_bucket/an_object')
    end
    assert_equal 'The specified S3 URI is invalid: `"https://a_bucket/an_object"`', error.message
  end

  def test_write_flush
    io = Runners::IO::AwsS3.new('s3://a_bucket/an_object')
    io.write('abc')
    io.write('!!!')
    io.flush
    assert_equal 'abc!!!', io.tempfile.tap(&:rewind).read
  end

  def test_should_flush?
    io = Runners::IO::AwsS3.new('s3://a_bucket/an_object')

    2.times { io.write("a") }
    assert_equal 2, io.written_items
    refute io.should_flush?

    300.times { io.write("b") }
    assert 302, io.written_items
    assert io.should_flush?
  end

  def test_flush!
    io = Runners::IO::AwsS3.new('s3://a_bucket/an_object')

    io.client.stub :put_object, nil do
      io.write("a")
      assert_equal 1, io.written_items

      io.flush!
      assert_equal 0, io.written_items
    end
  end
end
