require 'io/console'
require 'pry'

require_relative 'Player'
require_relative 'Move'
require_relative 'Result'
require_relative 'Displayable'

# To do:

# You will be playing against # ROBOT NAME this round.
#   Hint: This robot loves to #{personality.}


























# Game Engine:
class RPSGame
  include Displayable
  
  def initialize
    system('clear')
    display_rules
    @human = Human.new
    # Maybe change computer each round?
    @computer = Computer.random_new
  end

  def play
    loop do
      set_point_limit
      
      result = nil
      loop do
        display_game_state
        
        choose_moves
        result = Result.new(human.move, computer.move)
        result.winner.increment_score unless result.tie?

        display_game_state
        puts result.announcement
        
        break if point_limit_met?
        continue_next_game
      end
      
      display_round_winner(result)
      break unless play_again?
      reset_scores
    end
    display_goodbye
  end

  private

  attr_reader :human, :computer, :point_limit

  def choose_moves
    [human, computer].each(&:choose_move)
  end

  def set_point_limit
    loop do
      puts "How many points would you like to play up to? (1-10)"
      limit = gets.chomp
      if ('1'..'10').include?(limit)
        @point_limit = limit.to_i 
        break
      else
        puts "Please enter a point limit between 1 and 10!"
      end
    end
  end

  def point_limit_met?
    [human.score, computer.score].include?(point_limit)
  end

  def continue_next_game
    puts "Press any key to continue:"
    STDIN.getch 
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    loop do
      answer = gets.chomp.downcase
      return answer == 'y' if ['y', 'n'].include?(answer)
      puts 'Sorry, your choice must be y or n.'
    end
  end

  def reset_scores
    [human, computer].each(&:reset_score)
  end
end

RPSGame.new.play
