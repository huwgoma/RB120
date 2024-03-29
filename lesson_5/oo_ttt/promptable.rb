# frozen_string_literal: true

# Module for methods that prompt user for input
module Promptable
  include Displayable
  include Validatable

  # Player Prompts
  def choose_name
    puts "What's your name?"

    validator = ->(name) { valid_name?(name) }
    error_message = "Your name can't be empty!"

    validate_input(validator, error_message)
  end

  def choose_marker(other_marker)
    display_marker_choice_prompt(other_marker)

    validator = ->(marker, cpu_marker) { valid_marker?(marker, cpu_marker) }
    error_message = "Your marker must be exactly 1 non-empty character, and
    cannot be #{other_marker} (that's the CPU's marker.)"

    validate_input(validator, error_message, other_marker).strip
  end

  def choose_move(empty_keys)
    puts "Choose an empty square (#{empty_keys.joinor(', ')}):"

    validator = ->(key, valid_keys) { valid_member?(key, valid_keys) }
    error_message = "That isn't an empty square!"

    validate_input(validator, error_message, empty_keys.map(&:to_s)).to_i
  end

  # Game Prompts
  def choose_score_limit
    puts 'How many wins would you like to play up to? (1-10)'

    validator = ->(limit, range) { valid_member?(limit, range) }
    error_message = 'Please enter a number between 1 and 10!'

    validate_input(validator, error_message, ('1'..'10')).to_i
  end

  def choose_first_player
    display_player_order_prompt

    valid_options = %w(1 2 3)
    validator = ->(choice, options) { valid_member?(choice, options) }
    error_message = "Please enter #{valid_options.joinor(', ')}!"

    validate_input(validator, error_message, valid_options).to_i
  end

  def continue
    puts 'Press any key to continue:'
    $stdin.getch
  end

  def play_again?
    puts 'Would you like to play again? (Y/N)'

    validator = ->(choice, options) { valid_member?(choice, options) }
    error_message = 'Please enter Y or N!'
    valid_choices = %w(y n Y N)

    validate_input(validator, error_message, valid_choices).downcase == 'y'
  end
end
