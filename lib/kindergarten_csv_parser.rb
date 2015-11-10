require 'csv'
require 'pry'

class KindergartenParser
  def initialize(path)
    @path = path
  end

  def parse
    kindergarten_data = {}
    csv = CSV.open(@path, headers: true, header_converters: :symbol)
    csv.each do |line|
      district_name = line[:location].upcase
      unless kindergarten_data.key?(district_name)
        kindergarten_data[district_name] = {}
      end
      kindergarten_data[district_name][line[:timeframe].to_i] = clean_participation(line[:data])
    end
    kindergarten_data
  end

  def clean_participation(data)
    if number?(data)
      data.to_f
    else
      nil
    end
  end

  def number?(data)
    data == "0" || data.to_f > 0
  end

  def format
    kindergarten_data = []
      parse.each do |key, value|
      kindergarten_data << {name: key, kindergarten_participation: value}
    end
    kindergarten_data
  end
end

# puts KindergartenParser.new("./data/Kindergartners in full-day program.csv").format
