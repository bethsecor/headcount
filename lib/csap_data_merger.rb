require './lib/data_by_race_ethnicity_parser'

class CSAPDataMerger
  def math_data
    DataByRaceEthnicityParser.new(path, :math)
  end

  def reading_data
    DataByRaceEthnicityParser.new(path, :reading)
  end

  def writing_data
    DataByRaceEthnicityParser.new(path, :writing)
  end

  def deep_merge(h1, h2)
    h1.merge(h2) { |key, h1_elem, h2_elem| deep_merge(h1_elem, h2_elem) }
  end

  def merge_csap_data
    district_names.map do |district|
      {:name => district, :csap_data => deep_merge(deep_merge(math_data[district], reading_data[district]),writing_data[district])}
    end
  end
end
