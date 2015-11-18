require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_range_parser'
require 'pry'

class DataByYearRangeParserTest < Minitest::Test

  def test_parse_exists
    parser = DataByYearRangeParser.new("./test/fixtures/economic_profile/median_household_income_sample.csv")

    assert parser.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes
    parser = DataByYearRangeParser.new("./test/fixtures/economic_profile/median_household_income_sample.csv")
    expected = {"COLORADO" => {2005 => [56222], 2006 => [56222,56456], 2007 => [56222,56456, 57685],
                               2008 => [56222, 56456, 58244, 57685], 2009 => [56222,56456, 58244, 57685, 58433],
                               2010 => [56456, 58244, 57685, 58433],
                               2011 => [58244, 57685, 58433], 2012 => [58244, 58433], 2013 =>[58433]},
              "ACADEMY 20" => {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]}}

    assert_equal expected, parser.parse
  end

  def test_format_returns_array_of_all_data
    parser = DataByYearRangeParser.new("./test/fixtures/economic_profile/median_household_income_sample.csv")
    expected = [{:name => "COLORADO", :median_household_income => {2005 => [56222], 2006 => [56222,56456], 2007 => [56222,56456, 57685],
                               2008 => [56222, 56456, 58244, 57685], 2009 => [56222,56456, 58244, 57685, 58433],
                               2010 => [56456, 58244, 57685, 58433],
                               2011 => [58244, 57685, 58433], 2012 => [58244, 58433], 2013 =>[58433]}},
              {:name => "ACADEMY 20", :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]}}]

    assert_equal expected, parser.format_year_range_data
  end
end
