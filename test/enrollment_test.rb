require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    assert Enrollment
  end

  def test_enrollment_methods_exist
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159}}
    e = Enrollment.new(data)
    assert e.respond_to?(:kindergarten_participation_by_year)
    assert e.respond_to?(:kindergarten_participation_in_year)
  end

  def test_enrollment_object_has_a_name
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159}}
    e = Enrollment.new(data)
    assert_equal "ACADEMY 20", e.name
  end

  def test_kindergarten_participation_by_year
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159}}
    e = Enrollment.new(data)
    expected = {2006 => 0.353, 2007 => 0.391}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    data = {:name => "ACADEMY 20",
            :kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159}}
    e = Enrollment.new(data)
    expected = 0.391
    assert_equal expected, e.kindergarten_participation_in_year(2007)
  end

  def test_graduation_rate_by_year
    data = {:name => "ACADEMY 20",
            :kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159},
            :high_school_graduation => { 2010 => 0.48482, 2011 => 0.89538281 }}
    e = Enrollment.new(data)
    expected = { 2010 => 0.484, 2011 => 0.895 }
    assert_equal expected, e.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    data = {:name => "ACADEMY 20",
            :kindergarten_participation => {2006 => 0.35364, 2007 => 0.39159},
            :high_school_graduation => { 2010 => 0.48482, 2011 => 0.89538281 }}
    e = Enrollment.new(data)
    expected = 0.484
    assert_equal expected, e.graduation_rate_in_year(2010)
  end
end
