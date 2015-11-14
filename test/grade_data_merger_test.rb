require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/grade_data_merger'

class GradeDataMergerTest < Minitest::Test
  def test_merge_third_and_eight_grade_data
    path = {:statewide_testing => {
    :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
    :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"}}
    merger = GradeDataMerger.new(path)
    expected = [{:name=>"COLORADO",
                  :grade_data=>
                    {:third_grade=>{2008=>{:math=>0.697, :reading=>0.703, :writing=>0.501}, 2009=>{:math=>0.691, :reading=>0.726, :writing=>0.536}},
                    :eighth_grade=>{2008=>{:math=>0.469, :reading=>0.703, :writing=>0.529}, 2009=>{:math=>0.499, :reading=>0.726, :writing=>0.528}}}},
                {:name=>"ACADEMY 20",
                  :grade_data=>
                    {:third_grade=>{2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}, :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}}}}]


    assert_equal expected, merger.merge_grade_data
  end
end
