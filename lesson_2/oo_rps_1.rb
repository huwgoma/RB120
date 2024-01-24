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
      break if ['rock', 'paper', 'scissors'].include?(choice)
      puts "Invalid input! Please choose rock, paper, or scissors."
    end
    self.move = choice
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Number 5'].sample
  end

  def choose_move
    self.move = ['rock', 'paper', 'scissors'].sample
  end
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

# Compare this design with the previous design:
# Is this design (with Human/Computer subclasses) better? Why or why not?
#   - I think it is better, because it eliminates the repetitive conditional 
#     that was present with the single Player class (having to check if the type
#     was human or computer) 
# What is the primary improvement of the new design?
#   - Eliminating the need to check if the player type was a human or computer 
#     for multiple instance methods in the Player class
# What is the primary drawback of the new design?
#   - Method repetition? The Human and Computer classes share many of the same 
#     methods, with different implementations (but is this a drawback at all?)