require 'csv'

# This parses data from the Kindgergarten Enrollment CSV file
class DataByYearRangeParser
  def initialize(path)
    @path = path
  end

  def parse
    data = {}
    csv_opener.each do |line|
      district_name = line[:location].upcase
      create_new_key_for_district(district_name, data)
      date_range = line[:timeframe].split("-").map(&:to_i)
      full_range = Range.new(date_range[0],date_range[1]).to_a
      create_new_key_for_years(district_name, full_range, data, line)

      # add_participation_data_by_year(district_name, data, line)
    end
    data
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def create_new_key_for_years(dist_name, range, data, line)
    range.each do |year|
      if data[dist_name].key?(year)
        data[dist_name][year] += [clean_participation(line[:data])]
      else
        data[dist_name][year] = [clean_participation(line[:data])]
      end
    end
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_i > 0
  end

  # def format_kindergarten_data
  #   parse.map do |key, value|
  #     { name: key,
  #       kindergarten_participation: Hash[value.sort_by { |year, prct| year}] }
  #     end
  # end

end
