require_relative 'validatable'
# Module for methods that involve prompting user for input
module Promptable
  include Validatable

  def choose_name
    puts "What's your name?"
    validator =->(name) { valid_name?(name) }
    error_message = "Your name can't be empty!"

    validate_input(validator, error_message).strip
  end

  def choose_game_limit
    puts 'How many games would you like to play? (1-10)'
    validator =->(limit, range) { valid_member?(limit, range) }
    error_message = 'Please pick a number between 1 and 10!'

    validate_input(validator, error_message, ('1'..'10')).to_i
  end

  def choose_move
    puts 'Would you like to (H)it or (S)tay?'

    validator =->(choice, moves) { valid_member?(choice.upcase, moves) }
    error_message = 'Please enter either H (hit) or S (stay)!'

    validate_input(validator, error_message, %w(H S)).upcase
  end

  def play_again?
    puts 'Do you want to play again? (Y/N)'

    validator =->(choice, answers) { valid_member?(choice.upcase, answers) }
    error_message = 'Please enter either Y or N!'

    validate_input(validator, error_message, %w(Y N)).upcase == 'Y'
  end

  def continue
    puts 'Press any key to continue:'
    STDIN.getch
  end
end