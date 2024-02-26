# frozen_string_literal: true

require 'pry'
require 'io/console'
require_relative 'validatable'
require_relative 'displayable'
require_relative 'promptable'

require_relative 'board'
require_relative 'player'
require_relative 'square'


# To do:

# Rubocop


# Pad cells with '-' if part of winning row?




# Orchestration Engine for TTT Game
class TTTGame
  include Promptable

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
      set_first_player
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
      mark_board(request_key)
      display_gamestate

      break if board.full? || board.winner?
      
      switch_current_player
    end
  end

  def set_score_limit
    self.score_limit = choose_score_limit
  end

  def increment_score
    find_winner.increment_score unless tie?
  end

  def set_first_player
    @current_player = case choose_first_player
                      when 1 then human
                      when 2 then computer
                      when 3 then [human, computer].sample
                      end
  end

  def other_player(player)
    player == human ? computer : human
  end

  def switch_current_player
    self.current_player = other_player(current_player)
  end

  def request_key
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
