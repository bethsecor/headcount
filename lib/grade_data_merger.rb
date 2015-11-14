require './lib/data_by_subject_parser'
require 'pry'
class GradeDataMerger
  attr_reader :full_path_hash

  def initialize(full_path_hash)
    @full_path_hash = full_path_hash
  end

  def third_grade
    DataBySubjectParser.new(full_path_hash[:statewide_testing][:math], :math).parse if full_path_hash[:statewide_testing].keys.include?(:math)
  end

  def eighth_grade
    DataBySubjectParser.new(full_path_hash[:statewide_testing][:reading], :reading).parse if full_path_hash[:statewide_testing].keys.include?(:reading)
  end

  def deep_merge(h_1, h_2)
    h_1.merge(h_2) { |key, h_1_elem, h_2_elem| deep_merge(h_1_elem, h_2_elem) }
  end

  def district_names
    [math_data.keys + reading_data.keys + writing_data.keys].flatten.uniq
  end

  def merge_csap_data
    district_names.map do |district|
      {:name => district, :csap_data => deep_merge(deep_merge(math_data[district], reading_data[district]),writing_data[district])}
    end
  end
end
