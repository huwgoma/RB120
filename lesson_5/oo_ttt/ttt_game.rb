# frozen_string_literal: true

require 'pry'
require_relative 'board'
require_relative 'displayable'
require_relative 'player'
require_relative 'square'

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
    @computer = Computer.new(MARKERS.last)
  end

  def play
    # Program Loop
    loop do
      # Round Loop
      loop do
        set_score_limit

        # Let's get started! #{Current player} will be moving first this game.
        #   (shuffle player order at the start of every game)
        
        # Round Loop
          # Game Loop
          game_loop
          display_result
          board.reset
        # break if current player's score >= score limit

        # current player wins, with a score of 5-0!
        # play again?
      end

      break unless play_again?
      # reset scores (board was already reset at the end of the last game)
      
    end
    display_goodbye
  end

  private

  attr_accessor :current_player, :next_player, :limit

  def game_loop
    set_current_player
    loop do
      display_gamestate
      mark_board
      display_gamestate

      break if board.full? || board.winner?

      switch_current_player
    end
  end

  def set_score_limit
    puts 'How many wins would you like to play up to? (1-10)'
    
    loop do
      self.limit = gets.chomp.to_i
      break if (1..10).include?(limit)

      puts 'Invalid input - please enter a number between 1 and 10.'
    end
  end

  def set_current_player
    @current_player = human
    @next_player = computer
  end

  def switch_current_player
    self.current_player, self.next_player = next_player, current_player
  end

  def mark_board
    square_key = current_player.choose_move(board.unmarked_keys)
    board[square_key] = current_player.marker
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
