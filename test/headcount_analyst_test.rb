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

    assert_equal 1.071, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_rate_variation_with_nil_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)

    assert_equal "Can't compute.", ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
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

    assert_equal "Can't compute.", ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_rate_variation_trend_different_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = {2006 => 0.791, 2007 => 0.646}
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
    expected = {2006 => "Can't compute.", 2007 => "Can't compute."}
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

    assert_equal 1.071, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
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

    assert_equal 0.875, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
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
    # assert ha.kindergarten_participation_correlates_with_high_school_graduation(:for => "ACADEMY 20")
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"])
  end

  def test_ratios_by_year
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    h_1 = {2009 => 0.45, 2012 => 0.76, 2013 => 0.66}
    h_2 = {2010 => 0.45, 2012 => 0.42, 2013 => 0.56}
    expected = {2012 => 1.809, 2013 => 1.178}
    assert_equal expected, ha.ratios_by_year(h_1, h_2)
  end

end
