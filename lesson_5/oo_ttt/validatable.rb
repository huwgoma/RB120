# Module for all input loop/validation methods.
module Validatable
  def validate_input(criteria, error_message)
    loop do
      input = gets.chomp
      # Ideally, I would like to be able to allow the criteria (eg. criteria.include?)
      # to be specified by the caller. That way, I could also use this loop for the
      # player name validation, where the criteria is simply `unless name.empty?`.
      # (But I'm not sure how to do this)
      return input if criteria.include?(input)

      puts error_message
    end
  end


  # def choose_score_limit
  #   puts 'How many wins would you like to play up to? (1-10)'

  #   validate_input(('1'..'10'), 'Please enter a number between 1 and 10!')
  #   loop do
  #     limit = gets.chomp.to_i
  #     return limit if (1..10).include?(limit)

  #     puts 'Invalid input - please enter a number between 1 and 10.'
  #   end
  # end

  def choose_first_player
    display_player_order_prompt
    valid_options = [1, 2, 3]
    
    loop do
      input = gets.chomp.to_i
      return input if valid_options.include?(input)
      puts "Invalid input! - Please enter #{valid_options.joinor(', ')}."
    end
  end

  def play_again?
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      return answer == 'y' if %w[y n].include?(answer)

      puts 'Sorry - please enter y or n.'
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

  def choose_move(valid_choices)
    puts "Choose an empty square (#{valid_choices.joinor(', ')}):"
    loop do
      num = gets.chomp.to_i
      return num if valid_choices.include?(num)

      puts "Sorry, that's not a valid choice."
    end
  end
end