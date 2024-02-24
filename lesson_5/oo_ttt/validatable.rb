# Module for validating input
module Validatable
  # Ideally, I would like to be able to allow the criteria method
      # (eg. criteria.include?) to be specified by the caller. 
      # That way, I could also use this loop for #choose_name, where the
      # criteria is simply `unless name.empty?`.
      # (But I'm not sure how to do this)

  # def validate_input(criteria, error_message)
  #   loop do
  #     input = gets.chomp.downcase
  #     return input if criteria.include?(input)

  #     puts "Invalid input - #{error_message}"
  #   end
  # end

  def validate_non_empty_input
    # Ensures input is not empty?
  end

  def validate_input(criteria, error_message)
    loop do
      input = gets.chomp
      return input if criteria.call(input)
      puts error_message
    end
  end

  def valid_name?(name)
    !(name.strip.empty?)
  end
end