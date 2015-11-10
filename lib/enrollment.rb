class Enrollment
  attr_reader :name, :kindergarten_participation
  def initialize(enroll_data)
    @name = enroll_data[:name]
    @kindergarten_participation = enroll_data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year]
  end
end
