require 'minitest/autorun'
require 'minitest/pride'
require './lib/kindergarten_parser'

class KindergartenParserTest < Minitest::Test

  def test_parse_exists
    k = KindergartenParser.new("./test/fixtures/kindergarten_sample.csv")
    assert k.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes
    k = KindergartenParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = {"COLORADO" => {2007 => 0.39465, 2006 => 0.33677},
    "ACADEMY 20" => {2007 => 0.39159, 2006 => nil}}
    assert_equal expected, k.parse
  end

  def test_format_returns_hash_of_all_data
    k = KindergartenParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = [{:name => "COLORADO", :kindergarten_participation => {2007 => 0.39465, 2006 => 0.33677}},
                {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => nil}}]
    assert_equal expected, k.format
  end

end
