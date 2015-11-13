require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_race_ethnicity_parser'
require 'pry'

class DataByRaceEthnicityParserTest < Minitest::Test

  def test_parse_exists
    parser = DataByRaceEthnicityParser.new("./test/fixtures/proficiency_on_CSAP_sample.csv", :math)

    assert parser.respond_to?(:parse)
  end

  def test_parse_returns_hash_of_hashes_of_hashes
    parser = DataByRaceEthnicityParser.new("./test/fixtures/proficiency_on_CSAP_sample_math.csv", :math)
    expected = {"COLORADO" =>
                {:all_students => {2011 => {:math => 0.5573}, 2012 => {:math => 0.558}},
                :asian => {2011 => {:math => 0.7094}, 2012 => {:math => 0.7192}},
                :black => {2011 => {:math => 0.3333}, 2012 => {:math => 0.3359}},
                :pacific_islander => {2011 => {:math => 0.541}, 2012 => {:math => 0.5055}},
                :hispanic => {2011 => {:math => 0.3926}, 2012 => {:math => 0.3898}},
                :native_american => {2011 => {:math => 0.3981}, 2012 => {:math => 0.4013}},
                :two_or_more => {2011 => {:math => 0.6101}, 2012 => {:math => 0.6145}},
                :white => {2011 => {:math => 0.6585}, 2012 => {:math => 0.6618}}}}

    assert_equal expected, parser.parse
  end

  def test_format_returns_hash_of_all_data
    parser = DataByRaceEthnicityParser.new("./test/fixtures/proficiency_on_CSAP_sample.csv", :math)
    data = {"COLORADO" => {:all_students => {2011 => {:math => 0.5573}, 2012 => {:math => 0.558}},
                    :asian => {2011 => {:math => 0.7094}, 2012 => {:math => 0.7192}}},
    "ACADEMY 20" => {:all_students => {2011 => {:math => 0.5737}, 2012 => {:math => 0.0191}},
                    :asian => {2011 => {:math => 0.48281}, 2012 => {:math => 0.10384}}}}

    expected = [{:name => "COLORADO", :csap_math => {:all_students => {2011 => {:math => 0.5573}, 2012 => {:math => 0.558}},
                                                            :asian => {2011 => {:math => 0.7094}, 2012 => {:math => 0.7192}}}},
                {:name => "ACADEMY 20", :csap_math => {:all_students => {2011 => {:math => 0.5737}, 2012 => {:math => 0.0191}},
                                :asian => {2011 => {:math => 0.48281}, 2012 => {:math => 0.10384}}}}]

    assert_equal expected, parser.format_csap(data)
  end

end
