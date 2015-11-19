# Holds all enrollment data for a given district
class StatewideTest
  attr_reader :name, :csap_data, :grade_data

  def initialize(testing_data)
    @name       = testing_data[:name]
    @csap_data  = testing_data[:csap_data]
    @grade_data = testing_data[:grade_data]
  end

  def proficient_by_grade(grade)
    dictionary = {3 => :third_grade, 8 => :eighth_grade}
    raise UnknownDataError unless dictionary.keys.include?(grade)
    truncate_hash_values(grade_data[dictionary[grade]])
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless [:asian, :black, :pacific_islander, :hispanic,
      :native_american, :two_or_more, :white, :all_students].include?(race)
    truncate_hash_values(csap_data[race])
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless subject_and_year_are_both_valid(subject, year)
    result = proficient_by_grade(grade)[year][subject]
    result.nil? ? "N/A" : result
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless subject_race_and_year_are_all_valid(subject, race, year)
    truncate_to_three_digits(csap_data[race][year][subject])
  end

  def subject_and_year_are_both_valid(subject, year)
    [:math, :reading, :writing].include?(subject) &&
    [2008, 2009, 2010, 2011, 2012, 2013, 2014].include?(year)
  end

  def subject_race_and_year_are_all_valid(subject, race, year)
    [:math, :reading, :writing].include?(subject) &&
    [:asian, :black, :pacific_islander, :hispanic, :native_american,
     :two_or_more, :white, :all_students].include?(race) &&
    [2011, 2012, 2013, 2014].include?(year)
  end

  def truncate_to_three_digits(value)
    (value * 1_000).truncate.to_f / 1_000 unless value.nil?
  end

  def truncate_hash_values(data)
    result = data.map do |k, v|
      [k, v.map { |k_2,v_2| [k_2, truncate_to_three_digits(v_2)] }.to_h]
    end
    result.to_h
  end
end

class UnknownDataError < StandardError
end

class UnknownRaceError < StandardError
end
