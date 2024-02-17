require 'pry'

require_relative 'board'
require_relative 'displayable'
require_relative 'player'
require_relative 'square'

class TTTGame
  include Displayable
  
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new('X', board)
    @computer = Computer.new('O', board)
  end

  def play
    display_welcome
    
    set_current_player
    # Program Loop
    loop do
      board.clear_and_display

      # Game Loop
      loop do
        # display game state
        board.mark_at(current_player.choose_move, current_player.marker)
        board.clear_and_display
        break if board.full? || board.has_winner?(current_player.marker)

        switch_current_player
      end

      display_result
      break unless play_again?
      board.reset
    end

    display_goodbye
  end

  def set_current_player
    @current_player, @next_player = human, computer
  end

  def switch_current_player
    self.current_player, self.next_player = next_player, current_player
  end

  private

  attr_accessor :current_player, :next_player

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
