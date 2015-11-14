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
      truncate_to_three_digits(average(district_one_data) / average(district_two_data))
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
      truncate_to_three_digits(kindergarten_variation(name) / graduation_variation(name))
    end
  end

  def kindergarten_participation_correlates_with_high_school_graduation(dist_opts)
    if dist_opts[:for] == "STATEWIDE"
      correlation_for_all_districts
    elsif dist_opts[:across]
      correlation_for_multiple_districts?(dist_opts[:across])
    else
      correlation_for_single_district?(dist_opts[:for])
    end
  end

  def correlation_for_all_districts
    names = district_repo.district_names - ["COLORADO"]
    kindergarten_participation_correlates_with_high_school_graduation({:across => names})
  end

  def correlation_for_single_district?(district_name)
    number = kindergarten_participation_against_high_school_graduation(district_name)
    if !number.nil?
      number > 0.6 && number < 1.5
    else
      nil
    end
  end

  def correlation_for_multiple_districts?(dnames)
    info = dnames.map do |dist_name|
      kindergarten_participation_correlates_with_high_school_graduation(:for => dist_name)
    end
    info = info.compact
    (info.count(true) / info.length.to_f) > 0.7
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

  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

  # def truncate_hash_values(data)
  #   data.map { |k,v| [k,truncate_to_three_digits(v)] }.to_h
  # end
end
