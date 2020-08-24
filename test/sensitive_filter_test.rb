require "test_helper"

class SensitiveFilterTest < Minitest::Test
  include TestHelper

  def new_filter(stdout: StringIO.new, stderr: StringIO.new)
    options = Runners::Options.new(stdout, stderr)
    Runners::SensitiveFilter.new(options: options)
  end

  def test_mask
    source = {
      head: "123abc",
      base: "456def",
      git_url: "https://github.com/foo/bar",
      git_url_userinfo: "user:secret",
      pull_number: 105,
    }
    with_runners_options_env(source: source) do
      filter = new_filter
      assert_equal "https://[FILTERED]@github.com/foo/bar", filter.mask("https://user:secret@github.com/foo/bar")
      assert_equal "https://github.com/foo/bar", filter.mask("https://github.com/foo/bar")
    end
  end
end
