require_relative 'statewide_test'
require_relative 'csap_data_merger'
require_relative 'grade_data_merger'
require_relative 'union_merger'
require 'pry'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @merger = UnionMerger.new
    @statewide_tests = []
  end

  def load_data(data_path_hash)
    loaded_data = [load_csap_data(data_path_hash),
                   load_grade_data(data_path_hash)].compact

    # grade_data = load_grade_data(data_path_hash)
    # csap_data =  load_csap_data(data_path_hash)
    # if grade_data.nil?
    #   merged_loaded_data = csap_data
    # elsif csap_data.nil?
    #   merged_loaded_data = grade_data
    # else
    #   loaded_data = csap_data + grade_data
    #   merged_loaded_data = loaded_data.group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge) }
    # end
    merged_loaded_data = merge_data(loaded_data)
    # merged_loaded_data = loaded_data.group_by { |hash| hash[:name] }.map { |dist_name, dist_hashes| dist_hashes.reduce(:merge) }
    create_statewide_tests!(merged_loaded_data)
  end

  def load_csap_data(data_path_hash)
    path_keys = data_path_hash[:statewide_testing].keys
    if [:math, :reading, :writing].all? { |s| path_keys.include? s }
      CSAPDataMerger.new(data_path_hash).merge_csap_data
    end
  end

  def load_grade_data(data_path_hash)
    path_keys = data_path_hash[:statewide_testing].keys
    if path_keys.include?(:third_grade) && path_keys.include?(:eighth_grade)
      GradeDataMerger.new(data_path_hash).merge_grade_data
    end
  end

  def merge_data(loaded_data)
    full_data = []
    loaded_data.each do |data|
      full_data = @merger.merge(full_data, data) # if !data.nil?
    end
    full_data
  end

  def create_statewide_tests!(full_data)
    @statewide_tests = full_data.map do |test_data|
      StatewideTest.new(test_data)
    end
  end

  def find_by_name(district_name)
    statewide_tests.select { |e| e.name == district_name.upcase }[0]
  end

  def find_all_matching(string)
    statewide_tests.select { |e| e.name.include?(string.upcase) }
  end

  def district_names
    statewide_tests.map(&:name)
  end

end
