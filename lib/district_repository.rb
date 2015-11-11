require './lib/district'
require './lib/kindergarten_parser'
require './lib/enrollment_repository'
require 'pry'

# Holds all district instances
class DistrictRepository
  attr_reader :district_names, :districts, :er
  def initialize
    @district_names = []
  end

  def load_data(data_path_hash)
    send_enrollment_data(data_path_hash)
    @district_names = @district_names.flatten
    create_districts
    @district_names
  end

  def create_districts
    @districts = district_names.map do |district|
      District.new({ :name => district,
                     :enrollment => get_enrollment_object(district) })
    end
  end

  def get_enrollment_object(district)
    er.find_by_name(district)
  end

  def find_by_name(district_name)
    @districts.select { |d| d.name == district_name.upcase }[0]
  end

  def send_enrollment_data(data_path_hash)
    if data_path_hash.keys.include?(:enrollment)
      @er = EnrollmentRepository.new
      er.load_data(data_path_hash)
      @district_names << er.district_names
    end
  end
end
