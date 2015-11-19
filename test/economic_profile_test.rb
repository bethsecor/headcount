require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def test_economic_profile_exists
    assert EconomicProfile
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)
    assert ep.respond_to?(:estimated_median_household_income_in_year)
    assert ep.respond_to?(:median_income_with_array_input)
    assert ep.respond_to?(:average_income)
    assert ep.respond_to?(:median_household_income_average)
    assert ep.respond_to?(:children_in_poverty_in_year)
    assert ep.respond_to?(:free_or_reduced_price_lunch_percentage_in_year)
    assert ep.respond_to?(:free_or_reduced_price_lunch_number_in_year)
    assert ep.respond_to?(:title_i_in_year)
    assert ep.respond_to?(:truncate_to_three_digits)
  end

  def test_estimated_median_household_income_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 85060, ep.estimated_median_household_income_in_year(2005)
    assert_equal 85255, ep.estimated_median_household_income_in_year(2006)
    assert_equal 86203, ep.estimated_median_household_income_in_year(2007)
    assert_equal 87056, ep.estimated_median_household_income_in_year(2008)
    assert_equal 87635.4, ep.estimated_median_household_income_in_year(2009)
  end

  def test_estimated_median_household_income_in_year_raises_unknown_data_error
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_raises UnknownDataError do
      ep.estimated_median_household_income_in_year(2004)
    end
  end

  def test_estimated_median_household_income_in_year_with_nil
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,nil], 2007 => [85060,nil, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, nil],
                               2010 => [85450, 89615, 88099, nil],
                               2011 => [89615, 88099, nil], 2012 => [89615, nil], 2013 =>[nil]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 85060, ep.estimated_median_household_income_in_year(2005)
    assert_equal 85060, ep.estimated_median_household_income_in_year(2006)
    assert_equal 86579.5, ep.estimated_median_household_income_in_year(2007)
    assert_nil ep.estimated_median_household_income_in_year(2013)
  end



  def test_median_household_income_average
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 87635.4, ep.median_household_income_average
  end

  def test_median_household_income_average_with_nils
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,nil], 2007 => [85060,nil, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, nil],
                               2010 => [85450, 89615, 88099, nil],
                               2011 => [89615, 88099, nil], 2012 => [89615, nil], 2013 =>[nil]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 87056, ep.median_household_income_average
  end

  def test_children_in_poverty_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 0.039, ep.children_in_poverty_in_year(2007)
    assert_equal 0.044, ep.children_in_poverty_in_year(2008)
    assert_equal 0.047, ep.children_in_poverty_in_year(2009)
    assert_equal 0.057, ep.children_in_poverty_in_year(2010)
    assert_equal 0.059, ep.children_in_poverty_in_year(2011)
    assert_equal 0.064, ep.children_in_poverty_in_year(2012)
    assert_equal 0.048, ep.children_in_poverty_in_year(2013)
  end

  def test_children_in_poverty_in_year_raises_unknown_data_error
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_raises UnknownDataError do
      ep.children_in_poverty_in_year(2004)
    end
  end

  def test_children_in_poverty_in_year_with_nil_data
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => nil, 2009 => nil, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 0.039, ep.children_in_poverty_in_year(2007)
    assert_nil ep.children_in_poverty_in_year(2008)
    assert_nil ep.children_in_poverty_in_year(2009)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 0.04, ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    assert_equal 0.047, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
    refute_equal 701, ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    refute_equal 855, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_percentage_in_year(2015)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year_with_nil_data
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => nil, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_nil ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    assert_equal 0.047, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
    refute_equal 701, ep.free_or_reduced_price_lunch_percentage_in_year(2000)
    refute_equal 855, ep.free_or_reduced_price_lunch_percentage_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_number_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 701, ep.free_or_reduced_price_lunch_number_in_year(2000)
    assert_equal 855, ep.free_or_reduced_price_lunch_number_in_year(2001)
    refute_equal 0.04, ep.free_or_reduced_price_lunch_number_in_year(2000)
    refute_equal 0.047, ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_number_in_year_with_nil_data
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => nil}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 701, ep.free_or_reduced_price_lunch_number_in_year(2000)
    assert_nil ep.free_or_reduced_price_lunch_number_in_year(2001)
    refute_equal 0.04, ep.free_or_reduced_price_lunch_number_in_year(2000)
    refute_equal 0.047, ep.free_or_reduced_price_lunch_number_in_year(2001)
  end

  def test_free_or_reduced_price_lunch_number_in_year_raises_unknown_data_error
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => 855}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_number_in_year(2010)
    end
  end

  def test_title_i_in_year
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => nil}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 0.014, ep.title_i_in_year(2009)
    assert_equal 0.011, ep.title_i_in_year(2011)
    assert_equal 0.010, ep.title_i_in_year(2012)
    assert_equal 0.012, ep.title_i_in_year(2013)
    assert_equal 0.027, ep.title_i_in_year(2014)
  end

  def test_title_i_in_year_raises_unknown_data_error
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => nil}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => 0.011, 2012 => 0.01072, 2013 => 0.01246, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_raises UnknownDataError do
      ep.title_i_in_year(2010)
    end
  end

  def test_title_i_in_year_with_nil_data
    data = {:name => "ACADEMY 20",
            :median_household_income =>  {2005 => [85060], 2006 => [85060,85450], 2007 => [85060,85450, 88099],
                               2008 => [85060, 85450, 89615, 88099], 2009 => [85060,85450, 89615, 88099, 89953],
                               2010 => [85450, 89615, 88099, 89953],
                               2011 => [89615, 88099, 89953], 2012 => [89615, 89953], 2013 =>[89953]},
            :free_or_reduced_price_lunch =>
                            {2000 => {:percentage => 0.04, :total => 701},
                            2001 => {:percentage => 0.04714, :total => nil}},
            :children_in_poverty => {2007 => 0.039, 2008 => 0.04404, 2009 => 0.047, 2010 => 0.05754, 2011 => 0.059,
                            2012  =>  0.064, 2013  =>  0.048},
            :title_i => {2009 => 0.014, 2011 => nil, 2012 => 0.01072, 2013 => nil, 2014 => 0.0273}}
    ep = EconomicProfile.new(data)

    assert_equal 0.014, ep.title_i_in_year(2009)
    assert_nil ep.title_i_in_year(2011)
    assert_equal 0.010, ep.title_i_in_year(2012)
    assert_nil ep.title_i_in_year(2013)
    assert_equal 0.027, ep.title_i_in_year(2014)
  end

end
