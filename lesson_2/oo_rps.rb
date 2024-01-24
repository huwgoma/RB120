# Problem Description
# RPS is a 2-player game where each player simultaneously chooses 1 of 3 possible
#   moves (Rock, Paper, or Scissors) to determine a 'winner'.
# Rock beats Scissors, Scissors beats Paper, and Paper beats Rock. If both 
#   players chose the same hand, it's a tie.

# Nouns/Verbs:
#   Player
#   - Choose (move)
#   Move? (R/P/S)   
#   
#   - Compare hands

# Class Hypothesis:
class Player
  attr_accessor :name, :type, :move

  def initialize(type = :human)
    @type = type
    @move = nil
    set_name
    # name? # move choice?
    # set state of each player to differentiate between human and computer
  end

  def set_name
    if human?
      puts "What's your name?"
      loop do
        n = gets.chomp
        next puts "Your name can't be blank!" if n.strip.empty?
        self.name = n
        break
      end
    else
      self.name = ['R2D2', 'Hal', 'Chappie', 'Number 5'].sample
    end
  end

  def human?
    type == :human
  end

  def choose_move
    if human?
      puts "Please choose rock, paper, or scissors:"
      choice = nil
      loop do
        choice = gets.chomp
        break if ['rock', 'paper', 'scissors'].include?(choice)
        puts "Invalid input! Please choose rock, paper, or scissors."
      end
      self.move = choice
    else
      self.move = ['rock', 'paper', 'scissors'].sample
    end
  end
end

class Move
  def initialize
    # @hand: rock/paper/scissors?
  end
end

# Main Flow:
class RPSGame
  attr_reader :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome
    puts "Welcome to Rock Paper Scissors!"
  end

  def display_goodbye
    puts "Thanks for playing. Goodbye!"
  end

  def display_result
    puts "#{human.name} chose #{human.move}; #{computer.name} chose #{computer.move}."

    case human.move
    when 'rock'
      puts "It's a tie!" if computer.move == 'rock'
      puts "#{human.name} won!" if computer.move == 'scissors'
      puts "#{computer.name} won!" if computer.move == 'paper'
    when 'paper'
      puts "It's a tie!" if computer.move == 'paper'
      puts "#{human.name} won!" if computer.move == 'rock'
      puts "#{computer.name} won!" if computer.move == 'scissors'
    when 'scissors'
      puts "It's a tie!" if computer.move == 'scissors'
      puts "#{human.name} won!" if computer.move == 'paper'
      puts "#{computer.name} won!" if computer.move == 'rock'
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    loop do
      answer = gets.chomp.downcase
      return answer == 'y' if ['y', 'n'].include?(answer)
      puts 'Sorry, your choice must be y or n.'
    end
  end

  def play
    display_welcome

    loop do
      human.choose_move # prompt for input
      computer.choose_move # randomly select from 3 - will need diff implementation
      #   depending on player type -> Set state in Player
      display_result
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play