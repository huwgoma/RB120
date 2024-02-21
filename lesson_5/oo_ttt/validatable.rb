# Module for all input loop/validation methods.
module Validatable
  def set_score_limit
    puts 'How many wins would you like to play up to? (1-10)'
    
    loop do
      self.score_limit = gets.chomp.to_i
      break if (1..10).include?(score_limit)

      puts 'Invalid input - please enter a number between 1 and 10.'
    end
  end

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