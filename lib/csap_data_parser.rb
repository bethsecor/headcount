require 'csv'
class CSAPDataParser
  def initialize(path)
    @path = path
  end

  def parse
  data = {}
  get_csv_data.each do |subject, array_of_lines|
    array_of_lines.each do |line|
      district_name = line[:location].upcase
      race_ethnicity = line[:race_ethnicity].split("/").last.gsub(" ", "_").downcase.to_sym
      create_hash_data(district_name, race_ethnicity, data, line, subject)
      end
    end
    data
  end

  def get_csv_data
    math_csv = CSV.open(@path[:math], headers: true, header_converters: :symbol)
    reading_csv = CSV.open(@path[:reading], headers: true, header_converters: :symbol)
    writing_csv = CSV.open(@path[:writing], headers: true, header_converters: :symbol)
    {:math => math_csv, :reading => reading_csv, :writing => writing_csv}
  end

  def create_hash_data(district_name, race_ethnicity, data, line, subject)
    create_new_key_for_district(district_name, data)
    create_new_key_for_race_ethnicity(district_name, race_ethnicity, data)
    create_new_key_for_year(district_name, race_ethnicity, data, line)
    add_race_ethnicity_data_by_year(district_name, race_ethnicity, data, line, subject)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def create_new_key_for_race_ethnicity(dist_name, race_ethnicity, data)
    unless data[dist_name].key?(race_ethnicity)
      data[dist_name][race_ethnicity] = {}
    end
  end

  def create_new_key_for_year(dist_name, race_ethnicity, data, line)
    unless data[dist_name][race_ethnicity].key?(line[:timeframe].to_i)
      data[dist_name][race_ethnicity][line[:timeframe].to_i] = {}
    end
  end

  def add_race_ethnicity_data_by_year(dist_name, race_ethnicity, data, line, subject)
    year_key = data[dist_name][race_ethnicity][line[:timeframe].to_i]
    year_key[subject] = clean_participation(line[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end

  def read_and_format_csap
    parse.map do |key, value|
        { name: key,
          csap_data: value }
      end
  end
end
