require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_load_data
    e = EnrollmentRepository.new
    e.load_data()
  end

end
