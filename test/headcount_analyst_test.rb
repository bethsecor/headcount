require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'
require 'pry'

class HeadcountAnalystTest < Minitest::Test

  def test_headcount_analyst_exists
    assert HeadcountAnalyst
  end

  def test_kindergarten_participation_rate_variation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.070, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_with_nil_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal nil, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_different_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.710, ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_rate_variation_different_districts_with_zero_data_point
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_with_zero_data_point.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal nil, ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_rate_variation_trend_different_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = {2006 => 0.792, 2007 => 0.647}
    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_rate_variation_trend_different_districts_with_zero_data_points
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_with_zero_data_point.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = {2006 => nil, 2007 => nil}
    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_variation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_grad_sample.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 1.070, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv",
        :high_school_graduation => "./test/fixtures/hs_grad_including_state_data.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.874, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv",
        :high_school_graduation => "./test/fixtures/hs_grad_including_state_data.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal nil, ha.kindergarten_participation_correlates_with_high_school_graduation(:for => "ACADEMY 20")
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"])
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => "STATEWIDE")
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_full_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
  
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => "STATEWIDE")
  end

  def test_ratios_by_year
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    h_1 = {2009 => 0.45, 2012 => 0.76, 2013 => 0.66}
    h_2 = {2010 => 0.45, 2012 => 0.42, 2013 => 0.56}
    expected = {2012 => 1.809, 2013 => 1.178}
    assert_equal expected, ha.ratios_by_year(h_1, h_2)
  end

  def test_top_statewide_test_yoy_growth_raises_error_wo_grade
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)


    e = assert_raises InsufficientInformationError do
        ha.top_statewide_test_year_over_year_growth({:subject => :math})
    end

    assert_equal "A grade must be provided to answer this question", e.message
  end

  def test_top_statewide_test_yoy_growth_raises_error_with_invalid_grade
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)


    e = assert_raises UnknownDataError do
        ha.top_statewide_test_year_over_year_growth({:grade => 4})
    end

    assert_equal "4 is not a known grade.", e.message
  end

  def test_top_statewide_yoy_growth_returns_top_district
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/grade_data/3grade_sample_three_districts.csv",
        :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["ACADEMY 20", -0.004],  ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_top_statewide_yoy_growth_returns_top_districts
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/grade_data/3grade_sample_three_districts.csv",
        :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal [["ACADEMY 20", -0.004], ["ADAMS-ARAPAHOE 28J", -0.009], ["ADAMS COUNTY 14", -0.045]],  ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
  end

  def test_calculate_differences
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    data = [1, 3, 6, 10]
    assert_equal 3, ha.calculate_differences(data)

  end

  def test_top_statewide_yoy_growth_returns_weighted_sum_for_top_dist
    dr = DistrictRepository.new
    dr.load_data({
      :statewide_testing => {
        :third_grade => "./test/fixtures/grade_data/3grade_sample_three_districts.csv",
        :eighth_grade => "./test/fixtures/grade_data/8grade_data_sample.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal ["ACADEMY 20", -0.002],  ha.top_statewide_test_year_over_year_growth(grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
  end

end
