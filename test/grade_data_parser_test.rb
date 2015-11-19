require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/grade_data_parser'

class GradeDataParserTest < Minitest::Test

  def test_parse_full_data
    parser = GradeDataParser.new({:third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"})

    assert_equal 181, parser.parse.count
  end

  def test_read_and_format_full_data
    parser = GradeDataParser.new({:third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"})

    assert_equal 181, parser.read_and_format_grade.count
  end
end
