require "test_helper"
require "runners/testing/smoke"

class TestingSmokeTest < Minitest::Test
  Smoke = Runners::Testing::Smoke

  def test_unify_result_success
    smoke = Smoke.new(['image', 'test/smokes/rubocop'])
    assert smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: 'Hello',
                              }, StringIO.new)
  end

  def test_unify_result_failed
    smoke = Smoke.new(['image', 'test/smokes/rubocop'])
    refute smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello',
                              }, {
                                guid: 'test-guid',
                                timestamp: '2018-07-19 11:29:39 +0900',
                                message: 'Hello',
                              }, StringIO.new)
  end

  def test_unify_result_success_using_regexp
    smoke = Smoke.new(['image', 'test/smokes/rubocop'])
    assert smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello, World',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: /Hello/,
                              }, StringIO.new)
  end

  def test_unify_result_failed_using_regexp
    smoke = Smoke.new(['image', 'test/smokes/rubocop'])
    refute smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello, World',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: /Good/,
                              }, StringIO.new)
  end
end
