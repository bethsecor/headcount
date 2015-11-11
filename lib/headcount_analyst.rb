

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_one, district_two)
    district_one_data = get_district_data(district_one).values.compact
    district_two_data = get_district_against_data(district_two).values.compact
    if validate_data(district_one_data) && validate_data(district_two_data)
      district_one_average = average(district_one_data)
      district_two_average = average(district_two_data)
      (district_one_average/district_two_average).round(6)
    else
      "Can't compute."
    end
  end

  def average(numbers)
    numbers.reduce(:+)/numbers.length
  end

  def validate_data(data)
    !data.empty?
  end

  def get_district_data(district)
    # binding.pry
    district_repo.find_by_name(district).enrollment.kindergarten_participation_by_year
  end

  def get_district_against_data(district)
    district_repo.find_by_name(district[:against]).enrollment.kindergarten_participation_by_year
  end

  def kindergarten_participation_rate_variation_trend(district_one, district_two)
    h_1 = get_district_data(district_one)
    h_2 = get_district_against_data(district_two)

    {2009: 0.45, 2012: 0.76}
    {2010: 0.45, 2012: 0.42}

    


  end

end
