require_relative 'data_by_subject_parser'
require 'pry'
class GradeDataMerger
  attr_reader :full_path_hash

  def initialize(full_path_hash)
    @full_path_hash = full_path_hash
  end

  def third_grade
    if full_path_hash[:statewide_testing].keys.include?(:third_grade)
      DataBySubjectParser.new(
      full_path_hash[:statewide_testing][:third_grade], :third_grade).parse
    end
  end

  def eighth_grade
    if full_path_hash[:statewide_testing].keys.include?(:eighth_grade)
      DataBySubjectParser.new(
      full_path_hash[:statewide_testing][:eighth_grade], :eighth_grade).parse
    end
  end

  def deep_merge(h_1, h_2)
    if h_2.nil?
      h_1
    elsif h_1.nil?
      h_2
    else
      h_1.merge(h_2) { |k, h_1_elem, h_2_elem| deep_merge(h_1_elem, h_2_elem) }
    end

  end

  def district_names
    [third_grade.keys + eighth_grade.keys].flatten.uniq
  end

  def merge_grade_data
    district_names.map do |district|
      {:name => district,
       :grade_data => deep_merge(third_grade[district], eighth_grade[district])}
    end
  end
end
