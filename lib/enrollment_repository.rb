require './lib/data_by_year_parser'
require './lib/enrollment'
require './lib/union_merger'
require 'pry'

# Holds all enrollment instances
class EnrollmentRepository
  attr_reader :enrollments, :merger, :full_data
  def initialize
    @merger = UnionMerger.new
    # @full_data = []
  end

  def load_data(data_path_hash)
    loaded_data = []
    # if data_path_hash[:enrollment].keys.include?(:kindergarten)
    #   @data = kindergarten_data(data_path_hash)
    # end
    # binding.pry
    loaded_data << load_kindergarten_data(data_path_hash)
    loaded_data << load_hs_data(data_path_hash)
    # @merger.merge(@data, kinder_data) if !kinder_data.nil?

    loaded_data.compact!
    full_data_merged = merge_data(loaded_data)
    # @merger.merge(@data, hs_data) if !hs_data.nil?

    # elsif data_path_hash[:enrollment].keys.include?(:high_school_graduation)
    #   @data.merge(high_school_graduation_data(data_path_hash))
    # end
    create_enrollments(full_data_merged)
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
    kindergarten_data(data_path_hash) if data_path_hash[:enrollment].keys.include?(:kindergarten)
  end

  def load_hs_data(data_path_hash)
    high_school_graduation_data(data_path_hash) if data_path_hash[:enrollment].keys.include?(:high_school_graduation)
  end

  def kindergarten_data(data_path_hash)
    DataByYearParser.new(data_path_hash[:enrollment][:kindergarten]).format_kindergarten_data
  end

  def high_school_graduation_data(data_path_hash)
    DataByYearParser.new(data_path_hash[:enrollment][:high_school_graduation]).format_hs_graduation_data
  end

  def create_enrollments(full_data)
    @enrollments = full_data.map do |enroll_data|
      Enrollment.new(enroll_data)
    end
  end

  def find_by_name(district_name)
    @enrollments.select { |e| e.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    @enrollments.select { |e| e.name.include?(string.upcase) }
  end

  def district_names
    @enrollments.map(&:name)
  end
end
