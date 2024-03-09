# Module for validating input in Promptable methods
module Validatable
  def validate_input(validator, error_message, *criteria)
    loop do
      input = gets.chomp
      return input if validator.call(input, *criteria)

      puts "Invalid input! #{error_message}"
    end
  end

  def valid_name?(name)
    !name.strip.empty?
  end

  def valid_member?(input, options)
    options.include?(input)
  end
end
