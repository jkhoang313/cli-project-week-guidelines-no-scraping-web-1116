require 'pry'

class ToiletDirectoryAdapter
  attr_reader :input, :toilet_array

  def initialize(input)
    @input = input
    @toilet_array = JSON.parse(RestClient.get("https://data.cityofnewyork.us/resource/r27e-u3sy.json"))
  end

  def fetch_matches
    puts "Fetching all the toilets in #{input}."
    toilet_array.select do |toilet|
      toilet["borough"] == input
    end
  end

  def make_instances
    fetch_matches.collect do |toilet|
      Toilet.new(toilet["location"], toilet["name"], toilet["open_year_round"])
    end
  end
end
