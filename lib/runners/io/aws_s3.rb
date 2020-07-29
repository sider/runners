# AwsS3IO expects AWS credentials set with environment variables or an instance profile.
# So, before using this, make sure AWS credentials available.
# Also, prepare the S3 bucket and allow this instance to upload an S3 object.
module Runners
  class IO::AwsS3
    # @type const BUFFER_SIZE: Integer
    BUFFER_SIZE = 300

    def self.parse_s3_uri!(s3_uri)
      uri = URI.parse(s3_uri)
      bucket = uri.host&.then { |s| s.empty? ? nil : s }
      object = uri.path&.then { |s| s.empty? ? nil : s }
      if uri.scheme == "s3" && bucket && object
        [bucket, object.delete_prefix("/")]
      else
        raise "The specified S3 URI is not valid. You specified with '#{s3_uri}'"
      end
    end

    attr_reader :uri, :bucket_name, :object_name, :tempfile, :written_items, :client

    def initialize(uri)
      @uri = uri
      @bucket_name, @object_name = self.class.parse_s3_uri!(uri)
      @tempfile = Tempfile.new
      @written_items = 0

      args = {
        retry_limit: 5,
        retry_base_delay: 1.2,
        instance_profile_credentials_retries: 5,
        instance_profile_credentials_timeout: 3,
      }
      if ENV["S3_ENDPOINT"]
        args[:endpoint] = ENV["S3_ENDPOINT"]
        args[:force_path_style] = true
      end
      @client = Aws::S3::Client.new(**args)
    end

    def write(*args)
      @written_items += 1
      tempfile.write(*args)
    end

    def flush
      tempfile.flush
      flush_to_s3! if should_flush?
    end

    def should_flush?
      written_items > BUFFER_SIZE
    end

    def flush!
      flush_to_s3!
    end

    private

    def flush_to_s3!
      tempfile.rewind
      client.put_object(
        bucket: bucket_name,
        key: object_name,
        body: tempfile.read, # A stream object is slower than a string object, so the read string is passed here.
      )
      @written_items = 0
      tempfile.seek 0, ::IO::SEEK_END
    end
  end
end
