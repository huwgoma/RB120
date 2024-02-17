class Player
  attr_reader :marker, :board

  def initialize(marker, board)
    @marker = marker
    @board = board
  end
end

class Human < Player
  def choose_move
    puts "Choose an empty square (#{board.unmarked_keys.join(', ')}):"
    loop do
      num = gets.chomp.to_i
      return num if board.unmarked_keys.include?(num)
      puts "Sorry, that's not a valid choice."
    end
  end
end

class Computer < Player
  def choose_move
    board.unmarked_keys.sample
  end
end