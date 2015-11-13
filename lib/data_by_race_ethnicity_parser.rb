require 'csv'

class DataByRaceEthnicityParser
  attr_reader :subject
  def initialize(path, subject)
    @path = path
    @subject = subject
  end

  def parse
    data = {}
    csv_opener.each do |line|
      district_name = line[:location].upcase
      ethnicity = line[:race_ethnicity].split("/").last.gsub(" ", "_").downcase.to_sym
      create_new_key_for_district(district_name, data)
      create_new_key_for_race_ethnicity(district_name, ethnicity, data)
      create_new_key_for_year(district_name, ethnicity, data, line)
      add_race_ethnicity_data_by_year(district_name, ethnicity, data, line)
    end
    data
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def create_new_key_for_race_ethnicity(dist_name, race_ethnicity, data)
    data[dist_name][race_ethnicity] = {} unless data[dist_name].key?(race_ethnicity)
  end

  def create_new_key_for_year(dist_name, race_ethnicity, data, line)
    data[dist_name][race_ethnicity][line[:timeframe].to_i] = {} unless data[dist_name][race_ethnicity].key?(line[:timeframe].to_i)
  end

  def add_race_ethnicity_data_by_year(dist_name, race_ethnicity, data, line)
    data[dist_name][race_ethnicity][line[:timeframe].to_i][subject] = clean_participation(line[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end

  def format_csap(data)
    data.map do |key, value|
        { name: key,
          csap_math: value }
      end
  end

end
