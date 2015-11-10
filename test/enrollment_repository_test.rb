require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_load_data
    e = EnrollmentRepository.new
    actual = e.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    expected = [{:name => "COLORADO", :kindergarten_participation => {2007 => 0.39465, 2006 => 0.33677}},
                {:name => "ACADEMY 20",:kindergarten_participation => {2007 => 0.39159, 2006 => nil}}]
    assert_equal expected, actual
  end

  def test_creating_enrollments
    e = EnrollmentRepository.new
    e.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    assert e.enrollments.count > 1
  end

  def test_find_by_upcase_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    e = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", e.name
  end

  def test_find_all_matching_upcase_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_2.csv"
      }
    })
    e = er.find_all_matching("ACADEMY")
    assert_equal 2, e.count
    assert_equal "ACADEMY 20", e[0].name
    assert_equal "ACADEMY 100", e[1].name
  end



end
