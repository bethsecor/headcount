require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_percent_parser'
require 'pry'

class DataByYearParserTest < Minitest::Test

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
  #
  # def test_format_returns_hash_of_all_data
  #   parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")
  #   expected = [{:name => "COLORADO", :kindergarten_participation => {2006 => 0.33677, 2007 => 0.39465}},
  #               {:name => "ACADEMY 20",:kindergarten_participation => {2006 => nil, 2007 => 0.39159}}]
  #
  #   assert_equal expected, parser.format_kindergarten_data
  # end

end
