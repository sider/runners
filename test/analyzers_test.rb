require_relative "test_helper"

class AnalyzersTest < Minitest::Test
  include TestHelper

  def analyzers
    @analyzers ||= Runners::Analyzers.new
  end

  def test_name
    assert_equal "ESLint", analyzers.name(:eslint)
    assert_equal "ESLint", analyzers.name("eslint")
  end

  def test_name_failed
    assert_raises(KeyError) { analyzers.name(:foo) }
  end

  def test_github
    assert_equal "https://github.com/eslint/eslint", analyzers.github(:eslint)
    assert_equal "https://github.com/eslint/eslint", analyzers.github("eslint")
  end

  def test_github_failed
    assert_raises(KeyError) { analyzers.github(:foo) }
  end

  def test_doc
    assert_equal "https://help.sider.review/tools/javascript/eslint", analyzers.doc(:eslint)
    assert_equal "https://help.sider.review/tools/javascript/eslint", analyzers.doc("eslint")
  end

  def test_doc_failed
    assert_raises(KeyError) { analyzers.doc(:foo) }
  end

  def test_deprecated
    refute analyzers.deprecated?(:eslint)
    refute analyzers.deprecated?("eslint")
  end
end
