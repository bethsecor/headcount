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
    str = statewide_repo
    st = str.find_by_name("ACADEMY 20")

    assert "ACADEMY 20", st.name
    assert_equal "ACADEMY 20", st.name
  end

  def test_create_statewide_tests
    sr = StatewideTestRepository.new
    assert_equal 0, sr.statewide_tests.count

    path = {:statewide_testing => {
            :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
            :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv",
            :math => "./test/fixtures/csap_data/math_data_sample.csv",
            :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
            :writing => "./test/fixtures/csap_data/writing_data_sample.csv"}}
    sr.load_data(path)

    assert sr.statewide_tests.count > 1

  end

  def test_find_all_matching_name
    sr = StatewideTestRepository.new
    sr.create_statewide_tests!([{:name => "ACADEMY 20"},
                            {:name => "ACADEMY 100"}])
    st = sr.find_all_matching("ACADEMY")
    assert_equal 2, st.count
    assert_equal "ACADEMY 20", st[0].name
    assert_equal "ACADEMY 100", st[1].name
  end

  def test_load_data
    sr = StatewideTestRepository.new
    path = {:statewide_testing => {
            :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
            :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv",
            :math => "./test/fixtures/csap_data/math_data_sample.csv",
            :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
            :writing => "./test/fixtures/csap_data/writing_data_sample.csv"}}
    sr.load_data(path)
  end

  def test_load_grade_data
    sr = StatewideTestRepository.new
    path = {:statewide_testing => {
            :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
            :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"}}
    loaded_data = sr.load_data(path)
    assert loaded_data
  end

  def test_load_csap_data
    sr = StatewideTestRepository.new
    assert_equal  0, sr.statewide_tests.count
    path = {:statewide_testing => {
            :math => "./test/fixtures/csap_data/math_data_sample.csv",
            :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
            :writing => "./test/fixtures/csap_data/writing_data_sample.csv"}}
    loaded_data = sr.load_data(path)
    assert loaded_data
    assert sr.statewide_tests.count > 1
  end

  def test_date_includes_third_and_eighth_grade
    sr = StatewideTestRepository.new
    path_keys = { :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv" }
    refute sr.data_includes_third_and_eighth_grade(path_keys)

    path_keys = { :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv" }
    refute sr.data_includes_third_and_eighth_grade(path_keys)

    path_keys = { :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
                  :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"}
    assert sr.data_includes_third_and_eighth_grade(path_keys)
  end

  def test_data_includes_all_subjects
    sr = StatewideTestRepository.new
    path_keys = { :math => "./test/fixtures/csap_data/math_data_sample.csv",
             :reading => "./test/fixtures/csap_data/reading_data_sample.csv"}
    refute sr.data_includes_all_subjects(path_keys)

    path_keys = { :math => "./test/fixtures/csap_data/math_data_sample.csv",
             :writing => "./test/fixtures/csap_data/writing_data_sample.csv" }
    refute sr.data_includes_all_subjects(path_keys)

    path_keys = { :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
             :writing => "./test/fixtures/csap_data/writing_data_sample.csv" }
    refute sr.data_includes_all_subjects(path_keys)

    path_keys = { :math => "./test/fixtures/csap_data/math_data_sample.csv",
            :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
            :writing => "./test/fixtures/csap_data/writing_data_sample.csv" }

    assert sr.data_includes_all_subjects(path_keys)
  end

  def test_proficient_by_race_or_ethnicity
    str = statewide_repo
      testing = str.find_by_name("ACADEMY 20")
      expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
                   2012 => {math: 0.818, reading: 0.893, writing: 0.808},
                   2013 => {math: 0.805, reading: 0.901, writing: 0.810},
                   2014 => {math: 0.800, reading: 0.855, writing: 0.789},
                 }
      assert_equal expected, testing.proficient_by_race_or_ethnicity(:asian)
    end

  def test_proficient_by_grade
    str = statewide_repo
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }

    district = str.find_by_name("ACADEMY 20")
    assert_equal expected, district.proficient_by_grade(3)
  end

  def test_proficient_for_subject_by_grade_in_year
    str = statewide_repo

    district = str.find_by_name("ACADEMY 20")
    assert_equal 0.653, district.proficient_for_subject_by_grade_in_year(:math, 8, 2011)
  end

  def test_proficient_for_subject_by_race_in_year
    str = statewide_repo
    st = str.find_by_name("AULT-HIGHLAND RE-9")

    assert_equal 0.611, st.proficient_for_subject_by_race_in_year(:math, :white, 2012)
    assert_equal 0.794, st.proficient_for_subject_by_race_in_year(:reading, :white, 2013)
    assert_equal 0.278, st.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014)
  end

  def test_proficient_by_grade_returns_error_with_unknown_grade
    str = statewide_repo
    st = str.find_by_name("ACADEMY 20")

    assert_raises  UnknownDataError do st.proficient_by_grade(5) end
    assert_raises  UnknownDataError do st.proficient_by_grade(2) end
  end

  def test_proficient_by_race_returns_error_with_unknown_race
    str = statewide_repo
    st = str.find_by_name("ACADEMY 20")

    assert_raises  UnknownRaceError do st.proficient_by_race_or_ethnicity(:ethiopian) end
    assert_raises  UnknownRaceError do st.proficient_by_race_or_ethnicity(:czech) end
  end

  def test_proficient_for_subject_by_grade_and_year_returns_error_unless_all_inputs_are_valid
    str = statewide_repo
    st = str.find_by_name("ACADEMY 20")

    assert_raises  UnknownDataError do st.proficient_for_subject_by_grade_in_year(:math, 3, 1999) end
    assert_raises  UnknownDataError do st.proficient_for_subject_by_grade_in_year(:math, 5, 2011) end
    assert_raises  UnknownDataError do st.proficient_for_subject_by_grade_in_year(:pizza, 3, 2011) end
  end

  def test_proficient_for_subject_by_race_in_year_returns_error_unless_all_inputs_are_valid
    str = statewide_repo
    st = str.find_by_name("ACADEMY 20")

    assert_raises  UnknownDataError do st.proficient_for_subject_by_race_in_year(:math, :asian, 1990) end
    assert_raises  UnknownDataError do st.proficient_for_subject_by_race_in_year(:math, :czech, 2011) end
    assert_raises  UnknownDataError do st.proficient_for_subject_by_race_in_year(:pizza, :asian, 2011) end
  end

  def statewide_repo
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    str
  end
end
