require './lib/kindergarten_csv_parser'
require './lib/enrollment'

class EnrollmentRepository
  attr_reader :enrollments
  # def initialize
  #   @enrollments = []
  # end

  def load_data(data_path_hash)
    if data_path_hash[:enrollment].keys.include?(:kindergarten)
      @data = KindergartenParser.new(data_path_hash[:enrollment][:kindergarten]).format
    end
    create_enrollments
    @data
  end

  def create_enrollments
    @enrollments = @data.map do |enroll_data|
      Enrollment.new(enroll_data)
    end
  end

  def find_by_name(district_name)
    @enrollments.select { |e| e.name == district_name }[0]
  end

  def find_all_matching(string)
    @enrollments.select { |e| e.name.include?(string) }
  end
end

er = EnrollmentRepository.new

puts er.load_data({
  :enrollment => {
    :kindergarten => "./test/fixtures/kindergarten_sample.csv"
  }
})

# puts er.create_enrollments
