class Enrollment
  attr_reader :name, :kindergarten_participation
  def initialize(something)
    @name = something[:name]
    @kindergarten_participation = something[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_participation[year]
  end
end
