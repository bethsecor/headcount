# Holds all data for a given district
class District
  attr_reader :name, :enrollment, :statewide_test

  def initialize(name_hash)
    @name = name_hash[:name]
    @enrollment = name_hash[:enrollment]
    # change to statewide_testing?
    @statewide_test = name_hash[:statewide_testing]
  end
end
