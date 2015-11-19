require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_load_sample_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    expected = ["COLORADO", "ACADEMY 20"]
    puts dr.inspect
    assert_equal expected, dr.district_names
  end

  def test_load_sample_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    expected = ["COLORADO", "ACADEMY 20"]

    assert_equal expected, dr.district_names
  end

  def test_load_all_sample_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_grad_sample.csv" },
      :statewide_testing => {
        :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
        :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv",
        :math => "./test/fixtures/csap_data/math_data_sample.csv",
        :reading => "./test/fixtures/csap_data/reading_data_sample.csv",
        :writing => "./test/fixtures/csap_data/writing_data_sample.csv"}
        })
    expected = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14","ADAMS-ARAPAHOE 28J"]

    assert_equal expected, dr.district_names
  end

  def test_load_all_real_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"},
      :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"},
      :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"}
        })
    academy_20 = dr.find_by_name("academy 20")

    assert_equal "ACADEMY 20", academy_20.name
    assert academy_20.enrollment
    assert academy_20.statewide_test
    assert academy_20.economic_profile
  end

  def test_create_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    assert_equal 2, dr.districts.count
  end

  def test_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").name
  end

  def test_find_by_name_lower_case
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    assert_equal "ACADEMY 20", dr.find_by_name("academy 20").name
  end

  def test_find_all_matching_upper_case
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    expected = ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal expected, dr.find_all_matching("ADAMS").map(&:name)
  end

  def test_find_all_matching_lower_case
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    expected = ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    assert_equal expected, dr.find_all_matching("adams").map(&:name)
  end

  def test_enrollment_object_relationship
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.391,  district.enrollment.kindergarten_participation_in_year(2007)
  end

  def test_statewide_testing_object_relationship
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/grade_data/3grade_data_sample.csv",
        :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")

    assert_equal 0.857, district.statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_economic_profile_object_relationship
    dr = DistrictRepository.new
    dr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 85060,  district.economic_profile.estimated_median_household_income_in_year(2005)
  end

  def test_kindergarten_participation_returns_nil_if_NA
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal nil,  district.enrollment.kindergarten_participation_in_year(2006)
  end

  def test_load_full_kindergarten_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    assert_equal 181, dr.district_names.length
  end
end
