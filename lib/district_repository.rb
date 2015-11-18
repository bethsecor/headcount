require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

# Holds all district instances
class DistrictRepository
  attr_reader :district_names, :districts, :er, :str, :epr
  def initialize
    @district_names = []
  end

  def load_data(data_path)
    send_enrollment_data(data_path) if data_path.keys.include?(:enrollment)
    if data_path.keys.include?(:statewide_testing)
      send_statewide_test_data(data_path)
    end
    if data_path.keys.include?(:economic_profile)
      send_economic_profile_data(data_path)
    end
    @district_names = @district_names.flatten.uniq
    create_districts(data_path)
    @district_names
  end

  def create_districts(data_path)
    @districts = district_names.map do |district|
      District.new({ :name => district,
        :enrollment => get_enrollment_object(district, data_path),
        :statewide_testing => get_statewide_test_object(district, data_path),
        :economic_profile => get_economic_profile_object(district, data_path)})
    end
  end

  def get_enrollment_object(district, data_path)
    er.find_by_name(district) if data_path.keys.include?(:enrollment)
  end

  def get_statewide_test_object(district, data_path)
    str.find_by_name(district) if data_path.keys.include?(:statewide_testing)
  end

  def get_economic_profile_object(district, data_path)
    epr.find_by_name(district) if data_path.keys.include?(:economic_profile)
  end

  def find_by_name(district_name)
    @districts.select { |d| d.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    @districts.select { |d| d.name.include?(string.upcase) }
  end

  def send_enrollment_data(data_path_hash)
    @er = EnrollmentRepository.new
    er.load_data(data_path_hash)
    @district_names << er.district_names
  end

  def send_statewide_test_data(data_path_hash)
    @str = StatewideTestRepository.new
    str.load_data(data_path_hash)
    @district_names << str.district_names
  end

  def send_economic_profile_data(data_path_hash)
    @epr = EconomicProfileRepository.new
    epr.load_data(data_path_hash)
    @district_names << epr.district_names
  end
end
