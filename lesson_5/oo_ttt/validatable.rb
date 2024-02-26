# Module for validating input
module Validatable
  def validate_input(validator, error_message, *criteria)
    loop do
      input = gets.chomp
      return input if validator.call(input, *criteria)
      puts "Invalid Input - #{error_message}"
    end
  end

  # Generic check to see if an input is in a collection of 'valid' options
  def valid_member?(input, options)
    options.include?(input)
  end

  def valid_name?(name)
    !(name.strip.empty?)
  end

  def valid_marker?(marker, other_marker)
    marker.strip.size == 1 && marker != other_marker
  end


end