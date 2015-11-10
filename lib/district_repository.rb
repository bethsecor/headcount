require "./lib/district"
require './lib/kindergarten_csv_parser'
require 'pry'

class DistrictRepository
  # def initialize
  #   @districts = []
  # end

  # def load_data(data_path_hash)
  #   if data_path_hash.keys.include?(:kindergarten)
  #     @data = KindergartenParser.new(data_path_hash[:kindergarten]).parse
  #   end
  # end

  def load_data(data_path_hash)
    if data_path_hash.keys.include?(:enrollment)
      e = EnrollmentRepository.new
      e.load_data(data_path_hash)
      enrollment_district_names = e.district_names
      #other stuff to go here for other repos
      @district_names = enrollment_district_names
      # create instance of enrollment repo and have it load that data
      # @data = KindergartenParser.new(data_path_hash[:kindergarten]).parse
      create_districts
    end
  end

  def create_districts
    @districts = @district_names.map do |district|
      district = District.new({:name => district})
    end
  end



  def find_by_name(district_name)
  end
end

dr = DistrictRepository.new
dr.load_data(:kindergarten => "./test/fixtures/kindergarten_sample.csv")
dr.create_districts
