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
    # elsif input == "Address"
    else
      puts "Invalid command."
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
    puts "Type 'address' to search by address."
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

  def present_data(matches)
    matches.each do |toilet|
      puts "Name: #{toilet.name}"
      puts "  Location: #{toilet.location}"
      puts "  Open Year Round?: #{toilet.open_year_round}"
      puts "-----------------------"
    end
  end
end
