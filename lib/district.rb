class District
  attr_reader :name, :enrollment

  def initialize(name_hash)
    @name = name_hash[:name]
    @enrollment = name_hash[:enrollment]
  end

end

# <District: hthtlahlrh3838 @name = "Academy", @enrollment =
#<Enrollment, @name = , @parti
