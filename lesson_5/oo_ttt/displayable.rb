# frozen_string_literal: true

# Namespace for display-related methods of TTTGame
module Displayable
  def clear
    system('clear')
  end

  def display_welcome
    clear
    puts 'Welcome to Tic Tac Toe!'
  end

  def display_rules
    grid_length = Board::GRID_LENGTH

    puts <<~RULES
      The rules of this game are as follows:
      You and the computer will take turns marking a #{grid_length}x#{grid_length} board.
      If you mark #{grid_length} consecutive squares, you win!\n
    RULES
  end

  def player_order_prompt
    <<~HEREDOC 
      Who should move first?
      [1]: You
      [2]: CPU
      [3]: You don't care (random)
    HEREDOC
  end

  def display_gamestate
    clear # ?
    puts "#{human} (#{human.marker}): #{human.score}"
    puts "#{computer} (#{computer.marker}): #{computer.score}"
    puts ' '
    board.draw
  end

  def display_post_game
    display_gamestate
    display_game_result(find_winner)
  end

  def display_game_result(winner)
    if winner
      puts "#{winner} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_round_result
    loser, winner = Player.list.minmax_by(&:score)
    puts "#{winner} wins, #{winner.score}-#{loser.score}!"
  end

  def display_goodbye
    puts 'Thanks for playing - goodbye!'
  end
end

# Add #joinor method to Array
class Array
  def joinor(separator = '', last_separator = 'or ')
    array = self.dup # Avoid caller mutation
    case array.size
    when 0..2 then array.join(last_separator)
    when (3..)
      last_item = array.pop
      "#{array.join(separator)}#{separator}#{last_separator}#{last_item}"
    end
  end
end