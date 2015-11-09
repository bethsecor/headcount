require 'csv'

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
      kindergarten_data[district_name][line[:timeframe]] = line[:data]
    end
    kindergarten_data
  end
end

# puts KindergartenParser.new("./data/Kindergartners in full-day program.csv").parse
