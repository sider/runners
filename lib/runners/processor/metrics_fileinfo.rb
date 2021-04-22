module Runners
  class Processor::MetricsFileInfo < Processor
    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :issue, object(
        lines_of_code: integer?,
        last_committed_at: string,
        number_of_commits: integer,
        occurrence: integer,
        additions: integer,
        deletions: integer
      )
    end

    # Basically, the code churn is the number of times or the sum of added/deleted lines a file has changed within a specified period of time.
    # Like other products, we adopt the last 90 days before the latest commit date. However, if a project is not so active and has only
    # a few commits in a month, the churn values fluctuate on the scatter plot (churn v.s quality metrics) due to ambiguity of the small number of commits.
    # A relative value of churn becomes stable as comparing the values across a certain number of files. So we also take 100 commits into account
    # when there are not enough commits in 90 days.
    CHURN_PERIOD_IN_DAYS = 90
    CHURN_COMMIT_COUNT = 100

    def default_analyzer_version
      Runners::VERSION
    end

    # This analyser use git metadata (.git/).
    def use_git_metadata_dir?
      true
    end

    def analyze(changes)
      # Generate pre-computed cache for Git metadata access (https://git-scm.com/docs/git-commit-graph)
      # This improves the performance of access to Git metadata for a large repository.
      # You can see the efficacy here: https://github.com/sider/runners/issues/2028#issuecomment-776534408
      trace_writer.message "Generating pre-computed Git metadata cache..." do
        git("commit-graph", "write", "--reachable", "--changed-paths")
      end

      target_files = Pathname.glob("**/*", File::FNM_DOTMATCH).filter do |path|
        path.file? && !path.fnmatch?(".git/**", File::FNM_DOTMATCH)
      end

      analyze_last_committed_at(target_files)
      analyze_lines_of_code(target_files)
      number_of_commits = analyze_code_churn

      Results::Success.new(
        guid: guid,
        analyzer: analyzer,
        issues: target_files.map { |path| generate_issue(path, number_of_commits) }
      )
    end

    private

    def generate_issue(path, number_of_commits)
      loc = lines_of_code[path]
      commit = last_committed_at.fetch(path)
      churn = code_churn.fetch(path, { occurrence: 0, additions: 0, deletions: 0 })

      Issue.new(
        path: path,
        location: nil,
        id: "metrics_fileinfo",
        message: "#{path}: loc = #{loc || "(no info)"}, last commit datetime = #{commit}",
        object: {
          lines_of_code: loc,
          last_committed_at: commit,
          number_of_commits: number_of_commits,
          occurrence: churn[:occurrence],
          additions: churn[:additions],
          deletions: churn[:deletions]
        },
        schema: SCHEMA.issue
      )
    end

    def lines_of_code
      @lines_of_code ||= {}
    end

    def analyze_lines_of_code(targets)
      trace_writer.message "Analyzing line of code..." do
        text_files = targets.select { |f| text_file?(f) }
        text_files.each_slice(1000) do |files|
          stdout, _ = capture3!("wc", "-l", *files, trace_stdout: false, trace_command_line: false)
          lines = stdout.lines(chomp: true)

          # `wc` command outputs total count when we pass multiple targets. remove it if exist
          lines.pop if lines.last&.match?(/^\d+ total$/)

          lines.each do |line|
            fields = line.split(" ")
            loc = (fields[0] or raise)
            fname = (fields[1] or raise)
            lines_of_code[Pathname(fname)] = Integer(loc)
          end
        end
      end
    end

    def last_committed_at
      @last_committed_at ||= {}
    end

    def analyze_last_committed_at(targets)
      trace_writer.message "Analyzing last commit time..." do
        Parallel.each(targets, in_threads: 8) do |target|
          stdout, _ = git("log", "-1", "--format=format:%aI", "--", target)
          last_committed_at[target] = stdout
        end
      end
    end

    def code_churn
      @code_churn ||= {}
    end

    def analyze_code_churn
      trace_writer.message "Analyzing code churn..." do
        commits_by_num = commit_summary_within("--max-count", CHURN_COMMIT_COUNT.to_s)
        days_ago = (commits_by_num[:latest_time] - CHURN_PERIOD_IN_DAYS * 60 * 60 * 24).iso8601
        commits_by_time = commit_summary_within("--since", days_ago)
        outlive_commits = commits_by_num[:count] > commits_by_time[:count] ? commits_by_num : commits_by_time

        stdout, _ = git("log", "--reverse", "--format=format:#", "--numstat", "#{outlive_commits[:oldest_sha]}..HEAD")
        lines = stdout.lines(chomp: true)
        number_of_commits = lines.count("#")

        lines.each do |line|
          adds, dels, fname = line.split("\t")
          if adds && dels && fname
            fname = Pathname(fname)
            code_churn[fname] = calc_churn(code_churn[fname], adds, dels)
          end
        end

        number_of_commits
      end
    end

    def calc_churn(churn, adds, dels)
      churn ||= { occurrence: 0, additions: 0, deletions: 0 }
      churn[:occurrence] += 1
      churn[:additions] += adds == "-" ? 0 : Integer(adds)
      churn[:deletions] += dels == "-" ? 0 : Integer(dels)
      churn
    end

    def commit_summary_within(*args_range)
      stdout, _ = git("log", "--format=format:%H|%cI", *args_range)
      lines = stdout.lines(chomp: true)
      latest_line = lines.first or raise "Required log line: #{lines.size} lines"
      oldest_line = lines.last or raise "Required log line: #{lines.size} lines"
      latest_sha, latest_time = latest_line.split("|")
      oldest_sha, oldest_time = oldest_line.split("|")
      raise "Required sha in the latest line: #{latest_line}" unless latest_sha
      raise "Required time in the latest line: #{latest_line}" unless latest_time
      raise "Required sha in the oldest line: #{oldest_line}" unless oldest_sha
      raise "Required time in the oldest line: #{oldest_line}" unless oldest_time
      {
        count: lines.size,
        latest_sha: latest_sha,
        latest_time: Time.parse(latest_time),
        oldest_sha: oldest_sha,
        oldest_time: Time.parse(oldest_time),
      }
    end

    # There may not be a perfect method to discriminate file type.
    # We determined to use 'git ls-file' command with '--eol' option based on an evaluation.
    #  the target methods: mimemagic library, file(1) command, git ls-files --eol.
    #
    # 1. mimemagic library (https://rubygems.org/gems/mimemagic/)
    # Pros:
    #   * A Gem library. We can install easily.
    #   * It seems to be well-maintained now.
    # Cons:
    #   * This library cannot distinguish between a plain text file and a binary file.
    #
    # 2. file(1) command (https://linux.die.net/man/1/file)
    # Pros:
    #   * This is a well-known method to inspect file type.
    # Cons:
    #   * We have to install an additional package on devon_rex_base.
    #   * File type classification for plain text is too detailed. File type string varies based on the target file encoding.
    #     * e.g.  ASCII text, ISO-8859 text, ASCII text with escape sequence, UTF-8 Unicode text, Non-ISO extended-ASCII test, and so on.
    #
    # 3. git ls-files --eol (See: https://git-scm.com/docs/git-ls-files#Documentation/git-ls-files.txt---eol)
    #  Pros:
    #    * We don't need any additional packages.
    #    * It output whether the target file is text or not. (This is the information we need)
    #    * The output is reliable to some extent because Git is a very well maintained and used OSS product.
    #  Cons:
    #    * (no issue found)
    #
    # We've tested some ambiguous cases in binary_files, multi_language, and unknown_extension smoke test cases.
    # We can determine file type correctly in cases as below.
    #  * A plain text file having various extensions (.txt, .rb, .md, etc..)
    #  * A binary file having various extensions (.png, .data, etc...)
    #  * A binary file, but having .txt extension. (e.g. no_text.txt)
    #  * A text files not encoded in UTF-8 but EUC-JP, ISO-2022-JP, Shift JIS.
    #  * A text file having a non-well-known extension. (e.g. foo.my_original_extension )
    def text_files
      @text_files ||= Set[].tap do |result|
        stdout, _ = git("ls-files", "--eol", "--error-unmatch")
        stdout.each_line(chomp: true) do |line|
          fields = line.split(" ")
          type = (fields[1] or raise)
          file = (fields[3] or raise)
          if type != "w/-text"
            result << Pathname(file)
          end
        end
      end
    end

    def text_file?(target)
      text_files.include?(target)
    end

    def git(*args)
      capture3!("git", *args, trace_stdout: false, trace_command_line: false)
    end
  end
end
