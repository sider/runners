module Runners
  class Processor::Golint < Processor
    include Go

    def self.ci_config_section_name
      # Section name in sideci.yml, Generally it is the name of analyzer tool.
      "golint"
    end

    def analyzer_bin
      "gometalinter"
    end

    def analyzer_name
      "golint"
    end

    def analyze(changes)
      # NOTE: go_vet cannot output with JSON format, so we use Gometalinter.
      stdout, _, _ = capture3(
        analyzer_bin,
        '--disable-all',
        '--enable=golint',
        '--enable-gc',
        '--json',
        './...',
        '--deadline=1200s'
      )
      add_warning_for_deprecated_linter(deadline: Time.new(2_020, 3, 31), alternative: "GolangCi-Lint")
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout).each do |issue|
          loc = Location.new(
            start_line: issue['line'],
            start_column: nil,
            end_line: nil,
            end_column: nil
          )

          result.add_issue Issue.new(
            path: relative_path(issue['path']),
            location: loc,
            id: Digest::SHA1.hexdigest(issue['message']),
            message: issue['message'],
          )
        end
      end
    end
  end
end
