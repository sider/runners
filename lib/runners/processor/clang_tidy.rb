module Runners
  class Processor::ClangTidy < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          apt: enum?(string, array(string)),
          'include-path': enum?(string, array(string))
        })
      }

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :clang_tidy, schema: Schema.runner_config)

    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L532-L535
    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L568-L584
    GLOB_SOURCES = "*.{c,cpp,c++,cc,cp,cxx}".freeze
    GLOB_HEADERS = "**/*.{h,h++,hh,hpp,hxx,inc,inl,ipp,tcc,tpp}".freeze

    def setup
      deploy_packages
      yield
    end

    def analyzer_bin
      "clang-tidy"
    end

    def analyze(changes)
      issues = []

      changes
        .changed_paths
        .select { |path| path.fnmatch?(GLOB_SOURCES, File::FNM_EXTGLOB | File::FNM_CASEFOLD) }
        .map{ |path| relative_path(working_dir / path, from: current_dir) }
        .reject { |path| path.to_s.start_with?("../") } # reject files outside the current_dir
        .each do |path|
          stdout, = capture3!(analyzer_bin, path.to_s, "--", *option_include_path,
            is_success: ->(status) { [0, 1].include?(status.exitstatus) })
          construct_result(stdout) { |issue| issues << issue }
        end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        result.add_issue(*issues)
      end
    end

    private

    def deploy_packages
      # select development packages and report others as warning for security concerns
      packages = Array(config_linter[:apt])
        .select do |pkg|
          if pkg.match?(/-dev(=.+)?$/)
            true
          else
            add_warning "Installing the package `#{pkg}` is blocked.", file: config.path_name
            false
          end
        end

      unless packages.empty?
        capture3!("sudo", "apt-get", "install", "-qq", "-y", "--no-install-recommends", *packages)
      end
    end

    def construct_result(stdout)
      # issue format
      # <path>:<line>:<column>: <severity>: <message> [<id>]
      pattern = /^(.+):(\d+):(\d+): ([^:]+): (.+) \[([^\[]+)\]$/
      stdout.scan(pattern) do |path, line, column, severity, message, id|
        yield Issue.new(
          path: relative_path(path),
          location: Location.new(start_line: line, start_column: column),
          id: id,
          message: message,
          object: {
            severity: severity,
          },
          schema: Schema.issue,
        )
      end
    end

    def option_include_path
      includes = Array(config_linter[:'include-path'] || find_paths_containing_headers)
      includes.map { |v| "-I" + v }
    end

    def find_paths_containing_headers
      Pathname.glob(GLOB_HEADERS, File::FNM_EXTGLOB | File::FNM_CASEFOLD)
        .filter_map { |path| path.parent.to_path if path.file? }
        .uniq
    end
  end
end
