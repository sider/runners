require "test_helper"

class ResultsTest < Minitest::Test
  include TestHelper

  Results = Runners::Results
  Issue = Runners::Issue
  Changes = Runners::Changes
  Location = Runners::Location
  Analyzer = Runners::Analyzer
  GitBlameInfo = Runners::GitBlameInfo

  def test_success_result
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "RuboCop", version: "1.3.2pre"))
    result.add_issue Issue.new(
      path: Pathname("foo/bar/baz.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      message: "abc def",
      object: {
        args: [1,2,3]
      },
      schema: nil,
    ).tap { |v| v.instance_variable_set(:@git_blame_info, GitBlameInfo.new(commit: "c", original_line: 3, final_line: 5, line_hash: "abc")) }
    result.add_issue Issue.new(
      path: Pathname("foo/bar/baz.rb"),
      location: nil,
      id: "some_error_id",
      message: "abc def",
    )

    assert result.valid?

    assert Runners::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: 'success',
                       issue_count: 2,
                       issues: [
                         {
                           path: "foo/bar/baz.rb",
                           location: nil,
                           id: "some_error_id",
                           message: "abc def",
                           links: [],
                           object: nil,
                           git_blame_info: nil,
                         },
                         {
                           path: "foo/bar/baz.rb",
                           location: { start_line: 1 },
                           id: "some_error_id",
                           message: "abc def",
                           links: [],
                           object: { args: [1,2,3] },
                           git_blame_info: { commit: "c", original_line: 3, final_line: 5, line_hash: "abc" },
                         },
                       ],
                       analyzer: { name: "RuboCop", version: "1.3.2pre" }
                     })
  end

  def test_success_filter_issue
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "RuboCop", version: "1.3.2pre"))
    result.add_issue Issue.new(
      path: Pathname("foo/bar/baz.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      message: "abc def",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )
    result.add_issue Issue.new(
      path: Pathname("foo/bar/xxx.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      message: "abc def",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )

    changes = Changes.new(changed_paths: [Pathname("foo/bar/xxx.rb")], unchanged_paths: [Pathname("foo/bar/baz.rb")], patches: nil)
    result.filter_issues(changes)

    assert result.valid?

    assert Runners::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: 'success',
                       issue_count: 1,
                       issues: [
                         {
                           path: "foo/bar/xxx.rb",
                           location: { start_line: 1 },
                           id: "some_error_id",
                           message: "abc def",
                           links: [],
                           object: { args: [1,2,3] },
                           git_blame_info: nil,
                         }
                       ],
                       analyzer: { name: "RuboCop", version: "1.3.2pre" }
                     })

  end

  def test_success_filter_issue_with_patches
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Flake8", version: "3.7.9"))
    result.add_issue Issue.new(
      path: Pathname("a.py"),
      location: Location.new(start_line: 1),
      id: "F401",
      message: "'os' imported but unused",
    )
    result.add_issue Issue.new(
      path: Pathname("a.py"),
      location: Location.new(start_line: 2),
      id: "E302",
      message: "expected 2 blank lines, found 0",
    )
    result.add_issue Issue.new(
      path: Pathname("b.py"),
      location: Location.new(start_line: 1),
      id: "F401",
      message: "'os' imported but unused",
    )
    result.add_issue Issue.new(
      path: Pathname("b.py"),
      location: Location.new(start_line: 5),
      id: "E302",
      message: "expected 2 blank lines, found 0",
    )
    result.add_issue Issue.new(
      path: Pathname("a.py"),
      location: nil,
      id: "ZZZ",
      message: "ERROR!",
    )


    changes = Changes.new(changed_paths: [Pathname("a.py")], unchanged_paths: [Pathname("b.py")], patches: GitDiffParser.parse(<<~DIFF))
      diff --git a/a.py b/a.py
      index 23038dd..19bbab7 100644
      --- a/a.py
      +++ b/a.py
      @@ -1,3 +1,3 @@
       import os
      -def f():
      +def f1():
           pass
    DIFF
    result.filter_issues(changes)

    assert result.valid?

    assert Runners::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: 'success',
                       issue_count: 2,
                       issues: [
                         {
                           path: "a.py",
                           location: { start_line: 2  },
                           id: "E302",
                           message: "expected 2 blank lines, found 0",
                           links: [],
                           object: nil,
                           git_blame_info: nil,
                         },
                         {
                           path: "a.py",
                           location: nil,
                           id: "ZZZ",
                           message: "ERROR!",
                           links: [],
                           object: nil,
                           git_blame_info: nil,
                         },
                       ],
                       analyzer: { name: "Flake8", version: "3.7.9" }
                     })

  end

  def test_success_initializing_issues
    analyzer = Analyzer.new(name: "RuboCop", version: "1.0.0")
    issues = [
      Issue.new(path: Pathname("foo.rb"), location: nil, id: "aaa", message: "bbb"),
      Issue.new(path: Pathname("foo.rb"), location: nil, id: "xxx", message: "yyy"),
    ]
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: analyzer, issues: issues)
    assert_equal issues, result.issues
  end

  def test_success_add_multiple_issues
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "RuboCop", version: "1.0.0"))
    issue1 = Issue.new(path: Pathname("foo.rb"), location: nil, id: "aaa", message: "bbb")
    issue2 = Issue.new(path: Pathname("foo.rb"), location: nil, id: "xxx", message: "yyy")
    result.add_issue(issue1, issue2)
    assert_equal [issue1, issue2], result.issues
  end

  def test_add_git_blame_info
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "RuboCop", version: "1.3.2pre"))
    result.add_issue Issue.new(
      path: Pathname("foo/bar/baz.rb"),
      location: Location.new(start_line: 1),
      id: "some_error_id",
      message: "abc def",
      object: {
        args: [1, 2, 3]
      },
      schema: nil,
    )

    with_workspace do |workspace|
      workspace.stub :range_git_blame_info, [GitBlameInfo.new(commit: "c1", original_line: 1, final_line: 1, line_hash: "h")] do
        result.add_git_blame_info(workspace)
      end
    end

    assert result.valid?

    assert Runners::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: 'success',
                       issue_count: 1,
                       issues: [
                         {
                           path: "foo/bar/baz.rb",
                           location: { start_line: 1  },
                           id: "some_error_id",
                           message: "abc def",
                           links: [],
                           object: {
                             args: [1, 2, 3],
                           },
                           git_blame_info: { commit: "c1", original_line: 1, final_line: 1, line_hash: "h" },
                         },
                       ],
                       analyzer: { name: "RuboCop", version: "1.3.2pre" }
                     })
  end

  def test_null_location_result
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Goodcheck", version: "1.6.0"))
    result.add_issue Issue.new(
      path: Pathname("foo/bar/baz.rb"),
      location: nil,
      id: "some_error_id",
      message: "abc def",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )

    assert result.valid?

    assert Runners::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: 'success',
                       issue_count: 1,
                       issues: [
                         {
                           path: "foo/bar/baz.rb",
                           location: nil,
                           id: "some_error_id",
                           message: "abc def",
                           links: [],
                           object: { args: [1,2,3] },
                           git_blame_info: nil,
                         }
                       ],
                       analyzer: { name: "Goodcheck", version: "1.6.0" }
                     })
  end

  def test_failure_result
    result = Results::Failure.new(guid: SecureRandom.uuid, message: "Something wrong...")

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: "failure",
                       message: "Something wrong...",
                       analyzer: nil
                     })
  end

  def test_failure_result_with_analyzer
    result = Results::Failure.new(guid: SecureRandom.uuid, message: "Something wrong...", analyzer: Analyzer.new(name: "Foo", version: "bar"))

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: "failure",
                       message: "Something wrong...",
                       analyzer: { name: "Foo", version: "bar" }
                     })
  end

  def test_error_result
    result = Results::Error.new(guid: SecureRandom.uuid, exception: RuntimeError.new("some error!"),
                                analyzer: Analyzer.new(name: "Foo", version: "1.2.3"))

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601(3),
                       type: "error",
                       class: "RuntimeError",
                       backtrace: nil,
                       inspect: "#<RuntimeError: some error!>",
                       analyzer: { name: "Foo", version: "1.2.3" },
                     })
  end
end
