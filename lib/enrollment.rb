# Holds all enrollment data for a given district
class Enrollment
  attr_reader :name, :kindergarten_participation
  def initialize(enroll_data)
    @name = enroll_data[:name]
    @kindergarten_participation = enroll_data[:kindergarten_participation]
    @high_school_graduation = enroll_data[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    truncate_hash_values(kindergarten_participation)
  end

  def kindergarten_participation_in_year(year)
    truncate_to_three_digits(kindergarten_participation[year])
  end

  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

  def truncate_hash_values(data)
    data.map { |k,v| [k,truncate_to_three_digits(v)] }.to_h
  end
end
