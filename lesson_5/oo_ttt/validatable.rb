# Module for validating input
module Validatable
  def validate_input(criteria, error_message)
    loop do
      input = gets.chomp.downcase
      # Ideally, I would like to be able to allow the criteria method
      # (eg. criteria.include?) to be specified by the caller. 
      # That way, I could also use this loop for #choose_name, where the
      # criteria is simply `unless name.empty?`.
      # (But I'm not sure how to do this - probably something involving Procs?)
      return input if criteria.include?(input)

      puts "Invalid input - #{error_message}"
    end
  end

  def choose_name
    puts "What's your name?"
    loop do
      name = gets.chomp.strip
      return name unless name.empty?

      puts "You can't have an empty name!"
    end
  end
end