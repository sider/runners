module NodeHarness
  module Runners
    module Jshint
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!({
                            dir: string?,
                            config: string?,
                            # DO NOT ADD ANY OPTIONS in `options` option.
                            options: optional(object(
                                                config: string?
                                              ))
                          })
          }
        end

        def self.ci_config_section_name
          'jshint'
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            prepare_config(config)
            run_analyzer(config)
          end
        end

        private

        def analyzer
          NodeHarness::Analyzer.new(name: 'JSHint', version: analyzer_version)
        end

        def prepare_config(config)
          return if jshintrc_exist?(config)
          config_path = (Pathname(Dir.home) / 'sider_jshintrc').realpath
          ignore_path = (Pathname(Dir.home) / 'sider_jshintignore').realpath
          FileUtils.cp(config_path, current_dir / '.jshintrc')
          FileUtils.cp(ignore_path, current_dir / '.jshintignore')
        end

        def jshintrc_exist?(config)
          return true if config_path(config)
          return true if (current_dir + '.jshintrc').exist? || (current_dir + '.jshintignore').exist?
          return true if (current_dir + 'package.json').exist? && JSON.parse(File.read(current_dir + 'package.json'))['jshintConfig']
          return false
        end

        def config_path(config)
          config[:config] || config.dig(:options, :config)
        end

        def analyzer_version
          @analyzer_version ||=
            begin
              _, stderr = capture3! 'jshint', '--version'
              match = stderr.to_s.match(/(\d+\.\d+\.\d+)/)
              if match
                match.captures.first
              else
                raise "Not found version in #{stderr.inspect}"
              end
            end
        end

        def parse_result(stdout)
          doc = Nokogiri::XML(stdout)
          doc.errors.each do |error|
            trace_writer.message "Error: #{error.inspect}"
          end
          doc.xpath('/checkstyle/file').flat_map do |file|
            file.xpath('error').map do |error|
              loc = NodeHarness::Location.new(
                start_line: error['line'].to_i,
                start_column: nil,
                end_line: nil,
                end_column: nil
              )
              NodeHarness::Issues::Text.new(
                path: relative_path(file['name']),
                location: loc,
                id: error['source'] || Digest::SHA1.hexdigest(error['message']),
                message: error['message'].strip,
                links: []
              )
            end
          end
        end

        def run_analyzer(config)
          args = []
          args << "--config=#{config_path(config)}" if config_path(config)
          args << (config[:dir] || "./")
          stdout, stderr, status = capture3("jshint", "--reporter=checkstyle", *args)
          # If command is succeeded, status.exitstatus is 0 or 2(issues are found).
          return NodeHarness::Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer!) if status.exitstatus == 1
          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            break result if status.exitstatus == 0
            parse_result(stdout).each { |v| result.add_issue(v) }
          end
        end
      end
    end
  end
end
