require './lib/data_by_year_parser'
require './lib/enrollment'
require './lib/union_merger'
require 'pry'

# Holds all enrollment instances
class EnrollmentRepository
  attr_reader :enrollments, :merger
  def initialize
    @merger = UnionMerger.new
    @enrollments = []
  end

  def load_data(data_path_hash)
    loaded_data = [load_kindergarten_data(data_path_hash),
                   load_hs_data(data_path_hash)].compact
    full_data_merged = merge_data(loaded_data)
    create_enrollments!(full_data_merged)
    full_data_merged
  end

  def merge_data(loaded_data)
    full_data = []
    loaded_data.each do |data|
      full_data = @merger.merge(full_data, data) # if !data.nil?
    end
    full_data
  end

  def load_kindergarten_data(data_path_hash)
    if data_path_hash[:enrollment].keys.include?(:kindergarten)
      kindergarten_data(data_path_hash)
    end
  end

  def load_hs_data(data_path_hash)
    if data_path_hash[:enrollment].keys.include?(:high_school_graduation)
      high_school_graduation_data(data_path_hash)
    end
  end

  def kindergarten_data(data_path)
    kd = DataByYearParser.new(data_path[:enrollment][:kindergarten])
    kd.format_kindergarten_data
  end

  def high_school_graduation_data(data_path)
    hs = DataByYearParser.new(data_path[:enrollment][:high_school_graduation])
    hs.format_hs_graduation_data
  end

  def create_enrollments!(full_data)
    @enrollments = full_data.map do |enroll_data|
      Enrollment.new(enroll_data)
    end
  end

  def find_by_name(district_name)
    enrollments.select { |e| e.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    enrollments.select { |e| e.name.include?(string.upcase) }
  end

  def district_names
    enrollments.map(&:name)
  end
end
