require "test_helper"

class GitBlameInfoTest < Minitest::Test
  include TestHelper

  GitBlameInfo = Runners::GitBlameInfo

  def porcelain_output
    <<-OUTPUT
cb1af575f65f7cc49668b891fb34a5df692d3a0e 13 7 2
author Yutaka Kamei
author-mail <yutaka@sider.review>
author-time 1568862236
author-tz +0900
committer Yutaka Kamei
committer-mail <yutaka@sider.review>
committer-time 1568862236
committer-tz +0900
summary Refactor Processor to use `#delegate`
previous 42d055236db30ce557b4ec4a3cf43a8684014ed4 lib/runners/processor.rb
filename lib/runners/processor.rb
	    delegate :push_dir, :current_dir, :capture3, :capture3!, :capture3_trace, :capture3_with_retry!, to: :shell
cb1af575f65f7cc49668b891fb34a5df692d3a0e 14 8
	    delegate :env_hash, :push_env_hash, to: :shell
    OUTPUT
  end

  def test_parse
    assert_equal(
      [
        GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 13, final_line: 7, line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d"),
        GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 14, final_line: 8, line_hash: "df41b0ec11ed05be0baf51c536dae5670aa7aa3b"),
      ], GitBlameInfo.parse(porcelain_output))
  end

  def test_parse_for_none_utf_8
    string_with_invalid_encoding = <<~DATA
      144cae9deb69339061292e9db8541701197c640d 1 1 1
      author Yutaka Kamei
      author-mail <yutaka@sider.review>
      author-time 1583907807
      author-tz +0900
      committer Yutaka Kamei
      committer-mail <yutaka@sider.review>
      committer-time 1583907807
      committer-tz +0900
      summary 2
      previous af89ec8f2a0c54c0758e64046ac7f40bcaa7d5ac abc.txt
      filename abc.txt
      \t\x8C\xE1\x94y\x82͔L\x82ł\xA0\x82邩\x82\xE0\x82\xB5\x82\xEA\x82Ȃ\xA2\r\n
    DATA
    assert_equal(
      [GitBlameInfo.new(commit: "144cae9deb69339061292e9db8541701197c640d", original_line: 1, final_line: 1, line_hash: "bc52aa9adb58c1721d9d63da132bf6bdb58dcd85")],
      GitBlameInfo.parse(string_with_invalid_encoding)
    )
  end

  def test_as_json
    info = GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 13, final_line: 7, line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d")
    assert_equal(
      {
        commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e",
        original_line: 13,
        final_line: 7,
        line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d",
      },
      info.as_json,
    )
  end
end
