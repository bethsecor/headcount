require 'csv'

# This parses data from the Kindgergarten Enrollment CSV file
class DataByLunchParser
  def initialize(path)
    @path = path
  end

  def parse
    data = {}
    csv_opener.each do |line|
      next if line[:poverty_level] == "Eligible for Reduced Price Lunch" || line[:poverty_level] == "Eligible for Free Lunch"
      district_name = line[:location].upcase
      create_hash_data(district_name, data, line)
    end
    data
  end

  def create_hash_data(district_name, data, line)
    create_new_key_for_district(district_name, data)
    add_dates(district_name, data, line)
    add_lunch_data_by_year(district_name, data, line)
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def add_dates(dist_name, data, line)
    data[dist_name][line[:timeframe].to_i] = {} unless data[dist_name].key?(line[:timeframe].to_i)
  end

  def add_lunch_data_by_year(dist_name, data, line)
    if line[:dataformat] == "Percent"
      data[dist_name][line[:timeframe].to_i][:percentage] = clean_percent(line[:data])
    elsif line[:dataformat] == "Number"
      data[dist_name][line[:timeframe].to_i][:total] = clean_number(line[:data])
    end
  end

  def clean_percent(data)
    data.to_f if number?(data)
  end

  def clean_number(data)
    data.to_i if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end

  def format_lunch_data
    parse.map do |key, value|
      { name: key,
        free_or_reduced_price_lunch: Hash[value.sort_by { |year, prct| year}] }
      end
  end
end
