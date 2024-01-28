require 'io/console'
require 'pry'

require_relative 'player'
require_relative 'move'
require_relative 'result'
require_relative 'displayable'

# Game Engine:
class RPSGame
  include Displayable

  def initialize
    system('clear')
    display_rules
    @human = Human.new
  end

  def play
    loop do
      @computer = Computer.random_new(human)
      introduce_computer
      set_point_limit

      loop do
        play_game

        break if point_limit_met?
        continue_next_game
      end

      display_round_winner(Result.history.last)
      break unless play_again?
      reset_round_state
    end
    display_goodbye
  end

  private

  attr_reader :human, :computer, :point_limit

  def play_game
    display_game_state

    choose_moves
    result = Result.new(human.move, computer.move)
    result.winner.increment_score unless result.tie?

    display_game_state
    result.announce
  end

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
    $stdin.getch
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    loop do
      answer = gets.chomp.downcase
      return answer == 'y' if ['y', 'n'].include?(answer)
      puts 'Sorry, your choice must be y or n.'
    end
  end

  def reset_round_state
    [human, computer].each(&:reset_score)
    Result.clear_history
  end
end

RPSGame.new.play
