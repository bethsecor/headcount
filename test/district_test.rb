require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require './lib/enrollment'
require './lib/statewide_test'
require './lib/economic_profile'

class DistrictTest < Minitest::Test
  def test_district_name
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
    assert_nil d.enrollment
    assert_nil d.statewide_test
    assert_nil d.economic_profile
  end

  def test_enrollment
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159},
            :high_school_graduation => {2010 => 0.895, 2011 => 0.895}}
    e = Enrollment.new(data)
    d = District.new({:name => "ACADEMY 20", :enrollment => e})
    assert_equal e, d.enrollment
  end

  def test_statewide_test
    data = {:name => "ACADEMY 20",:csap_data=>
     {:all_students=>
       {2011=>{:math=>0.68, :reading=>0.83, :writing=>0.7192}, 2012=>{:math=>0.6894, :reading=>0.84585, :writing=>0.70593}},
      :asian=>
       {2011=>{:math=>0.8169, :reading=>0.8976, :writing=>0.8268}, 2012=>{:math=>0.8182, :reading=>0.89328, :writing=>0.8083}}}}
    st = StatewideTest.new(data)
    d = District.new({:name => "ACADEMY 20", :statewide_testing => st})
    assert_equal st, d.statewide_test
  end

  def test_economic_profile
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
    d = District.new({:name => "ACADEMY 20", :economic_profile => ep})
    assert_equal ep, d.economic_profile
  end
end
