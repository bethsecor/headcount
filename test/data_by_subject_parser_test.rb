require 'minitest/autorun'
require 'minitest/pride'
require './lib/data_by_subject_parser'
require 'pry'

class DataBySubjectParserTest < Minitest::Test

  def test_data_by_subject_parser_exists
    assert DataBySubjectParser
  end

  def test_parse
    path =
    parser = DataBySubjectParser.new("./test/fixtures/grade_data/3grade_data_sample.csv", :third_grade)
    expected = {"COLORADO" =>
                {:third_grade => {2008 => {:math => 0.697, :reading => 0.703, :writing => 0.501},
                                  2009 => {:math => 0.691, :reading => 0.726, :writing => 0.536}}},
                "ACADEMY 20" =>
                {:third_grade => {2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                                  2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706}}}
                }
    assert_equal expected, parser.parse
  end
end
