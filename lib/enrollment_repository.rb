# require './lib/kindergarten_parser'
require './lib/data_by_year_parser'
require './lib/enrollment'

# Holds all enrollment instances
class EnrollmentRepository
  attr_reader :enrollments

  def load_data(data_path_hash)
    if data_path_hash[:enrollment].keys.include?(:kindergarten)
      @data = kindergarten_data(data_path_hash)
    end
    create_enrollments
    @data
  end

  def kindergarten_data(data_path_hash)
    # KindergartenParser.new(data_path_hash[:enrollment][:kindergarten]).format
    DataByYearParser.new(data_path_hash[:enrollment][:kindergarten]).format_kindergarten_data

  end

  def create_enrollments
    @enrollments = @data.map do |enroll_data|
      Enrollment.new(enroll_data)
    end
  end

  def find_by_name(district_name)
    @enrollments.select { |e| e.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    @enrollments.select { |e| e.name.include?(string) }
  end

  def district_names
    @enrollments.map(&:name)
  end
end
