require "./lib/district"
require './lib/kindergarten_csv_parser'
require 'pry'

class DistrictRepository
  def initialize
    @districts = {}
  end

  def load_data(data_path_hash)
    if data_path_hash.keys.include?(:kindergarten)
      @data = KindergartenParser.new(data_path_hash[:kindergarten]).parse
    end
  end

  def create_districts
    #create district object
    @data.each do |key, value|
      district = District.new({:name => key})
      @districts[key] = district
    end
    binding.pry
    @districts
  end



  def find_by_name(district_name)
  end
end

dr = DistrictRepository.new
dr.load_data(:kindergarten => "./test/fixtures/kindergarten_sample.csv")
dr.create_districts
