require 'minitest/autorun'
require 'minitest/pride'
require './lib/kindergarten_csv_parser'

class KindergartenParserTest < Minitest::Test

  def test_parse_exists
    k = KindergartenParser.new("./test/fixtures/kindergarten_sample.csv")
    assert k.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes
    k = KindergartenParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = {"COLORADO" => {"2007" => "0.39465", "2006" => "0.33677"},
    "ACADEMY 20" => {"2007" => "0.39159", "2006" => "0.35364"}}
    assert_equal expected, k.parse
  end

end
