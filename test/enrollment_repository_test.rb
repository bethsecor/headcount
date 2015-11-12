require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_load_kindergarten_data
    e = EnrollmentRepository.new
    # actual = e.load_data({
    actual = e.load_kindergarten_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    expected = [{:name => "COLORADO", :kindergarten_participation => { 2006 => 0.33677, 2007 => 0.39465 }},
                {:name => "ACADEMY 20",:kindergarten_participation => { 2006 => nil, 2007 => 0.39159 }}]
    assert_equal expected, actual
  end

  # Plan moving forward:
  # separate out load data methods (see load_kindergarten_data above)
  # merge hashes by district name

  def test_load_high_school_grad_data
    skip
    e = EnrollmentRepository.new
    actual = e.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_grad_sample.csv"
      }
    })
    expected = [{:name => "ACADEMY 20", :high_school_graduation => { 2010 => 0.895, 2011 => 0.895 }},
                {:name => "ADAMS COUNTY 14",:high_school_graduation => { 2010 => 0.57, 2011 => 0.608 }},
                {:name => "ADAMS-ARAPAHOE 28J", :high_school_graduation => { 2010 => 0.455, 2011 => 0.485 }}]
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

  def test_find_by_downcase_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample.csv"
      }
    })
    e = er.find_by_name("academy 20")
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

  def test_find_all_matching_downcase_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarten_sample_2.csv"
      }
    })
    e = er.find_all_matching("academy")
    assert_equal 2, e.count
    assert_equal "ACADEMY 20", e[0].name
    assert_equal "ACADEMY 100", e[1].name
  end
end
