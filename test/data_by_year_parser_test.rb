require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_year_parser'

class DataByYearParserTest < Minitest::Test

  def test_parse_exists
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")

    assert parser.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = {"COLORADO" => {2007 => 0.39465, 2006 => 0.33677},
    "ACADEMY 20" => {2007 => 0.39159, 2006 => nil}}

    assert_equal expected, parser.parse
  end

  def test_format_returns_hash_of_all_data
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = [{:name => "COLORADO", :kindergarten_participation => {2007 => 0.39465, 2006 => 0.33677}},
                {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => nil}}]

    assert_equal expected, parser.format_kindergarten_data
  end

end
