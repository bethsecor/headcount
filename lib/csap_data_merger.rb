require './lib/data_by_race_ethnicity_parser'
require 'pry'
class CSAPDataMerger
  attr_reader :full_path_hash

  def initialize(full_path_hash)
    @full_path_hash = full_path_hash
  end

  def math_data
    DataByRaceEthnicityParser.new(full_path_hash[:statewide_testing][:math], :math).parse
  end

  def reading_data
    DataByRaceEthnicityParser.new(full_path_hash[:statewide_testing][:reading], :reading).parse
  end

  def writing_data
    DataByRaceEthnicityParser.new(full_path_hash[:statewide_testing][:writing], :writing).parse
  end

  def deep_merge(h_1, h_2)
    h_1.merge(h_2) { |key, h_1_elem, h_2_elem| deep_merge(h_1_elem, h_2_elem) }
  end

  def district_names
    # binding.pry
    [math_data.keys + reading_data.keys + writing_data.keys].uniq
  end

  def merge_csap_data
    district_names.map do |district|
      {:name => district, :csap_data => deep_merge(deep_merge(math_data[district], reading_data[district]),writing_data[district])}
    end
  end
end
