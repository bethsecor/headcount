require 'pry'
class EconomicProfile
  attr_reader :name, :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch, :title_i

  def initialize(economic_profile_data)
    @name                        = economic_profile_data[:name]
    @median_household_income     = economic_profile_data[:median_household_income]
    @children_in_poverty         = economic_profile_data[:children_in_poverty]
    @free_or_reduced_price_lunch = economic_profile_data[:free_or_reduced_price_lunch]
    @title_i                     = economic_profile_data[:title_i]
  end

  def estimated_median_household_income_in_year(year)
    if median_household_income.keys.first.is_a?(Array)
      incomes = median_income_with_array_input(year)
    else
      raise UnknownDataError unless (2005..2013).to_a.include?(year)
      incomes = median_household_income[year]
    end
      average_income(incomes)
  end

  def median_income_with_array_input(year)
    raise UnknownDataError unless median_household_income.keys.flatten.include?(year)
    incomes = median_household_income.map do |k,v|
      v if k.include?(year)
    end
  end

  def average_income(incomes)
    incomes.compact.reduce(:+) / incomes.compact.length.to_f unless incomes.nil? || incomes.compact.empty?
  end

  def median_household_income_average
    years = median_household_income.keys
    if years.first.is_a?(Array)
      incomes = median_household_income.values
    else
      incomes = years.map do |year|
        median_household_income[year]
      end
      incomes = incomes.flatten.uniq
    end
    average_income(incomes)
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError unless children_in_poverty.keys.flatten.include?(year)
    truncate_to_three_digits(children_in_poverty[year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless free_or_reduced_price_lunch.keys.flatten.include?(year)
    truncate_to_three_digits(free_or_reduced_price_lunch[year][:percentage])
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError unless free_or_reduced_price_lunch.keys.flatten.include?(year)
    free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError unless title_i.keys.flatten.include?(year)
    truncate_to_three_digits(title_i[year])
  end

  def truncate_to_three_digits(value)
    (value * 1_000).truncate.to_f / 1_000 unless value.nil?
  end
end

class UnknownDataError < StandardError
end
