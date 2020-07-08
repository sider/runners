module Runners
  class Processor::ClangTidy < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          apt: enum?(string, array(string)),
          'compilation-options': object?(
            '-I': enum?(string, array(string))
          )
        })
      }

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :clang_tidy, schema: Schema.runner_config)

    VALID_EXTENSIONS = [".c", ".cc", ".cpp", ".c++", ".cp", ".cxx"].freeze
    GLOB_HEADERS = "**/*.{h,hpp,h++}".freeze

    def analyze(changes)
      deploy_packages
      run_analyzer(changes)
    end

    private

    def deploy_packages
      # select "lib*" and report others as warning for security concerns
      packages = Array(config_linter[:apt])
        .select do |pkg|
          if pkg.start_with?("lib")
            true
          else
            add_warning "Installing the package `#{pkg}` is blocked."
            false
          end
        end

      unless packages.empty?
        capture3!("sudo", "apt-get", "install", "-y", "--no-install-recommends", *packages)
      end
    end

    def analyzer_bin
      "clang-tidy-10"
    end

    def run_analyzer(changes)
      issues = []

      changes
        .changed_paths
        .select { |path| VALID_EXTENSIONS.include?(path.extname.downcase) }
        .map{ |path| relative_path(working_dir / path, from: current_dir) }
        .each do |path|
          stdout, = capture3!(analyzer_bin, path.to_s, "--", *option_includes,
            is_success: ->(status) { [0, 1].include?(status.exitstatus) })
          ret = construct_result(stdout)
          issues.push(*ret)
        end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        result.add_issue(*issues)
      end
    end

    def construct_result(stdout)
      issues = []

      stdout.each_line do |line|
        # issue format
        # <path>:<line>:<column>: <severity>: <message> [<id>]
        match = line.strip.match(/^(?<path>.+):(?<line>\d+):(?<column>\d+): (?<severity>[^:]+): (?<message>.+) \[(?<id>[^\[]+)\]$/)
        if match
          issues << Issue.new(
            path: relative_path(match[:path]),
            location: Location.new(start_line: match[:line], start_column: match[:column]),
            id: match[:id],
            message: match[:message],
            object: {
              severity: match[:severity],
            },
            schema: Schema.issue,
          )
        end
      end

      issues
    end

    def option_includes
      includes = config_linter.dig(:'compilation-options', :'-I') || find_paths_containing_headers
      includes.map { |v| "-I" + v }
    end

    def find_paths_containing_headers
      working_dir.glob(GLOB_HEADERS, File::FNM_EXTGLOB | File::FNM_CASEFOLD)
        .select { |path| path.file? }
        .map { |path| relative_path(path.parent, from: current_dir).to_path }
        .uniq
    end
  end
end
