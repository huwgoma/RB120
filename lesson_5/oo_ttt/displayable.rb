# Namespace for display-related methods of TTTGame
module Displayable
  def clear
    system('clear')
  end

  def display_welcome
    clear
    puts "Welcome to Tic Tac Toe!"
  end

  def display_gamestate
    # Display Header (Hugo (X): 0, Computer(O): 0)
    board.draw
  end

  def display_result
    case board.detect_winner(current_player.marker)
    when human.marker    then puts 'You won!'
    when computer.marker then puts 'Computer won!'
    else                      puts "It's a tie!"
    end
  end

  def display_goodbye
    puts "Thanks for playing - goodbye!"
  end
end