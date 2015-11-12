# Analyzes data from district repository
class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_one, district_two)
    district_one_data = get_district_data(district_one).values.compact
    district_two_data = get_district_against_data(district_two).values.compact
    if validate_data(district_one_data) && validate_data(district_two_data)
      (average(district_one_data) / average(district_two_data)).round(2)
    else
      "Can't compute."
    end
  end

  def average(numbers)
    numbers.reduce(:+) / numbers.length
  end

  def validate_data(data)
    !data.empty?
  end

  def get_district_data(district_name)
    district = district_repo.find_by_name(district_name)
    district.enrollment.kindergarten_participation_by_year
  end

  def get_district_against_data(district_name)
    district = district_repo.find_by_name(district_name[:against])
    district.enrollment.kindergarten_participation_by_year
  end

  def kindergarten_participation_rate_variation_trend(d_one, d_two)
    h_1 = get_district_data(d_one)
    h_2 = get_district_against_data(d_two)

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
    ratios[k] = (data_1[k] / data_2[k]).round(2)
  end
end
