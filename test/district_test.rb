require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require './lib/enrollment'

class DistrictTest < Minitest::Test
  def test_district_name
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
    assert_nil d.enrollment
  end

  def test_enrollment
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159}}
    e = Enrollment.new(data)
    d = District.new({:name => "ACADEMY 20", :enrollment => e})
    assert_equal e, d.enrollment
  end
end
