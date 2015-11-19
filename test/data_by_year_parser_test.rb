require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_year_parser'
require 'pry'

class DataByYearParserTest < Minitest::Test

  def test_parse_exists
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")

    assert parser.respond_to?(:parse)
    assert parser.respond_to?(:create_hash_data)
    assert parser.respond_to?(:csv_opener)
    assert parser.respond_to?(:create_new_key_for_district)
    assert parser.respond_to?(:add_participation_data_by_year)
    assert parser.respond_to?(:clean_participation)
    assert parser.respond_to?(:number?)
    assert parser.respond_to?(:format_kindergarten_data)
    assert parser.respond_to?(:format_hs_graduation_data)
    assert parser.respond_to?(:format_title_i_data)
  end

  def test_parse_returns_hash_of_hashes_kindergarten
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = {"COLORADO" => {2007 => 0.39465, 2006 => 0.33677},
    "ACADEMY 20" => {2007 => 0.39159, 2006 => nil}}

    assert_equal expected, parser.parse
  end

  def test_format_returns_hash_of_all_data_kindergarten
    parser = DataByYearParser.new("./test/fixtures/kindergarten_sample.csv")
    expected = [{:name => "COLORADO", :kindergarten_participation => {2006 => 0.33677, 2007 => 0.39465}},
                {:name => "ACADEMY 20",:kindergarten_participation => {2006 => nil, 2007 => 0.39159}}]

    assert_equal expected, parser.format_kindergarten_data
  end

  def test_parsing_high_school_data
    parser = DataByYearParser.new("./test/fixtures/high_school_grad_sample.csv")
    expected = {"ACADEMY 20" => {2010 => 0.895, 2011 => 0.895},
    "ADAMS COUNTY 14" => {2010 => 0.57, 2011 => 0.608},
    "ADAMS-ARAPAHOE 28J" => {2010 => 0.455, 2011 => 0.485}}

    assert_equal expected, parser.parse
  end

  def test_formatting_high_school_data
    parser = DataByYearParser.new("./test/fixtures/high_school_grad_sample.csv")
    expected = [{:name => "ACADEMY 20", :high_school_graduation => {2010 => 0.895, 2011 => 0.895}},
    {:name => "ADAMS COUNTY 14", :high_school_graduation => {2010 => 0.57, 2011 => 0.608}},
    {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => {2010 => 0.455, 2011 => 0.485}}]

    assert_equal expected, parser.format_hs_graduation_data
  end

  def test_parsing_title_i_data
    parser = DataByYearParser.new("./test/fixtures/economic_profile/title_i_sample.csv")
    expected = {"COLORADO" => {2009 => 0.216, 2011 => 0.224, 2012 => 0.22907, 2013 => 0.23178, 2014 => 0.23556},
    "ACADEMY 20" => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}

    assert_equal expected, parser.parse
  end

  def test_formatting_title_i_data
    parser = DataByYearParser.new("./test/fixtures/economic_profile/title_i_sample.csv")
    expected = [{:name => "COLORADO", :title_i => {2009 => 0.216, 2011 => 0.224, 2012 => 0.22907, 2013 => 0.23178, 2014 => 0.23556}},
    {:name => "ACADEMY 20", :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}]

    assert_equal expected, parser.format_title_i_data
  end

end
