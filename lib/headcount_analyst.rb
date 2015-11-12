# Analyzes data from district repository

require 'pry'
class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_one, district_two)
    district_one_data = get_kinder_district_data(district_one).values.compact
    district_two_data = get_kinder_district_against_data(district_two).values.compact
    calculate_rate_variation(district_one_data, district_two_data)
  end

  def hs_graduation_rate_variation(district_one, district_two)
    calculate_rate_variation(district_one, district_two)
    district_one_data = get_hs_district_data(district_one).values.compact
    district_two_data = get_hs_district_data(district_two).values.compact
    calculate_rate_variation(district_one_data, district_two_data)
  end


  def calculate_rate_variation(district_one_data, district_two_data)
    if validate_data(district_one_data) && validate_data(district_two_data)
      truncate_to_three_digits(average(district_one_data) / average(district_two_data))
    else
      "Can't compute."
    end
  end

  def kindergarten_variation(name)
    kindergarten_participation_rate_variation(name, :against => "COLORADO")
  end

  def graduation_variation(name)
    hs_graduation_rate_variation(name, "COLORADO")
  end

  def kindergarten_participation_against_high_school_graduation(name)
    truncate_to_three_digits(kindergarten_variation(name) / graduation_variation(name))
  end

  def average(numbers)
    numbers.reduce(:+) / numbers.length
  end

  def validate_data(data)
    !data.empty? && average(data) != 0
  end

  def get_kinder_district_data(district_name)
    district = district_repo.find_by_name(district_name)
    district.enrollment.kindergarten_participation_by_year
  end

  def get_kinder_district_against_data(district_name)
    district = district_repo.find_by_name(district_name[:against])
    district.enrollment.kindergarten_participation_by_year
  end

  def get_hs_district_data(district_name)
    district = district_repo.find_by_name(district_name)
    district.enrollment.hs_participation_rate_variation
  end

  def get_hs_district_against_data(district_name)
    district = district_repo.find_by_name(district_name[:against])
    district.enrollment.hs_participation_rate_variation
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
      ratios[k] = "Can't compute."
    end
  end

  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

  # def truncate_hash_values(data)
  #   data.map { |k,v| [k,truncate_to_three_digits(v)] }.to_h
  # end
end
