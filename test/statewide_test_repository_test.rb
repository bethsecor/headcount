require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'

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
end
