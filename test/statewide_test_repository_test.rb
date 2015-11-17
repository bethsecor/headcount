require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'
require 'pry'

class StatewideTestRepositoryTest < Minitest::Test
  def test_find_by_name_returns_nil
    sr = StatewideTestRepository.new
    assert_nil sr.find_by_name("ACADEMY 20")
  end

  def test_find_by_name
    sr = StatewideTestRepository.new
    data = [ {:name=>"COLORADO",
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
    sr.create_statewide_tests!(data)
    st = sr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", st.name
  end

  def test_load_data
    sr = StatewideTestRepository.new
    assert_equal  0, sr.statewide_tests.count
    path = {:statewide_testing => {
    :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
    :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv",
    :math => "./test/fixtures/csap_data/math_data_sample.csv",
    :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
    :writing => "./test/fixtures/csap_data/writing_data_sample.csv"}}
    sr.load_data(path)
    assert_equal  2, sr.statewide_tests.count
  end

  def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
                    :statewide_testing => {
                      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :eigth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                    }
                  })
    str
  end

  def test_statewide_testing_repository_basics
    skip
    str = statewide_repo
    assert str.find_by_name("ACADEMY 20")
    assert str.find_by_name("GUNNISON WATERSHED RE1J")
  end

  def test_basic_proficiency_by_grade
    # str = statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/grade_data/academy_20_3rd_grade.csv",
                      :eighth_grade => "./test/fixtures/grade_data/academy_20_8th_grade.csv"
                    }
                  })
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }


    testing = str.find_by_name("ACADEMY 20")
    assert_equal expected, testing.proficient_by_grade(3)
  end

  def test_basic_proficiency_by_race
    skip
    str = statewide_repo
    testing = str.find_by_name("ACADEMY 20")
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
              2012 => {math: 0.818, reading: 0.893, writing: 0.808},
              2013 => {math: 0.805, reading: 0.901, writing: 0.810},
              2014 => {math: 0.800, reading: 0.855, writing: 0.789},
            }
    assert_equal expected, testing.proficient_by_race_or_ethnicity(:asian)
  end
end
