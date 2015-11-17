require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'

# Holds all district instances
class DistrictRepository
  attr_reader :district_names, :districts, :er, :str
  def initialize
    @district_names = []
  end

  def load_data(data_path)
    puts "Loading data"
    send_enrollment_data(data_path) if data_path.keys.include?(:enrollment)
    if data_path.keys.include?(:statewide_testing)
      send_statewide_test_data(data_path)
    end
    @district_names = @district_names.flatten.uniq
    create_districts(data_path)
    @district_names
  end

  def create_districts(data_path)
    puts "Creating districts"
    @districts = district_names.map do |district|
      District.new({ :name => district,
        :enrollment => get_enrollment_object(district, data_path),
        :statewide_testing => get_statewide_test_object(district, data_path)})
    end
  end

  def get_enrollment_object(district, data_path)
    puts "Getting an enrollment object"
    er.find_by_name(district) if data_path.keys.include?(:enrollment)
  end

  def get_statewide_test_object(district, data_path)
    puts "Getting a statewide test object"
    str.find_by_name(district) if data_path.keys.include?(:statewide_testing)
  end

  def find_by_name(district_name)
    puts "Finding a district"
    @districts.select { |d| d.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    @districts.select { |d| d.name.include?(string.upcase) }
  end

  def send_enrollment_data(data_path_hash)
    puts "Sending enrollment data"
    # if data_path_hash.keys.include?(:enrollment)
      @er = EnrollmentRepository.new
      er.load_data(data_path_hash)
      @district_names << er.district_names
    # end
  end

  def send_statewide_test_data(data_path_hash)
    puts "Sending statewide data"
    # binding.pry
    # if data_path_hash.keys.include?(:statewide_testing)
      @str = StatewideTestRepository.new
      str.load_data(data_path_hash)
      @district_names << str.district_names
    end
  # end
end
