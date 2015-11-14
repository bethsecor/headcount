require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_exists
    assert StatewideTest
  end

  def test_raises_error_with_unknown_race
    data = {:name=>"ACADEMY 20",
     :csap_data=>
      {:all_students=>
        {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
       :asian=>
        {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    st = StatewideTest.new(data)

   assert_raises UnknownRaceError do
     st.proficient_by_race_or_ethnicity(:pizza)
   end
  end

  def test_doesnt_raise_error_with_known_race
    data = {:name=>"ACADEMY 20",
     :csap_data=>
      {:all_students=>
        {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
       :asian=>
        {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    st = StatewideTest.new(data)
    expected = {2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826}, 2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808}}

   assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_raises_error_with_unknown_subject
    data = {:name=>"ACADEMY 20",
     :csap_data=>
      {:all_students=>
        {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
       :asian=>
        {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    st = StatewideTest.new(data)

   assert_raises UnknownDataError do
     st.proficient_for_subject_by_race_in_year(:pizza, :asian, 2011)
   end
  end

  def test_doesnt_raise_error_with_known_subject_race_year
    data = {:name=>"ACADEMY 20",
     :csap_data=>
      {:all_students=>
        {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
       :asian=>
        {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    st = StatewideTest.new(data)
    expected = 0.680

    assert_equal expected, st.proficient_for_subject_by_race_in_year(:math, :all_students, 2011)
  end

end
