module Runners
  class Options
    class GitSource
      attr_reader :head, :base, :git_url, :git_url_userinfo, :refspec

      def initialize(params)
        @head = params.fetch(:head)
        @base = params.fetch(:base)
        @git_url = params.fetch(:git_url)
        @git_url_userinfo = params.fetch(:git_url_userinfo)
        @refspec = Array(params.fetch(:refspec))
      end
    end
    private_constant :GitSource

    attr_reader :stdout, :stderr, :source, :ssh_key, :io

    def initialize(json, stdout, stderr)
      @stdout = stdout
      @stderr = stderr

      options = parse_options(json)
      outputs = options[:outputs] || []
      @source = GitSource.new(options.fetch(:source))
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
                  Runners::IO::AwsS3.new(output, endpoint: options.dig(:s3, :endpoint))
                else
                  raise ArgumentError, "Invalid output option: `#{output.inspect}`"
                end
              end
              Runners::IO.new(*ios)
            end
    end

    private

    def parse_options(json)
      Schema::Options.payload.coerce(JSON.parse(json, symbolize_names: true))
    end
  end
end
