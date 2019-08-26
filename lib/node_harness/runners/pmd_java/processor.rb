module NodeHarness
  module Runners
    module PmdJava
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!({
                            dir: string?,
                            rulesets: enum?(string, array(string)),
                            encoding: string?,
                            min_priority: numeric?
                          })
          }
        end

        def self.ci_config_section_name
          'pmd_java'
        end

        def pmd_path
          Pathname(ENV["PMD_PATH"] || "/usr/local/pmd")
        end

        def pmd(dir:, rulesets:, encoding:, min_priority:)
          args = []
          args.unshift("-dir", dir)
          args.unshift("-rulesets", rulesets.join(","))
          args.unshift("-minimumpriority", min_priority.to_s) if min_priority
          args.unshift("-encoding", encoding) if encoding

          capture3((pmd_path + "bin/run.sh").to_s,
                   "pmd",
                   "-language", "java",
                   "-format", "xml",
                   *args)
        end

        def analyzer_version
          ENV['PMD_VERSION'] || '0.0.0'
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'pmd_java', version: analyzer_version)
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            trace_writer.message("PMD version: #{analyzer_version}")
            delete_unchanged_files changes, only: [".java"]

            check_runner_config(config) do |dir, rulesets, encoding, min_priority|
              run_analyzer(dir, rulesets, encoding, min_priority)
            end
          end
        end

        def run_analyzer(dir, rulesets, encoding, min_priority)
          stdout, stderr, status = pmd(dir: dir, rulesets: rulesets, encoding: encoding, min_priority: min_priority)

          if status.success? || status.exitstatus == 4
            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
              construct_result(result, stdout, stderr)
            end
          else
            NodeHarness::Results::Failure.new(guid: guid, analyzer: analyzer!, message: <<~MESSAGE)
              stdout:
              #{stdout}

              stderr:
              #{stderr}
            MESSAGE
          end
        end

        def construct_result(result, stdout, stderr)
          # https://github.com/pmd/pmd.github.io/blob/8b0c31ff8e18215ed213b7df400af27b9137ee67/report_2_0_0.xsd

          document = REXML::Document.new(stdout)

          document.root.each_element do |element|
            case element.name
            when "file"
              path = relative_path(element["name"])

              element.each_element do |child|
                if child.name == "violation"
                  start_line = child["beginline"].to_i
                  start_column = child["begincolumn"].to_i
                  end_line = child["endline"].to_i
                  end_column = child["endcolumn"].to_i
                  links = array(child["externalInfoUrl"])

                  message = child.get_text.value.strip
                  id = child["ruleset"] + "-" + child["rule"] + "-" + Digest::SHA1.hexdigest(message)

                  issue = NodeHarness::Issues::Text.new(path: path,
                                                        location: NodeHarness::Location.new(start_line: start_line,
                                                                                            start_column: start_column,
                                                                                            end_line: end_line,
                                                                                            end_column: end_column),
                                                        id: id,
                                                        message: message,
                                                        links: links)

                  result.add_issue issue
                end
              end

            when "error"
              add_warning element["msg"], file: relative_path(element["filename"]).to_s

            when "configerror"
              add_warning "#{element["rule"]}: #{element["msg"]}"

            end
          end

          stderr.each_line do |line|
            case line
            when /WARNING: This analysis could be faster, please consider using Incremental Analysis/
              # We cannot support "incremental analysis" for now. So, ignore it.
            when /WARNING: (.+)$/
              add_warning $1
            end
          end
        end

        def check_runner_config(config)
          dir = check_directory(config)
          trace_writer.message("Checking directory: #{dir}")

          rulesets = rulesets(config)
          trace_writer.message("Rulesets: #{rulesets.join(", ")}")

          encoding = encoding(config)
          trace_writer.message("Source encoding: #{encoding}") if encoding

          min_priority = min_priority(config)
          trace_writer.message("Min priority: #{min_priority}") if min_priority

          yield dir, rulesets, encoding, min_priority
        end

        def rulesets(config)
          default_rulesets = [
            "category/java/bestpractices.xml",
            # "category/java/codestyle.xml",
            # "category/java/design.xml",
            # "category/java/documentation.xml",
            "category/java/errorprone.xml",
            "category/java/multithreading.xml",
            "category/java/performance.xml",
          ]
          array(config[:rulesets] || default_rulesets)
        end

        def check_directory(config)
          config[:dir] || "."
        end

        def encoding(config)
          config[:encoding]
        end

        def min_priority(config)
          config[:min_priority]
        end

        def array(value)
          case value
          when Hash
            [value]
          else
            Array(value)
          end
        end
      end
    end
  end
end
