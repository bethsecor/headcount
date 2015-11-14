# Holds all enrollment data for a given district

class UnknownDataError < StandardError
end

class UnknownRaceError < StandardError
end

require 'pry'
class StatewideTest
  attr_reader :name, :csap_data, :grade_data
  def initialize(testing_data)
    @name = testing_data[:name]
    @csap_data = testing_data[:csap_data]
    @grade_data = testing_data[:grade_data]
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless [:asian, :black, :pacific_islander, :hispanic,
      :native_american, :two_or_more, :white, :all_students].include?(race)
    truncate_hash_values(csap_data[race])
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless [:math, :reading, :writing].include?(subject) && [:asian, :black,
      :pacific_islander, :hispanic, :native_american, :two_or_more, :white, :all_students].include?(race) &&
      [2011, 2012, 2013, 2014].include?(year)
      binding.pry
    truncate_to_three_digits(csap_data[race][year][subject])
  end

  #
  # def kindergarten_participation_by_year
  #   truncate_hash_values(kindergarten_participation)
  # end
  #
  # def kindergarten_participation_in_year(year)
  #   truncate_to_three_digits(kindergarten_participation[year])
  # end
  #
  # def graduation_rate_by_year
  #   truncate_hash_values(high_school_graduation)
  # end
  #
  # def graduation_rate_in_year(year)
  #   truncate_to_three_digits(high_school_graduation[year])
  # end
  #
  def truncate_to_three_digits(value)
    (value * 1000).truncate.to_f / 1000 unless value.nil?
  end

  def truncate_hash_values(data)
    data.map { |k,v| [k,v.map { |k2, v2| [k2, truncate_to_three_digits(v2)] }.to_h ] }.to_h
  end
end
