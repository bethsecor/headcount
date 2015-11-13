require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  def test_find_by_name_returns_nil
    sr = StatewideTestRepository.new
    assert_nil sr.find_by_name("ACADEMY 20")
  end
end
