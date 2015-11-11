require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test
  def test_load_data
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    expected = ["COLORADO", "ACADEMY 20"]
    assert_equal expected, dr.district_names
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

  def test_enrollment_object_relationship
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.39159,  district.enrollment.kindergarten_participation_in_year(2007)
  end

  def test_data_returns_nil_if_NA
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal nil,  district.enrollment.kindergarten_participation_in_year(2006)
  end
end
