require 'csv'
class CSAPDataParser
  def initialize(path)
    @path = path
  end

  def fuuuuuuuck_this
  math_csv = CSV.open(@path[:math], headers: true, header_converters: :symbol)
  reading_csv = CSV.open(@path[:reading], headers: true, header_converters: :symbol)
  writing_csv = CSV.open(@path[:writing], headers: true, header_converters: :symbol)

  all_csv_data = {:math => math_csv, :reading => reading_csv, :writing => writing_csv}

  data = {}
  all_csv_data.each do |subject, array_of_lines|
    array_of_lines.each do |line|
      district_name = line[:location].upcase
      race_ethnicity = line[:race_ethnicity].split("/").last.gsub(" ", "_")
      race_ethnicity = race_ethnicity.downcase.to_sym

      # data[district_name] = {} unless data.key?(district_name)
      #
      # unless data[district_name].key?(race_ethnicity)
      #   data[district_name][race_ethnicity] = {}
      # end
      #
      # unless data[district_name].key?(race_ethnicity)
      #   data[district_name][race_ethnicity] = {}
      # end
      #
      # unless data[district_name][race_ethnicity].key?(line[:timeframe].to_i)
      #   data[district_name][race_ethnicity][line[:timeframe].to_i] = {}
      # end
      #
      # year_key = data[district_name][race_ethnicity][line[:timeframe].to_i]
      # year_key[subject] = clean_participation(line[:data])
      
      create_new_key_for_district(district_name, data)
      create_new_key_for_race_ethnicity(district_name, race_ethnicity, data)
      create_new_key_for_year(district_name, race_ethnicity, data, line)
      add_race_ethnicity_data_by_year(district_name, race_ethnicity, data, line, subject)

      end
    end
    data
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
    fuuuuuuuck_this.map do |key, value|
        { name: key,
          csap_data: value }
      end
  end
end
