class Toilet
  attr_accessor :location, :name, :open_year_round, :rating

  def initialize(location, name, open_year_round)
    @location = location
    @name = name
    @open_year_round = open_year_round
  end
end
