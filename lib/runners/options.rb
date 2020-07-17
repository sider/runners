module Runners
  class Options
    GitSource = Struct.new(:head, :base, :git_http_url, :owner, :repo, :git_http_userinfo, :pull_number, keyword_init: true)

    # @dynamic stdout, stderr, source, ssh_key, io
    attr_reader :stdout, :stderr, :source, :ssh_key, :io

    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr

      options = parse_options
      outputs = options[:outputs] || []
      @source = GitSource.new(**options[:source])
      @ssh_key = options[:ssh_key]
      @io = if outputs.empty?
              Runners::IO.new(stdout)
            else
              ios = outputs.map do |output|
                case output
                when 'stdout'
                  stdout
                when 'stderr'
                  stderr
                when /^s3:/
                  Runners::IO::AwsS3.new(output)
                else
                  raise "Invalid output option. You included '#{output}'"
                end
              end
              Runners::IO.new(*ios)
            end
    end

    private

    def parse_options
      ENV['RUNNERS_OPTIONS'].yield_self do |val|
        Schema::Options.payload.coerce(JSON.parse(val, symbolize_names: true))
      end
    end
  end
end
