# Holds all data for a given district
class District
  attr_reader :name, :enrollment

  def initialize(name_hash)
    @name = name_hash[:name]
    @enrollment = name_hash[:enrollment]
  end
end
