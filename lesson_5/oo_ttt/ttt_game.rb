# frozen_string_literal: true

require 'pry'
require 'io/console'
require_relative 'board'
require_relative 'displayable'
require_relative 'player'
require_relative 'square'

# To do:

# Flesh out set-current-player 
#   - Implement ability to choose (1: You; 2: CPU; 3: idc)
#   - Set current player at the start of each round;
#     - After each game, set the current player to the loser of last game.
#        




# Orchestration Engine for TTT Game
class TTTGame
  include Displayable

  MARKERS = %w[X O].freeze

  attr_reader :board, :human, :computer

  def initialize
    display_welcome
    display_rules
    @board = Board.new
    @human = Human.new(MARKERS.first)
    @computer = Computer.new(MARKERS.last, board)
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

  attr_accessor :current_player, :next_player, :score_limit

  def match_loop
    loop do
      game_loop
      increment_score
      display_post_game

      break if round_over?

      board.reset
      continue
    end
  end

  def set_score_limit
    puts 'How many wins would you like to play up to? (1-10)'
    
    loop do
      self.score_limit = gets.chomp.to_i
      break if (1..10).include?(score_limit)

      puts 'Invalid input - please enter a number between 1 and 10.'
    end
  end

  def game_loop
    set_current_player # display who will be moving first - need pause?
    loop do
      display_gamestate
      mark_board(choose_key)
      display_gamestate

      break if board.full? || board.winner?

      switch_current_player
    end
  end

  def increment_score
    find_winner.increment_score unless tie?
  end

  def display_post_game
    display_gamestate
    display_game_result(find_winner)
  end

  def set_current_player
    @current_player = human
    @next_player = computer
  end

  def switch_current_player
    self.current_player, self.next_player = next_player, current_player
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
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      return answer == 'y' if %w[y n].include?(answer)

      puts 'Sorry - please enter y or n.'
    end
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
