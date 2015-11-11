require 'csv'

# This parses data from the Kindgergarten Enrollment CSV file
class DataByYearParser
  def initialize(path)
    @path = path
  end

  def parse
    data = {}
    csv_opener.each do |line|
      district_name = line[:location].upcase
      create_new_key_for_district(district_name, data)
      add_participation_data_by_year(district_name, data, line)
    end
    data
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def add_participation_data_by_year(dist_name, data, line)
    data[dist_name][line[:timeframe].to_i] = clean_participation(line[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end

  def format_kindergarten_data
    data = []
    parse.each do |key, value|
      data << { name: key, kindergarten_participation: value }
    end
    data
  end

  def format_hs_graduation_data
    data = []
    parse.each do |key, value|
      data << { name: key, high_school_graduation: value }
    end
    data
  end
end
