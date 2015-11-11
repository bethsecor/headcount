require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'

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

    assert_equal 1.070766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
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

    assert_equal 0.710828, ha.kindergarten_participation_rate_variation('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_kindergarten_participation_rate_variation_trend_different_districts
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_3.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = {2007 => 0.65, 2006 => 0.79}
    assert_equal expected, ha.kindergarten_participation_rate_variation_trend('ADAMS COUNTY 14', :against => 'ADAMS-ARAPAHOE 28J')
  end

  def test_ratios_by_year
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    h_1 = {2009 => 0.45, 2012 => 0.76, 2013 => 0.66}
    h_2 = {2010 => 0.45, 2012 => 0.42, 2013 => 0.56}
    expected = {2012 => 1.81, 2013 => 1.18}
    assert_equal expected, ha.ratios_by_year(h_1, h_2)
  end






end
