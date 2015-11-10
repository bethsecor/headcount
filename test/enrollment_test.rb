require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_exists
    assert Enrollment
  end

  def test_enrollment_methods_exist
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => 0.35364}}
    e = Enrollment.new(data)
    assert e.respond_to?(:kindergarten_participation_by_year)
    assert e.respond_to?(:kindergarten_participation_in_year)
  end

  def test_enrollment_object_has_a_name
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => 0.35364}}
    e = Enrollment.new(data)
    puts e.inspect
    assert_equal "ACADEMY 20", e.name
    puts e.name
  end

  def test_kindergarten_participation_by_year
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => 0.35364}}
    e = Enrollment.new(data)
    expected = {2007 => 0.39159, 2006 => 0.35364}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    data = {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => 0.35364}}
    e = Enrollment.new(data)
    expected = 0.39159
    assert_equal expected, e.kindergarten_participation_in_year(2007)
  end

end
