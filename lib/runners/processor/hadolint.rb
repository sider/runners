module Runners
  class Processor::Hadolint < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        ignore: enum?(string, array(string)),
                        'trusted-registry': enum?(string, array(string)),
                        config: string?,
                      })
      }

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema(name: :hadolint, schema: Schema.runner_config)

    DEFAULT_TARGET = "**/Dockerfile{,.*}".freeze
    DEFAULT_TARGET_EXCLUDED = "*.{erb,txt}".freeze # Exclude templates

    def self.ci_config_section_name
      "hadolint"
    end

    def analyzer_name
      "hadolint"
    end

    def analyze(_changes)
      run_analyzer
    end

    private

    def analyzer_options
      [].tap do |opts|
        opts << "--format=json"
        Array(ci_section[:'trusted-registry']).each do |trusted|
          opts << "--trusted-registry=#{trusted}"
        end
        Array(ci_section[:ignore]).each do |ignore|
          opts << "--ignore=#{ignore}"
        end
        opts << "--config=#{ci_section[:config]}" if ci_section[:config]
      end
    end

    def analysis_target
      if ci_section[:target]
        Array(ci_section[:target])
      else
        current_dir.glob(DEFAULT_TARGET, File::FNM_EXTGLOB)
          .reject { |path| path.fnmatch?(DEFAULT_TARGET_EXCLUDED, File::FNM_EXTGLOB) }
          .map { |path| relative_path(path).to_path }
      end
    end

    def run_analyzer
      stdout, stderr, status = capture3 analyzer_bin, *analyzer_options, *analysis_target
      if status.exitstatus == 1 && stdout.strip == "Please provide a Dockerfile"
        add_warning "No Docker file provided"
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      if status.exitstatus == 1 && stderr.include?("openBinaryFile: does not exist (No such file or directory)")
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: "No Docker files found")
      end

      begin
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout).each { |v| result.add_issue(v) }
        end
      rescue JSON::ParserError
        Results::Failure.new(guid: guid, analyzer: analyzer, message: stderr)
      end
    end

    # Output format:
    #
    #     { line: number, code: rule, message: description, column: number, file: filepath, level: level }
    #
    # Example:
    #
    #     {"line":14,"code":"DL3003","message":"Use WORKDIR to switch to a directory","column":1,"file":"images/hadolint/Dockerfile","level":"warning"}
    #
    # @see https://github.com/hadolint/hadolint#rules
    # @param stdout [String]
    def parse_result(stdout)
      JSON.parse(stdout, symbolize_names: true).map do |file|
        path = relative_path(file[:file])

        line = file[:line]
        id = file[:code]

        Issue.new(
          path: path,
          location: Location.new(start_line: line),
          id: id,
          message: file[:message],
          object: {
            severity: file[:level],
          },
          schema: Schema.issue,
          links: link_to_wiki(id),
        )
      end
    end

    def link_to_wiki(id)
      if id.start_with? "DL"
        ["https://github.com/hadolint/hadolint/wiki/#{id}"]
      else
        ["https://github.com/koalaman/shellcheck/wiki/#{id}"]
      end
    end
  end
end
