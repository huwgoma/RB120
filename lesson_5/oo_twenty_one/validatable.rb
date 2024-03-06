# Module for validating input in Promptable methods
module Validatable
  def validate_input(validator, error_message, *criteria)
    loop do
      input = gets.chomp
      return input if validator.call(input, *criteria)

      puts "Invalid input! #{error_message}"
    end
  end
end