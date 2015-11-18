require_relative "union_merger"
require_relative "economic_profile"
require_relative 'data_by_range_parser'
require_relative 'data_by_percent_parser'
require_relative 'data_by_lunch_parser'
require_relative 'data_by_year_parser'

class EconomicProfileRepository
  attr_reader :economic_profiles, :merger
  def initialize
    @merger = UnionMerger.new
    @economic_profiles = []
  end

  def load_data(data_path_hash)
    loaded_data = [load_median_household_income(data_path_hash),
                   load_children_in_poverty(data_path_hash),
                   load_free_or_reduced_price_lunch(data_path_hash),
                   load_title_i(data_path_hash)].compact
    full_data_merged = merge_data(loaded_data)
    create_economic_profiles!(full_data_merged)
    full_data_merged
  end

  def merge_data(loaded_data)
    full_data = []
    loaded_data.each do |data|
      full_data = @merger.merge(full_data, data) # if !data.nil?
    end
    full_data
  end

  def load_median_household_income(data_path_hash)
    if data_path_hash[:economic_profile].keys.include?(:median_household_income)
      median_household_income(data_path_hash)
    end
  end

  def median_household_income(data_path_hash)
    parser = DataByYearRangeParser.new(data_path_hash[:economic_profile][:median_household_income])
    parser.format_year_range_data
  end

  def load_children_in_poverty(data_path_hash)
    if data_path_hash[:economic_profile].keys.include?(:children_in_poverty)
      children_in_poverty(data_path_hash)
    end
  end

  def children_in_poverty(data_path_hash)
    parser = DataByPercentParser.new(data_path_hash[:economic_profile][:children_in_poverty])
    parser.format_poverty_data
  end

  def load_free_or_reduced_price_lunch(data_path_hash)
    if data_path_hash[:economic_profile].keys.include?(:free_or_reduced_price_lunch)
      free_or_reduced_price_lunch(data_path_hash)
    end
  end

  def free_or_reduced_price_lunch(data_path_hash)
    parser = DataByLunchParser.new(data_path_hash[:economic_profile][:free_or_reduced_price_lunch])
    parser.format_lunch_data
  end

  def load_title_i(data_path_hash)
    if data_path_hash[:economic_profile].keys.include?(:title_i)
      title_i(data_path_hash)
    end
  end

  def title_i(data_path_hash)
    parser = DataByYearParser.new(data_path_hash[:economic_profile][:title_i])
    parser.format_title_i_data
  end

  def find_by_name(district_name)
    economic_profiles.select { |ep| ep.name == district_name.upcase }[0]
  end

  def create_economic_profiles!(full_data)
    @economic_profiles = full_data.map do |enroll_data|
      EconomicProfile.new(enroll_data)
    end
  end

end
