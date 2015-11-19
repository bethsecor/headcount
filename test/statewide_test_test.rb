require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_exists
    assert StatewideTest
  end

  def test_statewide_test_responds_to_method_calls
    st = create_statewide_test_object_with_grade_data

    assert st.respond_to?("proficient_by_race_or_ethnicity")
    assert st.respond_to?("proficient_for_subject_by_race_in_year")
    assert st.respond_to?("proficient_by_grade")
    assert st.respond_to?("proficient_for_subject_by_grade_in_year")
    assert st.respond_to?("subject_and_year_are_both_valid")
    assert st.respond_to?("subject_race_and_year_are_all_valid")
    assert st.respond_to?("truncate_to_three_digits")
    assert st.respond_to?("truncate_hash_values")
  end

  def test_proficient_by_race_or_ethnicity
    st = create_statewide_test_object_with_race_data
    expected = {2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826}, 2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808}}

   assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficiency_for_subject_by_race_in_year
    st = create_statewide_test_object_with_race_data
    expected = 0.680

    assert_equal expected, st.proficient_for_subject_by_race_in_year(:math, :all_students, 2011)
  end

  def test_proficient_by_grade
    st = create_statewide_test_object_with_grade_data
    expected = {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_proficient_for_subject_by_grade_in_year
    st = create_statewide_test_object_with_grade_data
    expected = 0.857
    assert_equal expected, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_proficient_by_race_raises_error_with_unknown_race
    st = create_statewide_test_object_with_race_data

   assert_raises UnknownRaceError do
     st.proficient_by_race_or_ethnicity(:pizza)
   end
  end

  def test_proficient_by_subject_raises_error_with_unknown_subject
    st = create_statewide_test_object_with_race_data

   assert_raises UnknownDataError do
     st.proficient_for_subject_by_race_in_year(:pizza, :asian, 2011)
   end
  end

  def test_proficient_by_grade_raises_error_with_unknown_grade
    st = create_statewide_test_object_with_grade_data

    assert_raises UnknownDataError do
      st.proficient_by_grade(4)
    end
  end

  def test_proficient_for_subject_by_grade_raises_error_with_unknown_grade
    st = create_statewide_test_object_with_grade_data

    assert_raises UnknownDataError do
      st.proficient_for_subject_by_grade_in_year(:math, 4, 2008)
    end
  end

  def test_proficient_for_subj_by_grade_in_year_raises_error_with_unknown_subject
    st = create_statewide_test_object_with_grade_data

    assert_raises UnknownDataError do
      st.proficient_for_subject_by_grade_in_year(:pizza, 3, 2008)
    end
  end

  def test_proficient_for_subj_by_grade_in_year_raises_error_with_unknown_year
    st = create_statewide_test_object_with_grade_data

    assert_raises UnknownDataError do
      st.proficient_for_subject_by_grade_in_year(:math, 3, 2020)
    end
  end

  def test_subject_and_year_validity_with_valid_inputs
    st = create_statewide_test_object_with_grade_data

    assert st.subject_and_year_are_both_valid(:math, 2008)
    assert st.subject_and_year_are_both_valid(:reading, 2013)
    assert st.subject_and_year_are_both_valid(:writing, 2014)
  end

  def test_subject_and_year_validity_with_invalid_inputs
    st = create_statewide_test_object_with_grade_data

    refute st.subject_and_year_are_both_valid(:pizza, 2008)
    refute st.subject_and_year_are_both_valid(:reading, 1999)
  end

  def test_subject_race_and_year_validity_with_valid_inputs
    st = create_statewide_test_object_with_grade_and_race_data

    assert st.subject_race_and_year_are_all_valid(:math, :asian, 2011)
    assert st.subject_race_and_year_are_all_valid(:reading, :all_students, 2014)
  end

  def test_subject_race_and_year_validity_with_valid_inputs
    st = create_statewide_test_object_with_grade_and_race_data

    refute st.subject_race_and_year_are_all_valid(:pizza, :asian, 2011)
    refute st.subject_race_and_year_are_all_valid(:reading, :ethiopian, 2014)
    refute st.subject_race_and_year_are_all_valid(:writing, :all_students, 1999)
  end

  def test_proficient_for_subject_by_grade_in_year_with_nil_returns_NA
    data = {:name=>"ACADEMY 20",
      :grade_data=>
        {:third_grade=>{2008=>{:math=>nil, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}}}
    st = StatewideTest.new(data)

    assert_equal "N/A", st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_truncate_to_three_digits
    st = create_statewide_test_object_with_grade_data

    assert_equal 0.659, st.truncate_to_three_digits(0.659785)
  end

  def test_truncate_hash_values
    st = create_statewide_test_object_with_grade_data
    values_to_truncate =  {"ACADEMY 20" =>
      {:math=>0.857123, :reading=>0.866567, :writing=>0.6714675}}
    expected = {"ACADEMY 20" => {:math=>0.857, :reading=>0.866, :writing=>0.671}}

    assert_equal expected, st.truncate_hash_values(values_to_truncate)
  end

  def create_statewide_test_object_with_grade_data
    data = {:name=>"ACADEMY 20",
      :grade_data=>
        {:third_grade=>{2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}},
        :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}}}}
    StatewideTest.new(data)
  end

  def create_statewide_test_object_with_race_data
    data = {:name=>"ACADEMY 20",
     :csap_data=>
      {:all_students=>
        {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
       :asian=>
        {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    StatewideTest.new(data)
  end

  def create_statewide_test_object_with_grade_and_race_data
    data = {:name=>"ACADEMY 20",
      :csap_data=>
        {:all_students=>
          {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
         :asian=>
          {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}},
      :grade_data=>
        {:third_grade=>{2008=>{:math=>nil, :reading=>0.866, :writing=>0.671}, 2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706}}, :eighth_grade=>{2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}}}}
    StatewideTest.new(data)
  end

end
