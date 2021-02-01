module Runners
  module Results
    class Base
      attr_reader :guid
      attr_reader :timestamp

      def initialize(guid:)
        @guid = guid
        @timestamp = Time.now
      end

      def as_json
        {
          guid: guid,
          timestamp: timestamp.utc.iso8601(3)
        }
      end

      def valid?
        !!(guid && timestamp)
      end
    end

    # Result to indicate that processing finished successfully
    # Client programs may return this result.
    class Success < Base
      attr_reader :issues
      attr_reader :analyzer

      def initialize(guid:, analyzer:, issues: [])
        super(guid: guid)
        @issues = issues
        @analyzer = analyzer
      end

      def as_json
        super.tap do |json|
          json[:type] = 'success'
          json[:issue_count] = issues.size
          json[:issues] = issues.map(&:as_json).sort_by! do |issue|
            [
              issue[:id] || "",
              issue[:path] || "",
              issue.dig(:location, :start_line) || 0,
              issue.dig(:location, :start_column) || 0,
              issue.dig(:location, :end_line) || 0,
              issue.dig(:location, :end_column) || 0,
              issue[:message] || "",
            ]
          end
          json[:analyzer] = analyzer.as_json
        end
      end

      def valid?
        super && !!(analyzer&.valid?)
      end

      def add_issue(*issue)
        issues.push(*issue)
      end

      def filter_issues(changes)
        issues.select! do |issue|
          changes.include?(issue)
        end
      end

      def add_git_blame_info(workspace)
        issues.each do |issue|
          issue.add_git_blame_info(workspace)
        end
      end

      def each_missing_id_warning
        issues.each do |issue|
          next unless issue.missing_id?

          path = issue.path.to_path
          line = issue&.location&.start_line || "-"
          column = issue&.location&.start_column || "-"
          message = issue.message

          yield "Missing issue ID - #{path}:#{line}:#{column}: #{message}"
        end
      end
    end

    # Result to indicate that processing failed by some error.
    # Client programs may return this result.
    class Failure < Base
      DEFAULT_MESSAGE = "The analysis failed due to an unexpected error. See the analysis log for details.".freeze

      attr_reader :message
      attr_reader :analyzer

      def initialize(guid:, message: DEFAULT_MESSAGE, analyzer: nil)
        super(guid: guid)
        @message = message
        @analyzer = analyzer
      end

      def as_json
        super.tap do |json|
          json[:type] = 'failure'
          json[:message] = message
          json[:analyzer] = analyzer&.as_json
        end
      end

      def valid?
        super && !!message && ((a = analyzer) ? a.valid? : true)
      end
    end

    # Result to indicate that processor raises an exception.
    # Client programs should not return this result.
    class Error < Base
      attr_reader :exception, :analyzer

      def initialize(guid:, exception:, analyzer:)
        super(guid: guid)
        @exception = exception
        @analyzer = analyzer
      end

      def as_json
        super.tap do |json|
          json[:type] = 'error'
          json[:class] = exception.class.name
          json[:backtrace] = exception.backtrace
          json[:inspect] = exception.inspect
          json[:analyzer] = analyzer&.as_json
        end
      end

      def valid?
        super && exception.is_a?(Exception)
      end
    end
  end
end
