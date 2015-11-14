require './lib/district'
require './lib/enrollment_repository'
require './lib/statewide_test_repository'
require 'pry'

# Holds all district instances
class DistrictRepository
  attr_reader :district_names, :districts, :er, :str
  def initialize
    @district_names = []
  end

  def load_data(data_path_hash)
    send_enrollment_data(data_path_hash) if data_path_hash.keys.include?(:enrollment)
    send_statewide_test_data(data_path_hash) if data_path_hash.keys.include?(:statewide_testing)
    @district_names = @district_names.flatten
    create_districts(data_path_hash)
    @district_names
  end

  def create_districts(data_path_hash)
    @districts = district_names.map do |district|
      # binding.pry
      District.new({ :name => district,:enrollment => get_enrollment_object(district, data_path_hash),:statewide_testing => get_statewide_test_object(district, data_path_hash)})
                     # :statewide_testing => get_statewide_test_object(district)
    end
  end

  def get_enrollment_object(district, data_path_hash)
    er.find_by_name(district) if data_path_hash.keys.include?(:enrollment)
  end

  def get_statewide_test_object(district, data_path_hash)
    str.find_by_name(district) if data_path_hash.keys.include?(:statewide_testing)
  end

  def find_by_name(district_name)
    @districts.select { |d| d.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    @districts.select { |d| d.name.include?(string.upcase) }
  end

  def send_enrollment_data(data_path_hash)
    # if data_path_hash.keys.include?(:enrollment)
      @er = EnrollmentRepository.new
      er.load_data(data_path_hash)
      @district_names << er.district_names
    # end
  end

  def send_statewide_test_data(data_path_hash)
    # binding.pry
    # if data_path_hash.keys.include?(:statewide_testing)
      @str = StatewideTestRepository.new
      str.load_data(data_path_hash)
      @district_names << str.district_names
    end
  # end
end
