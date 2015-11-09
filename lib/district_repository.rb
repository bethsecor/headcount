require "./lib/district"

class DistrictRepository
  def initialize
    @districts = []
  end

  def load_data(data_path_hash)
    if data_path_hash.keys.include?(:kindergarten)
      kindergarten_data = KindergartenParser.new("./data/Kindergartners in full-day program.csv").parse
      #create district object
      kindergarten_data.each do |key, value|
        district = District.new({:name => key})
        @districts << district
      end
      @districts
    end
  end

  def find_by_name(district_name)
  end
end
