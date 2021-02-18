require "test_helper"

class AnalyzersTest < Minitest::Test
  include TestHelper

  def test_each
    id, analyzer = analyzers.each.next
    assert_equal :brakeman, id
    assert_equal "Brakeman", analyzer[:name]
  end

  def test_each_block
    called = false

    analyzers.each do |id, analyzer|
      assert_equal :brakeman, id
      assert_equal "Brakeman", analyzer[:name]
      called = true
      break
    end

    assert called
  end

  def test_map
    names = analyzers.map { |id, analyzer| "#{id} => #{analyzer[:name]}" }
    assert_equal "brakeman => Brakeman", names.first
  end

  def test_size
    assert_instance_of Integer, analyzers.size
  end

  def test_include?
    assert analyzers.include?(:eslint)
    refute analyzers.include?("foo")
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

  def test_website
    assert_equal "https://eslint.org", analyzers.website(:eslint)
    assert_equal "https://eslint.org", analyzers.website("eslint")
  end

  def test_docker
    assert_equal "https://hub.docker.com/r/sider/runner_eslint", analyzers.docker(:eslint)
    assert_equal "https://hub.docker.com/r/sider/runner_eslint", analyzers.docker("eslint")
  end

  def test_deprecated
    assert analyzers.deprecated?(:tslint)
    assert analyzers.deprecated?("tslint")
    refute analyzers.deprecated?(:eslint)
    refute analyzers.deprecated?("eslint")
  end

  def test_beta
    assert analyzers.beta?(:pylint)
    assert analyzers.beta?("pylint")
    refute analyzers.beta?(:eslint)
    refute analyzers.beta?("eslint")
  end

  private

  def analyzers
    @analyzers ||= Runners::Analyzers.new
  end
end
