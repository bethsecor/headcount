require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

  def test_economic_profile_repository_exists
    assert EconomicProfileRepository
  end

  def test_load_data
    epr = EconomicProfileRepository.new
    assert_equal 0, epr.district_names.count
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal 181, epr.district_names.count
  end

  def test_load_median_household_income
    epr = EconomicProfileRepository.new
    assert_equal 0, epr.district_names.count
    district_data = epr.load_median_household_income({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    assert_equal 181, district_data.count
  end

  def test_load_children_in_poverty
    epr = EconomicProfileRepository.new
    assert_equal 0, epr.district_names.count
    district_data = epr.load_children_in_poverty({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    assert_equal 180, district_data.count
  end

  def test_load_free_or_reduced_price_lunch
    epr = EconomicProfileRepository.new
    assert_equal 0, epr.district_names.count
    district_data = epr.load_free_or_reduced_price_lunch({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    assert_equal 181, district_data.count
  end

  def test_load_title_i
    epr = EconomicProfileRepository.new
    assert_equal 0, epr.district_names.count
    district_data = epr.load_title_i({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    assert_equal 181, district_data.count
  end

  def test_find_by_name
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_estimated_median_household_income_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 85060, ep.estimated_median_household_income_in_year(2005)
    assert_equal 85255, ep.estimated_median_household_income_in_year(2006)
    assert_equal 86203, ep.estimated_median_household_income_in_year(2007)
    assert_equal 87056, ep.estimated_median_household_income_in_year(2008)
    assert_equal 87635.4, ep.estimated_median_household_income_in_year(2009)
  end

  def test_estimated_median_household_income_in_year_raises_unknown_data_error
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      ep.estimated_median_household_income_in_year(2004)
    end
  end

  def test_median_household_income_average
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 87635.4, ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 0.039, ep.children_in_poverty_in_year(2007)
    assert_equal 0.044, ep.children_in_poverty_in_year(2008)
    assert_equal 0.047, ep.children_in_poverty_in_year(2009)
    assert_equal 0.057, ep.children_in_poverty_in_year(2010)
    assert_equal 0.059, ep.children_in_poverty_in_year(2011)
    assert_equal 0.064, ep.children_in_poverty_in_year(2012)
    assert_equal 0.048, ep.children_in_poverty_in_year(2013)
  end

  def test_children_in_poverty_in_year_raises_unknown_data_error
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      ep.children_in_poverty_in_year(2020)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 0.04, ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    assert_equal 0.047, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
    refute_equal 701, ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    refute_equal 855, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_percentage_in_year(2015)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 701, ep.free_or_reduced_price_lunch_number_in_year(2000)
    assert_equal 855, ep.free_or_reduced_price_lunch_number_in_year(2001)
    refute_equal 0.04, ep.free_or_reduced_price_lunch_number_in_year(2000)
    refute_equal 0.047, ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_number_in_year_raises_unknown_data_error
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_number_in_year(2020)
    end
  end

  def test_title_i_in_year
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_equal 0.014, ep.title_i_in_year(2009)
    assert_equal 0.011, ep.title_i_in_year(2011)
    assert_equal 0.010, ep.title_i_in_year(2012)
    assert_equal 0.012, ep.title_i_in_year(2013)
    assert_equal 0.027, ep.title_i_in_year(2014)
  end

  def test_title_i_in_year_raises_unknown_data_error
    epr = EconomicProfileRepository.new
    epr.load_data({
    :economic_profile => {
      :median_household_income => "./data/Median household income.csv",
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
      :title_i => "./data/Title I students.csv"
      }
    })
    ep = epr.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      ep.title_i_in_year(2010)
    end
  end
end
