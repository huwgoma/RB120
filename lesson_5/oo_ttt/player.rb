class Player
  attr_reader :marker, :board, :name

  def initialize(marker, board)
    @marker = marker
    @board = board
    @name = choose_name
  end

  def to_s
    name
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

  def choose_name
    puts "What's your name?"
    loop do
      name = gets.chomp.strip
      return name unless name.empty?
      puts "You can't have an empty name!"
    end
  end
end

class Computer < Player
  def choose_move
    board.unmarked_keys.sample
  end

  def choose_name
    'Mahoraga'
  end
end