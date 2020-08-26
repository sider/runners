require "test_helper"

class IssueTest < Minitest::Test
  include TestHelper

  Issue = Runners::Issue
  Location = Runners::Location
  GitBlameInfo = Runners::GitBlameInfo

  def test_structured_issue
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: ["no such method??"],
      schema: s.object,
    ).tap { |v| v.instance_variable_set(:@git_blame_info, GitBlameInfo.new(commit: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1", original_line: 137, final_line: 137, line_hash: "c57a7c8a63aa22b9aa40625f019fe097c3a23ab8")) }

    assert_equal({
      path: "app/models/person.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "foo.bar",
      message: "test message",
      links: [],
      object: ["no such method??"],
      git_blame_info: { commit: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1", original_line: 137, final_line: 137, line_hash: "c57a7c8a63aa22b9aa40625f019fe097c3a23ab8" },
    }, issue.as_json)
  end

  def test_structured_issue_without_location
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issue.new(
      path: Pathname("app/models/person.rb"),
      location: nil,
      id: "foo.bar",
      message: "test message",
      object: ["no such method??"],
      schema: s.object,
    )

    assert_equal({
      path: "app/models/person.rb",
      location: nil,
      id: "foo.bar",
      message: "test message",
      links: [],
      object: ["no such method??"],
      git_blame_info: nil,
    }, issue.as_json)
  end

  def test_structured_issue_with_invalid_object
    s = StrongJSON.new do
      let :object, array(string)
    end

    error = assert_raises StrongJSON::Type::TypeError do
      Issue.new(
        path: Pathname("app/models/person.rb"),
        location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
        id: "foo.bar",
        message: "test message",
        object: [3],
        schema: s.object,
      )
    end
    assert_equal "TypeError at $[0]: expected=string, value=3", error.message
  end

  def test_structured_issue_without_object_schema
    Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: [3],
      schema: nil,
    )
  end

  def test_plaintext_issue
    issue = Issue.new(
      path: Pathname("foo/bar"),
      location: Location.new(start_line: 1, start_column: nil, end_line: 2, end_column: nil),
      id: "missing.comment",
      message: "Comment is missing??",
      links: ["https://github.com/foo.bar"],
    )

    assert_equal({
      path: "foo/bar",
      location: { start_line: 1, end_line: 2 },
      id: "missing.comment",
      message: "Comment is missing??",
      links: ["https://github.com/foo.bar"],
      object: nil,
      git_blame_info: nil,
    }, issue.as_json)
  end

  def test_add_git_blame_info
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: ["no such method??"],
      schema: s.object,
    )
    with_workspace do |workspace|
      return_value = [
        GitBlameInfo.new(
          commit: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1",
          original_line: 137,
          final_line: 137,
          line_hash: "c57a7c8a63aa22b9aa40625f019fe097c3a23ab8",
        ),
      ]
      workspace.stub :range_git_blame_info, return_value do
        issue.add_git_blame_info(workspace)
      end
    end

    assert_equal({
                   path: "app/models/person.rb",
                   location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
                   id: "foo.bar",
                   message: "test message",
                   links: [],
                   object: ["no such method??"],
                   git_blame_info: { commit: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1", original_line: 137, final_line: 137, line_hash: "c57a7c8a63aa22b9aa40625f019fe097c3a23ab8" },
                 }, issue.as_json)
  end

  def test_missing_id?
    args = { message: "Foo", path: Pathname("foo.rb"), location: nil }
    assert Issue.new(id: nil, **args).missing_id?
    assert Issue.new(id: "", **args).missing_id?
    refute Issue.new(id: "a", **args).missing_id?
  end
end
