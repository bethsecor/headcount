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



end
