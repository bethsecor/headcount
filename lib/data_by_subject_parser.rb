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
      create_new_key_for_subject(district_name, subject, data)
      create_new_key_for_year(district_name, subject, data, line)
      add_subject_data_by_year(district_name, subject, data, line)
    end
    data
  end

  def csv_opener
    CSV.open(@path, headers: true, header_converters: :symbol)
  end

  def create_new_key_for_district(dist_name, data)
    data[dist_name] = {} unless data.key?(dist_name)
  end

  def create_new_key_for_subject(dist_name, subject, data)
    data[dist_name][subject] = {} unless data[dist_name].key?(subject)
  end

  def create_new_key_for_year(dist_name, subject, data, line)
    data[dist_name][subject][line[:timeframe].to_i] = {} unless data[dist_name][subject].key?(line[:timeframe].to_i)
  end

  def add_subject_data_by_year(dist_name, subject, data, line)
    data[dist_name][subject][line[:timeframe].to_i][subject] = clean_participation(line[:data])
  end

  def clean_participation(data)
    data.to_f if number?(data)
  end

  def number?(data)
    data == '0' || data.to_f > 0
  end
end
