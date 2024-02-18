require 'pry'

require_relative 'board'
require_relative 'displayable'
require_relative 'player'
require_relative 'square'

class TTTGame
  include Displayable
  
  MARKERS = ['X', 'O'] # ?

  attr_reader :board, :human, :computer

  def initialize
    display_welcome
    @board = Board.new
    @human = Human.new(MARKERS.first, board)
    @computer = Computer.new(MARKERS.last, board)
  end

  def play
    # Display Rules
    
    set_current_player
    # Program Loop
    loop do
      board.clear_and_draw

      # Game Loop
      loop do
        display_gamestate
        board.mark_at(current_player.choose_move, current_player.marker)
        display_gamestate
        break if board.full? || board.has_winner?

        switch_current_player
      end

      display_result
      break unless play_again?
      board.reset
    end

    display_goodbye
  end

  private

  attr_accessor :current_player, :next_player

  def set_current_player
    @current_player, @next_player = human, computer
  end

  def switch_current_player
    self.current_player, self.next_player = next_player, current_player
  end

  def play_again?
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      return answer == 'y' if %w(y n).include?(answer)
      puts "Sorry - please enter y or n."
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