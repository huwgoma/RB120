# Class Hypothesis:
class Player
  attr_accessor :name, :move

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    puts "What's your name?"
    n = ''
    loop do
      n = gets.chomp
      break unless n.strip.empty?
      puts "Your name can't be blank!"
    end
    self.name = n
  end

  def choose_move
    puts "Please choose rock, paper, or scissors:"
    choice = nil
    loop do
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Invalid input! Please choose rock, paper, or scissors."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Number 5'].sample
  end

  def choose_move
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']
  # What each hand value wins against
  WIN_CONS = { 'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper' }

  include Comparable

  def initialize(value)
    @value = value
  end

  def <=>(other_move)
    return 0 if value == other_move.value
    return 1 if WIN_CONS[value] == other_move.value
    -1
  end

  def to_s
    value
  end

  protected

  attr_reader :value
end

# Main Flow:
class RPSGame
  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome
    puts "Welcome to Rock Paper Scissors!"
  end

  def display_goodbye
    puts "Thanks for playing. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_result
    if human.move > computer.move
      puts "#{human.name} wins!"
    elsif human.move < computer.move
      puts "#{computer.name} wins!"
    else
      puts "It's a tie!"
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
      human.choose_move
      computer.choose_move
      display_moves
      display_result
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play

# What is the primary improvement of this new design?
# - Refactoring 'moves' into its own class (Move objects) allows us to write
#   more readable code within the orchestration engine
#   eg. human.move > computer.move is more readable, and is better separation of
#   concerns than having the logic for calculating move results within the
#   #display_result method.
