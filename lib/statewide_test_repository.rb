require './lib/statewide_test'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = []
  end

  def load_data(data_path_hash)
    loaded_data = [load_csap_data(data_path_hash),
                   load_grade_data(data_path_hash)].compact

    create_statewide_tests!(loaded_data)
  end

  def load_csap_data(data_path_hash)
    CSAPDataMerger.new(data_path_hash).merge_csap_data
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
