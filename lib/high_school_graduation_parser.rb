class HighSchoolGraduationParser

  def initialize(path)
    @path = path
  end

  def parse
    high_school_graduation = {}
    csv_opener.each do |line|
      district_name = line[:location].upcase
      create_new_key_for_district(district_name, high_school_graduation)
      add_participation_data_by_year(district_name, high_school_graduation, line)
    end
    high_school_graduation
  end


end
