require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_percent_parser'

class DataByPercentParserTest < Minitest::Test

  def test_parse_exists
    parser = DataByPercentParser.new("./test/fixtures/economic_profile/children_in_poverty.csv")

    assert parser.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes
    parser = DataByPercentParser.new("./test/fixtures/economic_profile/children_in_poverty.csv")
    expected =
    {"ACADEMY 20" => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
      2012  =>  0.064, 2013  =>  0.048}}

    assert_equal expected, parser.parse
  end

  def test_format_returns_hash_of_all_data
    parser = DataByPercentParser.new("./test/fixtures/economic_profile/children_in_poverty.csv")
    expected = [{:name => "ACADEMY 20", :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
      2012  =>  0.064, 2013  =>  0.048}}]

    assert_equal expected, parser.format_poverty_data
  end
end
