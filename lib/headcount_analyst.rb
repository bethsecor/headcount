require 'pry'

# Analyzes data from district repository
class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_one, compare_opts)
    district_two = compare_opts[:against]
    district_one_data = get_kinder_district_data(district_one).values.compact
    district_two_data = get_kinder_district_data(district_two).values.compact
    calculate_rate_variation(district_one_data, district_two_data)
  end

  def hs_graduation_rate_variation(district_one, district_two)
    district_one_data = get_hs_district_data(district_one).values.compact
    district_two_data = get_hs_district_data(district_two).values.compact
    calculate_rate_variation(district_one_data, district_two_data)
  end

  def calculate_rate_variation(district_one_data, district_two_data)
    if validate_data(district_one_data) && validate_data(district_two_data)
      ratio_average = average(district_one_data) / average(district_two_data)
      truncate_to_three_digits(ratio_average)
    else
      nil # "Can't compute."
    end
  end

  def kindergarten_variation(name)
    kindergarten_participation_rate_variation(name, :against => "COLORADO")
  end

  def graduation_variation(name)
    hs_graduation_rate_variation(name, "COLORADO")
  end

  def kindergarten_participation_against_high_school_graduation(name)
    unless kindergarten_variation(name).nil? || graduation_variation(name).nil?
      ratio_average = kindergarten_variation(name) / graduation_variation(name)
      truncate_to_three_digits(ratio_average)
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(d_opts)
    if d_opts[:for] == "STATEWIDE"
      correlation_for_all_districts
    elsif d_opts[:across]
      correlation_for_multiple_districts?(d_opts[:across])
    else
      correlation_for_single_district?(d_opts[:for])
    end
  end

  def correlation_for_all_districts
    names = district_repo.district_names - ["COLORADO"]
    kindergarten_participation_correlates_with_high_school_graduation(
      {:across => names})
  end

  def correlation_for_multiple_districts?(dnames)
    info = dnames.map do |dist_name|
      kindergarten_participation_correlates_with_high_school_graduation(
        :for => dist_name)
    end
    info = info.compact
    (info.count(true) / info.length.to_f) > 0.7
  end

  def correlation_for_single_district?(d_name)
    number = kindergarten_participation_against_high_school_graduation(d_name)
    if !number.nil?
      number > 0.6 && number < 1.5
    else
      nil
    end
  end

  def average(numbers)
    numbers.reduce(:+) / numbers.length
  end

  def validate_data(data)
    !data.empty? && average(data) != 0
  end

  def get_kinder_district_data(district_name)
    district = district_repo.find_by_name(district_name)
    district.enrollment.kindergarten_participation
  end

  def get_kinder_district_against_data(district_name)
    district = district_repo.find_by_name(district_name[:against])
    district.enrollment.kindergarten_participation
  end

  def get_hs_district_data(district_name)
    district = district_repo.find_by_name(district_name)
    district.enrollment.high_school_graduation
  end

  def get_hs_district_against_data(district_name)
    district = district_repo.find_by_name(district_name[:against])
    district.enrollment.high_school_graduation
  end

  def kindergarten_participation_rate_variation_trend(d_one, d_two)
    h_1 = get_kinder_district_data(d_one)
    h_2 = get_kinder_district_against_data(d_two)

    ratios_by_year(h_1, h_2)
  end

  def ratios_by_year(data_1, data_2)
    ratios = {}
    data_1.each_key do |k|
      calculate_ratio(data_1, data_2, k, ratios) if data_2.key?(k)
    end
    ratios
  end

  def calculate_ratio(data_1, data_2, k, ratios)
    if !(data_1[k] == 0 || data_2[k] == 0)
      ratios[k] = truncate_to_three_digits(data_1[k] / data_2[k])
    else
      ratios[k] = nil # "Can't compute."
    end
  end

  def dictionary
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def top_statewide_test_year_over_year_growth(grade_subject_hash)
    check_for_input_error(grade_subject_hash)
    if grade_subject_hash.key?(:subject)
      growths = calculate_growth_for_single_subject(grade_subject_hash)
    else
      growths = calclate_weighted_yoy_growth(grade_subject_hash)
    end

    if grade_subject_hash.key?(:top)
      growths
    else
      growth_top = growths.map { |dist, num| num }.reduce(:+)
      [ growths.first.first, truncate_to_three_digits(growth_top) ]
    end
  end

  def calclate_weighted_yoy_growth(grade_subject_hash)
    weights = grade_subject_hash.fetch(:weighting, {:math => 1.0/3,
                                                    :reading => 1.0/3,
                                                    :writing => 1.0/3})
    [:math, :reading, :writing].map do |subj|
      sub_hash = {:subject => subj}
      dw = calculate_growth_for_single_subject(grade_subject_hash.merge(sub_hash)).map do |dist, num|
              # binding.pry
        [ dist, num * weights[subj] ]
      end
      dw.flatten
    end
  end

  # [["dist1", 0.3828], ["dist1", 0.3828], ["dist1", 0.3828]]

  def calculate_growth_for_single_subject(grade_subject_hash)
    dist_calcs = []
    district_repo.district_names.each do |dist|
    subject_data = get_subject_data(dist, grade_subject_hash)
    unless subject_data.nil?
      dist_calcs << [district_repo.find_by_name(dist).name,
                     calculate_differences(subject_data)]
    end
    end
    num_dists = grade_subject_hash.fetch(:top, 1)
    results = dist_calcs.sort_by { |dist, data| data }[-num_dists..-1].reverse!
    # results = results.flatten if results.length == 1
    results
  end

  def get_subject_data(dist, grade_subject_hash)
    unless get_grade_data(dist, grade_subject_hash).nil?
      get_grade_data(dist, grade_subject_hash).map do |year, data|
        data[grade_subject_hash[:subject]]
    end
    end
  end

  def get_grade_data(dist, grade_subject_hash)
    d = district_repo.find_by_name(dist)
    d.statewide_testing.grade_data[dictionary[grade_subject_hash[:grade]]]
  end

  def calculate_differences(array, differences = [])
    if array.length >=2
      differences << (array[-1] - array[-2])
      array.pop
      calculate_differences(array, differences)
    else
      truncate_to_three_digits(differences.reduce(:+) / differences.length)
    end
  end

  def check_for_input_error(grade_subject_hash)
    unless grade_subject_hash.keys.include?(:grade)
      raise InsufficientInformationError,
      "A grade must be provided to answer this question"
    end

    unless [3,8].any? do |valid_grade|
      grade_subject_hash[:grade] == valid_grade
    end
      raise UnknownDataError,
      "#{grade_subject_hash[:grade]} is not a known grade."
    end
  end

  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

  # def truncate_hash_values(data)
  #   data.map { |k,v| [k,truncate_to_three_digits(v)] }.to_h
  # end
end

class InsufficientInformationError < StandardError
end

class UnknownDataError < StandardError
end
