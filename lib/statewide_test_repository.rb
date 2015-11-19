require_relative 'statewide_test'
require_relative 'csap_data_parser'
require_relative 'grade_data_parser'
require_relative 'union_merger'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @merger          = UnionMerger.new
    @statewide_tests = []
  end

  def load_data(data_path_hash)
    loaded_data = [load_csap_data(data_path_hash),
                   load_grade_data(data_path_hash)].compact
    merged_loaded_data = merge_data(loaded_data)
    create_statewide_tests!(merged_loaded_data)
  end

  def load_csap_data(data_path_hash)
    path_keys = data_path_hash[:statewide_testing].keys
    if data_includes_all_subjects(path_keys)
      CSAPDataParser.new(data_path_hash[:statewide_testing]).read_and_format_csap
    end
  end

  def load_grade_data(data_path_hash)
    path_keys = data_path_hash[:statewide_testing].keys
    if data_includes_third_and_eighth_grade(path_keys)
      GradeDataParser.new(data_path_hash[:statewide_testing]).read_and_format_grade
    end
  end

  def data_includes_third_and_eighth_grade(path_keys)
    path_keys.include?(:third_grade) && path_keys.include?(:eighth_grade)
  end

  def data_includes_all_subjects(path_keys)
    [:math, :reading, :writing].all? { |s| path_keys.include? s }
  end

  def merge_data(loaded_data)
    full_data = []
    loaded_data.each do |data|
      full_data = @merger.merge(full_data, data)
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
