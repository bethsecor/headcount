require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_lunch_parser'
require 'pry'

class DataByLunchParserTest < Minitest::Test

  def test_data_by_lunch_parser_exists
    assert DataByLunchParser
  end

  def test_parse
    parser = DataByLunchParser.new("./test/fixtures/economic_profile/lunch_data_sample.csv")
    expected = {"COLORADO" =>
                {2000 => {:percentage => 0.27, :total => 195149},
                 2001 => {:percentage => 0.27528, :total => 204299}}
                }
    assert_equal expected, parser.parse
  end

  def test_format
    parser = DataByLunchParser.new("./test/fixtures/economic_profile/lunch_data_sample.csv")
    expected = [{:name => "COLORADO", :free_or_reduced_price_lunch =>
                {2000 => {:percentage => 0.27, :total => 195149},
                 2001 => {:percentage => 0.27528, :total => 204299}}
                }]
    assert_equal expected, parser.format_lunch_data
  end
end
