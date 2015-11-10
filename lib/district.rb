class District
  attr_reader :name

  def initialize(name_hash)
    @name = name_hash[:name]
  end
end
