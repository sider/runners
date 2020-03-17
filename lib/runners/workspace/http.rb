module Runners
  class Workspace::HTTP < Workspace
    private

    def prepare_base_source(dest)
      base = archive_source.base
      if base
        provision(URI.parse(base), dest, archive_source.base_key)
      else
        raise ArgumentError, "base must not be nil"
      end
    end

    def prepare_head_source(dest)
      provision(URI.parse(archive_source.head), dest, archive_source.head_key)
    end

    # @param uri [URI]
    # @param dest [Pathname]
    # @param key [String, nil]
    def provision(uri, dest, key)
      download_with_retry(uri) do |file|
        decrypt(file, key) do |archive_path|
          extract(archive_path, dest)
        end
      end
    end

    # NOTE: Some exceptions are handled by `Net::HTTP` class.
    #
    # @see https://github.com/ruby/ruby/blob/v2_6_5/lib/net/http.rb#L1520-L1536
    def download_with_retry(uri, &block)
      trace_writer.message "Downloading source code..." do
        Retryable.retryable(
          on: [
            DownloadError,
            Net::OpenTimeout,
          ],
          tries: 5,
          sleep: method(:retryable_sleep),
          log_method: -> (retries, _exn) { trace_writer.message "Retrying download... (attempt: #{retries})" },
        ) do
          file = ::Tempfile.new
          download uri, dest: file, max_retries: 5, max_redirects: 10
          file.flush
          block.call Pathname(file.path)
        ensure
          file.close!
        end
      end
    end

    def download(uri, dest:, max_retries:, max_redirects:)
      raise ArgumentError, "Too many HTTP redirects: #{uri}" if max_redirects == 0

      http_options = {
        use_ssl: uri.scheme == "https",

        # @see https://ruby-doc.org/stdlib-2.6.5/libdoc/net/http/rdoc/Net/HTTP.html#method-i-max_retries-3D
        max_retries: max_retries,
      }

      # @see https://ruby-doc.org/stdlib-2.6.5/libdoc/net/http/rdoc/Net/HTTP.html#method-c-start
      Net::HTTP.start(uri.hostname, uri.port, http_options) do |http|
        http.request_get(uri) do |response|
          case response
          when Net::HTTPSuccess
            response.read_body(dest)
          when Net::HTTPRedirection
            # @see https://ruby-doc.org/stdlib-2.6.5/libdoc/net/http/rdoc/Net/HTTP.html#class-Net::HTTP-label-Following+Redirection
            download(
              URI(response["Location"]),
              dest: dest,
              max_retries: max_retries,
              max_redirects: max_redirects - 1,
            )
          else
            raise DownloadError, "Download failed: #{response.code} #{response.message}"
          end
        end
      end
    end

    def retryable_sleep(n)
      n + 1
    end
  end
end
