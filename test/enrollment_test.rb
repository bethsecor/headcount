require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test
  def test_enrollment_object_has_a_name
    data = {:name => "ACADEMY 20",:kindergarten_participation => {"2007" => "0.39159", "2006" => "0.35364"}}
    e = Enrollment.new(data)
    puts e.inspect
    assert_equal "ACADEMY 20", e.name
    puts e.name
  end
end
