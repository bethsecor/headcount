require 'csv'

class KindergartenParser
  def initialize(path)
    @path = path
  end

  def parse
    kindergarten_data = {}
    csv = CSV.open(@path, headers: true, header_converters: :symbol)
    csv.each do |line|
      unless kindergarten_data.key?(line[:location])
        kindergarten_data[line[:location]] = {}
      end
      kindergarten_data[line[:location]][line[:timeframe]] = line[:data]
    end
    kindergarten_data
  end
end

puts KindergartenParser.new("./data/Kindergartners in full-day program.csv").parse
