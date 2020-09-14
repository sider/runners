module Runners
  # This class expects AWS credentials set with environment variables or an instance profile.
  # So, before using this, make sure AWS credentials available.
  # Also, prepare the S3 bucket and allow this instance to upload an S3 object.
  class IO::AwsS3
    # @type const BUFFER_SIZE: Integer
    BUFFER_SIZE = 300

    # Only for test
    # @see https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ClientStubs.html
    def self.stub?
      false
    end

    attr_reader :uri, :bucket_name, :object_name, :tempfile, :written_items, :client

    def initialize(uri, endpoint: nil)
      @uri = uri

      parsed = parse_s3_uri(uri)
      @bucket_name = parsed.fetch(:bucket)
      @object_name = parsed.fetch(:object)

      @tempfile = Tempfile.new
      @written_items = 0

      @client = Aws::S3::Client.new({
        retry_limit: 5,
        retry_base_delay: 1.2,
        instance_profile_credentials_retries: 5,
        instance_profile_credentials_timeout: 3,
        endpoint: endpoint,
        force_path_style: endpoint ? true : false,
        stub_responses: self.class.stub?,
      }.compact)
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

    def parse_s3_uri(s3_uri)
      uri = URI.parse(s3_uri)
      bucket = uri.host&.then { |s| s.empty? ? nil : s }
      object = uri.path&.then { |s| s.empty? ? nil : s }
      if uri.scheme == "s3" && bucket && object
        { bucket: bucket, object: object.delete_prefix("/") }
      else
        raise ArgumentError, "The specified S3 URI is invalid: `#{s3_uri.inspect}`"
      end
    end

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
