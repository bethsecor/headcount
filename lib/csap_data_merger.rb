require_relative 'data_by_race_ethnicity_parser'

class CSAPDataMerger
  attr_reader :full_path_hash

  def initialize(full_path_hash)
    @full_path_hash = full_path_hash
  end

  def math_data
    if full_path_hash[:statewide_testing].keys.include?(:math)
      DataByRaceEthnicityParser.new(
        full_path_hash[:statewide_testing][:math], :math).parse
    end
  end

  def reading_data
    if full_path_hash[:statewide_testing].keys.include?(:reading)
      DataByRaceEthnicityParser.new(
        full_path_hash[:statewide_testing][:reading], :reading).parse
    end
  end

  def writing_data
    if full_path_hash[:statewide_testing].keys.include?(:writing)
      DataByRaceEthnicityParser.new(
        full_path_hash[:statewide_testing][:writing], :writing).parse
    end
  end

  def deep_merge(h_1, h_2)
    h_1.merge(h_2) { |key, h_1_elem, h_2_elem| deep_merge(h_1_elem, h_2_elem) }
  end

  def district_names
    [math_data.keys + reading_data.keys + writing_data.keys].flatten.uniq
  end

  def merge_csap_data
    puts "MEERGE CSAP DATA"
    # district_names.map do |district|
    #   {:name => district,
    #    :csap_data => deep_merge(deep_merge(math_data[district],
    #     reading_data[district]),writing_data[district])}
    # end
    district_names.map do |district|
      {:name => district,
       :csap_data => {:math_data => math_data[district], :reading_data =>
        reading_data[district], :writing_data => writing_data[district]}}
    end
  end
end
