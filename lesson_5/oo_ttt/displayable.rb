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
    clear
    puts "#{human} (#{human.marker}): <Score>"
    puts "#{computer} (#{computer.marker}): <CPUScore>"
    puts " "
    board.draw
  end

  def display_result
    case board.winning_marker
    when human.marker    then puts 'You won!'
    when computer.marker then puts 'Computer won!'
    else                      puts "It's a tie!"
    end
  end

  def display_goodbye
    puts "Thanks for playing - goodbye!"
  end
end