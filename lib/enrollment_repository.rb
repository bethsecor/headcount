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
    # {:enrollment => { :kindergarten => "./test/fixtures/kindergarten_sample.csv" } }
    loaded_data = [load_kindergarten_data(data_path_hash),
                   load_hs_data(data_path_hash)].compact

    full_data_merged = merge_data(loaded_data)

    create_enrollments!(full_data_merged)
    full_data_merged
  end

  def merge_data(loaded_data)
    # [kindergarten data , hs data]
    # [[{:name => "Pizza", :kindergarten_participation => {}}],
    #  [{:name => "pizza", :hs_participation => {}}]
    # ]
    # have information relevant to the same districts in each collection
    # need to:
    #   1. collect/group those things together by districts
    #   2. merge them back together into a single hash for that district
    # Alternative:
    # (kinder_data + hs_data).group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge) }
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

  def create_enrollments!(full_data)
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
