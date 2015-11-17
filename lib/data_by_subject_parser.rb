require 'csv'

class DataBySubjectParser
  attr_reader :grade
  def initialize(path, grade)
    @path = path
    @grade = grade
  end

  def parse
    data = {}
    csv_opener.each do |line|
      district_name = line[:location].upcase
      subject = line[:score].downcase.to_sym

      create_new_key_for_district(district_name, data)
      create_new_key_for_grade(district_name, grade, data)
      create_new_key_for_year(district_name, grade, line, data)
      create_new_key_for_subject(district_name, grade, line, data)
      add_year_data_by_subject(district_name, grade, line, data)
    end
    data
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def create_new_key_for_grade(dist_name, grade, data)
    data[dist_name][grade] = {} unless data[dist_name].key?(grade)
  end

  def create_new_key_for_year(dist_name, grade, line, data)
    unless data[dist_name][grade].key?(line[:timeframe].to_i)
      data[dist_name][grade][line[:timeframe].to_i] = {}
    end
  end

  def create_new_key_for_subject(dist_name, grade, line, data)
    year_key = data[dist_name][grade][line[:timeframe].to_i]
    unless year_key.key?(line[:score].downcase.to_sym)
      year_key[line[:score].downcase.to_sym] = {}
    end
  end

  def add_year_data_by_subject(dist_name, grade, line, data)
    year_key = data[dist_name][grade][line[:timeframe].to_i]
    year_key[line[:score].downcase.to_sym] = clean_participation(line[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end
end
