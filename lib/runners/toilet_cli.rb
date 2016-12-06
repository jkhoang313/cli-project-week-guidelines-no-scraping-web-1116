class ToiletCLI
  def call
    greet_user
    run
  end

  def greet_user
    puts "Welcome to the NYC Toilets App!"
    help
  end

  def run
    input = get_input_from_user
    if input == "Help"
      help
    elsif input == "Exit"
      exit
    elsif input == "Borough"
      borough = get_borough_from_user
      search(borough)
      run
    elsif input == "Find"
      borough = get_borough_from_user
      matches = get_data(borough)

      coordinates = get_address_coordinates
      closest = find_closest_toilets(coordinates, matches)
      present_data([closest])
      run
    else
      puts "Invalid command."
      run
    end
  end

  def get_input_from_user
    puts "\nWhat command would you like to do?"
    gets.strip.capitalize
  end

  def help
    puts "Type 'exit' to exit."
    puts "Type 'help' to view this menu again."
    puts "Type 'borough' to search by borough."
    puts "Type 'find' to find the closest toilet."
    run
  end

  def get_borough_from_user
    puts "Type the name of the borough you want to search."
    gets.strip.capitalize
  end

  def search(input)
    matches = get_data(input)
    if matches.empty?
      puts "Borough not found."
    else
      present_data(matches)
    end
  end

  def get_data(input)
    ToiletDirectoryAdapter.new(input).make_instances
  end

  def get_address_coordinates
    puts "What is your current address?"
    address = gets.strip
    Geocoder.search(address).first.geometry["location"]
  end

  def find_closest_toilets(coordinates, matches)
    non_nil = matches.select do |match|
      match.location != nil
    end

    non_nil_2 = non_nil[0..19].select do |match|
      !Geocoder.search(match.location).empty?
    end

    toilets = non_nil_2.each do |match|
      location = match.location
      if !Geocoder.search(location).empty?
      #   Geocoder.search(location).first.geometry["location"]
        match.coordinates = (Geocoder.search(location).first.geometry["location"])
      end
    end

    compare_distance(coordinates, toilets.compact)
  end

  def compare_distance(current_coordinates, toilet_array)
    array = toilet_array.collect do |toilet_coordinates|
      lat = current_coordinates["lat"]
      lng = current_coordinates["lng"]
      toilet_lat = toilet_coordinates.coordinates["lat"]
      toilet_lng = toilet_coordinates.coordinates["lng"]
      lat_difference = lat - toilet_lat
      lng_difference = lng - toilet_lng
      sum = lat_difference.abs + lng_difference.abs
    end

    closest_index = array.index(array.min)

    toilet_array[closest_index]
  end

  def present_data(matches)
    matches.each do |toilet|
      puts "Name: #{toilet.name}"
      puts "  Location: #{toilet.location}"
      puts "  Open Year Round?: #{toilet.open_year_round}"
      puts "-----------------------"
    end
  end
end
