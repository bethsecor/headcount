require 'pry'
class EconomicProfile
  attr_reader :name, :median_household_income, :children_in_poverty, :free_or_reduced_price_lunch, :title_i

  def initialize(economic_profile_data)
    @name = economic_profile_data[:name]
    @median_household_income = economic_profile_data[:median_household_income]
    @children_in_poverty = economic_profile_data[:children_in_poverty]
    @free_or_reduced_price_lunch = economic_profile_data[:free_or_reduced_price_lunch]
    @title_i = economic_profile_data[:title_i]
  end

  def estimated_median_household_income_in_year(year)
    # :median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000},
    if median_household_income.keys.first.is_a?(Array)
      raise UnknownDataError unless median_household_income.keys.flatten.include?(year)
      incomes = median_household_income.map do |k,v|
        v if k.include?(year)
      end
    else
      raise UnknownDataError unless (2005..2013).to_a.include?(year)
      incomes = median_household_income[year]
    end
      incomes.compact.reduce(:+) / incomes.compact.length unless incomes.nil? || incomes.empty?
  end

  def median_household_income_average
    if median_household_income.keys.is_a?(Array)
      incomes = median_household_income.values
    else
      incomes = (2005..2013).to_a.map do |year|
        median_household_income[year]
      end
      incomes = incomes.flatten.uniq
    end
    incomes.reduce(:+) / incomes.length unless incomes.empty?
  end

  def children_in_poverty_in_year(year)
    # valid_years =(1995..2013).to_a - [1996, 1998]
    raise UnknownDataError unless children_in_poverty.keys.flatten.include?(year)
    children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError unless free_or_reduced_price_lunch.keys.flatten.include?(year)
    free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError unless free_or_reduced_price_lunch.keys.flatten.include?(year)
    free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError unless title_i.keys.flatten.include?(year)
    title_i[year]
  end
end

class UnknownDataError < StandardError
end
