module Runners
  class Processor::SecretScan < Processor
    SCHEMA = _ = StrongJSON.new do
      # @type self: SchemaClass
      let :rule, object(
        justifications: array(string),
      )
    end

    def analyzer_bin
      "goodcheck"
    end

    def setup
      urls = Array(options&.secret_scan_urls)
      raise "Rule URLs required" if urls.empty?

      rule_file.write YAML.dump({ "import" => urls, "exclude_binary" => true })

      yield
    end

    def analyze(changes)
      delete_unchanged_files changes

      stdout, _stderr = capture3!(
        analyzer_bin, "check", "--config", rule_file, "--format", "json",
        is_success: ->(status) { [0, 2].include?(status.exitstatus) },
      )

      issues = JSON.parse(stdout, symbolize_names: true).map do |hash|
        loc = hash.fetch(:location)

        Issue.new(
          id: hash.fetch(:rule_id),
          message: hash.fetch(:message),
          path: relative_path(hash.fetch(:path)),
          location: Location.new(
            start_line: loc.fetch(:start_line),
            start_column: loc.fetch(:start_column),
            end_line: loc.fetch(:end_line),
            end_column: loc.fetch(:end_column),
          ),
          object: {
            justifications: hash.fetch(:justifications),
          },
          schema: SCHEMA.rule,
        )
      end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end

    private

    def rule_file
      @rule_file ||= Pathname(Dir.home).join("goodcheck.yml")
    end
  end
end
