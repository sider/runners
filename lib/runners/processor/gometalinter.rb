module Runners
  class Processor::Gometalinter < Processor
    include Go

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          import_path: string?,
          install_path: string?,
          options: object?(
            config: string?,
            exclude: string?,
            include: string?,
            skip: string?,
            'cyclo-over': numeric?,
            'min-confidence': numeric?,
            'dupl-threshold': numeric?,
            severity: string?,
            vendor: boolean?,
            tests: boolean?,
            errors: boolean?,
            'disable-all': boolean?,
            fast: boolean?,
            disable: enum?(string, array(string)),
            enable: enum?(string, array(string)),
          ),
        )
      }
    end

    register_config_schema(name: :gometalinter, schema: Schema.runner_config)

    def setup
      add_warning_for_deprecated_linter(alternative: analyzers.name(:golangci_lint),
                                        ref: "https://github.com/alecthomas/gometalinter/issues/590",
                                        deadline: Time.new(2020, 4, 30))

      with_import_path do |path|
        if path
          trace_writer.message "Copying source files to #{path}" do
            FileUtils.copy_entry(current_dir, path)
          end
        end
      end

      push_import_path_dir do
        trace_writer.message "Downloading dependencies..." do
          download_dependency
        end
      end

      yield
    end

    def analyze(changes)
      push_import_path_dir do
        # NOTE: Ignore status code because gometalinter exits with 1 when any issues exist.
        stdout, _, _ = capture3(
          analyzer_bin,
          *additional_options,
          '--enable-gc',
          '--json',
          './...',
          '--deadline=1200s'
        )
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          JSON.parse(stdout).each do |issue|
            loc = Location.new(
              start_line: issue['line'],
              start_column: nil,
              end_line: nil,
              end_column: nil
            )

            result.add_issue Issue.new(
              path: relative_path(issue['path'], from: current_dir),
              location: loc,
              id: Digest::SHA1.hexdigest(issue['message']),
              message: "[#{issue['linter']}] #{issue['message']}",
            )
          end
        end
      end
    end

    private

    def with_import_path
      return yield(nil) unless import_path
      return yield(nil) unless import_path.is_a? String

      path = Pathname(import_path)
      return yield(nil) if path.absolute?

      gopath_src = Pathname(ENV['GOPATH']) + "src"

      absolute_path = gopath_src.join(path).cleanpath
      return yield(nil) unless absolute_path.to_s.start_with?(gopath_src.to_s)

      absolute_path.mkpath

      yield absolute_path
    end

    def import_path
      return @import_path if defined? @import_path

      @import_path = config_linter[:import_path]
      return @import_path if @import_path

      @import_path = config_linter[:install_path].tap do |install_path|
        if install_path
          msg = '`install_path` option is deprecated. Use `import_path` instead.'
          add_warning(msg, file: config.path_name)
        end
      end
    end

    def push_import_path_dir
      with_import_path do |path|
        if path
          push_dir path do
            yield
          end
        else
          yield
        end
      end
    end

    def download_dependency
      _, _, status = capture3('test', '-f', 'glide.yaml')
      return unless status.success?
      # NOTE: Both `go get` and `glide install` try to install via HTTP(S).
      #       Making it fetch libraries via SSH, it lets users use "Private dependencies".
      if git_ssh_path
        capture3!(%Q!git config --global url."git@github.com:".insteadOf 'https://github.com/'!)
      end
      capture3!('glide', 'install')
      # NOTE: `go get` is required to let "gotype"read libraries via glide.
      capture3!('go', 'get', './...')
    end

    def additional_options
      options = config_linter[:options] || {}
      options[:config] ||= (Pathname(Dir.home) / 'gometalinter.json').realpath
      options.map do |k, v|
        next unless v
        case k
        when :exclude, :include, :skip, :'cyclo-over', :'min-confidence', :'dupl-threshold', :severity, :config
          "--#{k}=#{v}"
        when :vendor, :tests, :errors, :'disable-all', :fast
          next unless !!v
          "--#{k}"
        when :disable, :enable
          linter_tool_options(k, Array(v))
        else
          nil
        end
      end.flatten.compact
    end

    def linter_tool_options(key, tools)
      tools.map do |tool|
        case tool
        when :test, :testify
          # NOTE: Prevent testing
          next
        else
          "--#{key}=#{tool}"
        end
      end
    end
  end
end
