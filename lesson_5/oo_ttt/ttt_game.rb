# frozen_string_literal: true

require 'pry'
require 'io/console'
require_relative 'board'
require_relative 'displayable'
require_relative 'validatable'
require_relative 'player'
require_relative 'square'

# To do:

# Allow player to pick any marker; what should the computer use?
# 
# Reorganize methods
# - Promptable? For any methods that require user input
# 'Set' vs. 'Choose'

# Re-examine TTTGame initialize





# Orchestration Engine for TTT Game
class TTTGame
  include Displayable
  include Validatable

  #MARKERS = %w[X O].freeze

  attr_reader :board, :human, :computer

  def initialize
    display_welcome
    display_rules
    @board = Board.new
    @computer = Computer.new(board)
    @human = Human.new(computer.marker)
    
  end


  def play
    # Program Loop
    loop do
      set_score_limit
      match_loop
      display_round_result
      break unless play_again?
      
      reset_round
    end
    display_goodbye
  end

  private

  attr_accessor :current_player, :score_limit

  def match_loop
    set_player_order
    loop do
      game_loop
      increment_score
      display_post_game

      break if round_over?
      
      switch_current_player
      board.reset
      continue
    end
  end

  def game_loop
    loop do
      display_gamestate
      mark_board(choose_key)
      display_gamestate

      break if board.full? || board.winner?
      
      switch_current_player
    end
  end

  def set_score_limit
    self.score_limit = choose_score_limit
  end

  def choose_score_limit
    puts 'How many wins would you like to play up to? (1-10)'

    validator = -> (limit, range) { valid_score_limit?(limit, range) }
    error_message = 'Please enter a number between 1 and 10!'

    validate_input(validator, error_message, ('1'..'10')).to_i
  end

  def increment_score
    find_winner.increment_score unless tie?
  end

  def set_player_order
    @current_player = case choose_first_player
                      when 1 then human
                      when 2 then computer
                      when 3 then [human, computer].sample
                      end
  end

  def choose_first_player
    display_player_order_prompt
    valid_options = %w(1 2 3)
    error_message = "Please enter #{valid_options.joinor(', ')}!"

    validate_input(valid_options, error_message).to_i
  end

  def other_player(player)
    player == human ? computer : human
  end

  def switch_current_player
    self.current_player = other_player(current_player)
  end

  def choose_key
    current_player.choose_move(board.unmarked_keys)
  end

  def mark_board(key)
    board[key] = current_player.marker
  end

  def find_winner
    Player.find_by_marker(board.winning_marker)
  end

  def tie?
    board.full? && !board.winner?
  end 

  def round_over?
    [human, computer].any? { |player| player.score >= score_limit }
  end

  def reset_round
    board.reset
    [human, computer].each(&:reset_score)
  end

  def continue
    puts 'Press any key to continue:'
    STDIN.getch
  end

  def play_again?
    puts 'Would you like to play again? (y/n)'
    validate_input(%w(y n), 'Please enter y or n!') == 'y'
  end
  
end

TTTGame.new.play
# Program flow:
# Start
# - Welcome to TTT!
# - (Rules) You and the computer opponent take turns marking a (GRIDSIZE x GRIDSIZE)
#   board. If you successfully mark (GRIDSIZE) squares in a row, you win!
# - What's your name? (cant be empty)
# - Initialize the @board, @human (name), and @computer
# Let's get started! => (Program loop)
#   => Round Loop
#     - How many wins would you like to play up to? (1-10)
#     => (Game Loop)
#       - Randomly set current player
#       - Clear screen
#       - Display game state (Header + Board)

#       - Current player chooses move
#       - Clear screen
#       - Display game state (Header + Board)
#       - Check for winner / full
#         - If neither, switch current player and re-loop game loop
#         - If game ends, increment current player's score
#           - Hugo wins!/Computer wins!
#       (End Game Loop)
#   - Check if current player's score is == or > than win limit
#    - If true, end round loop, otherwise re-loop round loop
#   (exit round loop)
#   - Play again? (y -> re-loop program loop; n -> exit)
