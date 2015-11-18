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
      nil
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
      ratios[k] = nil
    end
  end

  def dictionary
    {3 => :third_grade, 8 => :eighth_grade}
  end

  def top_statewide_test_year_over_year_growth(grade_subject_hash)
    check_for_input_error(grade_subject_hash)
    weights = grade_subject_hash.fetch(:weighting, {:math => 1/3.0, :reading  => 1/3.0, :writing  => 1/3.0})
    if grade_subject_hash.key?(:subject)
      growths = calculate_growth_for_single_subject(grade_subject_hash[:subject],
                                                    grade_subject_hash[:grade],
                                                    grade_subject_hash.fetch(:top, 1))
    elsif !grade_subject_hash.key?(:subject)
      calculate_growth_for_all_subjects(grade_subject_hash[:grade], weights)
    end
  end

  def calculate_weighted_yoy_growth(grade, district, weights)
    subject_diffs = [:math, :reading, :writing].map do |subj|
      subject_data = get_subject_data(district, subj, grade)
      unless subject_data.nil? || subject_data.compact.empty?
        r = calculate_differences(subject_data)
        r * weights[subj] unless r.nil?
      end
    end
    format_yoy_growth(district, subject_diffs)
  end

  def format_yoy_growth(district, subject_diffs)
    subject_diffs = subject_diffs.compact
    if subject_diffs
      [district, truncate_to_three_digits(subject_diffs.reduce(:+))]
    else
      [district, "N/A"]
    end
  end

  def calculate_growth_for_all_subjects(grade, weights)
    dist_calcs = []
    district_repo.district_names.each do |dist|
      diffs = calculate_weighted_yoy_growth(grade, dist, weights)
      dist_calcs << diffs unless diffs.last.nil?
    end
    format_yoy_growth_multi_subj(dist_calcs)
  end

  def format_yoy_growth_multi_subj(dist_calcs)
    result = dist_calcs.sort_by { |dist, data| data }.last.flatten
    [result[0], truncate_to_three_digits(result[1])]
  end

  def calculate_growth_for_single_subject(subject, grade, top)
    dist_calcs = []
    district_repo.district_names.each do |dist|
      subject_data = get_subject_data(dist, subject, grade)
      unless subject_data.nil?
        diffs = calculate_differences(subject_data)
        dist_calcs << [dist, truncate_to_three_digits(diffs)] unless diffs.nil?
      end
    end
    format_you_growth_single_subj(dist_calcs, top)
  end

  def format_you_growth_single_subj(dist_calcs, top)
    results = dist_calcs.sort_by { |dist, data| data }.reverse!.first(top)
    results = results.flatten if results.length == 1
    results
  end

  def get_subject_data(dist, subject, grade)
    grade_data = get_grade_data(dist, subject, grade)
    unless grade_data.nil?
      grade_data.map do |year, data|
        data[subject]
      end
    end
  end

  def get_grade_data(dist, subject, grade)
    d = district_repo.find_by_name(dist)
    d.statewide_test.grade_data[dictionary[grade]]
  end

  def calculate_differences(array, differences = [])
    unless array.empty? || array.all? { |elem| elem.nil? }
    final_arr = remove_nils_at_ends(array)
      if final_arr.compact.length >=2
        calculate_change_over_time(final_arr)
      end
    end
  end

  def calculate_change_over_time(final_arr)
    (final_arr.compact.last - final_arr.compact.first) / (final_arr.length - 1)
  end

  def remove_nils_at_ends(array)
    if array.last.nil?
      array.pop
      remove_nils_at_ends(array)
    elsif array.first.nil?
      array.shift
      remove_nils_at_ends(array)
    else
      array
    end
  end

  def check_for_input_error(grade_subject_hash)
    check_for_information_error(grade_subject_hash)
    check_for_data_error(grade_subject_hash)
  end

  def check_for_information_error(grade_subject_hash)
    unless grade_subject_hash.keys.include?(:grade)
      raise InsufficientInformationError,
      "A grade must be provided to answer this question"
    end
  end

  def check_for_data_error(grade_subject_hash)
    unless [3,8].any? do |valid_grade|
      grade_subject_hash[:grade] == valid_grade
      end
      raise UnknownDataError, "#{grade_subject_hash[:grade]} is not a known grade."
    end
  end

  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

end

class InsufficientInformationError < StandardError
end

class UnknownDataError < StandardError
end
