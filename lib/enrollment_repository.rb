require './lib/kindergarten_csv_parser'
require './lib/enrollment'

class EnrollmentRepository
  def initialize
    @enrollments = []
  end

  def load_data(data_path_hash)
    if data_path_hash[:enrollment].keys.include?(:kindergarten)
      @data = KindergartenParser.new(data_path_hash[:enrollment][:kindergarten]).format
    end
  end

  def create_enrollments
    @data.map do |enroll_data|
      Enrollment.new(enroll_data)
    end
  end

  def find_by_name(name_string)
  end

end

er = EnrollmentRepository.new

er.load_data({
  :enrollment => {
    :kindergarten => "./test/fixtures/kindergarten_sample.csv"
  }
})

puts er.create_enrollments
