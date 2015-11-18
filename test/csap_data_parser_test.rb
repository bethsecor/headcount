require 'minitest/autorun'
require 'minitest/pride'
require './lib/csap_data_parser'
require 'pry'

class CSAPDataParserTest < Minitest::Test

  def test_fuuuuuuuck_this
    parser = CSAPDataParser.new({:math => "./test/fixtures/csap_data/math_data_sample.csv",
    :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
    :writing => "./test/fixtures/csap_data/writing_data_sample.csv"})
    expected = [ {:name=>"COLORADO",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.5573, :reading=>0.68, :writing=>0.5531}, 2012=>{:math=>0.558, :reading=>0.6932, :writing=>0.5404}},
                    :asian=>
                     {2011=>{:math=>0.7094, :reading=>0.7482, :writing=>0.6569}, 2012=>{:math=>0.7192, :reading=>0.7574, :writing=>0.6588}}}},
                 {:name=>"ACADEMY 20",
                  :csap_data=>
                   {:all_students=>
                     {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
                    :asian=>
                     {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}]

    assert_equal expected, parser.read_and_format_csap
  end

  def test_fuuuuuuuck_this_full_data
    parser = CSAPDataParser.new({:math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"})

    assert_equal 181, parser.read_and_format_csap.count
  end

end
