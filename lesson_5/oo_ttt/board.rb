require_relative 'displayable'
# require_relative 'square'

class Board
  include Displayable
  
  GRID_LENGTH = 3
  WIN_CONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],  # rows
              [1, 4, 7], [2, 5, 8], [3, 6, 9],  # columns
              [1, 5, 9], [3, 5, 7]]             # diagonals

  attr_reader :squares

  def initialize
    @squares = create_squares
  end

  def draw
    puts " #{value_at(1)} | #{value_at(2)} | #{value_at(3)} "
    puts "---+---+---"
    puts " #{value_at(4)} | #{value_at(5)} | #{value_at(6)} "
    puts "---+---+---"
    puts " #{value_at(7)} | #{value_at(8)} | #{value_at(9)} "
  end

  def clear_and_draw
    clear
    draw
  end

  def create_squares
    (1..GRID_LENGTH ** 2).each_with_object({}) do |key, squares|
      squares[key] = Square.new
    end
  end

  def value_at(key)
    squares[key].value
  end

  def mark_at(key, value)
    squares[key].mark(value)
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].empty? }
  end

  def full?
    unmarked_keys.empty?
  end

  def has_winner?
    !!winning_marker
  end

  # Return the marker of the winner, or nil if no winner
  def winning_marker
    WIN_CONS.each do |line|
      first_square = squares[line.first]
      next if first_square.empty?

      return first_square.value if all_in_a_row?(line)
    end
    nil
  end

  def all_in_a_row?(line)
    squares.values_at(*line).map(&:value).uniq.one?
  end

  def reset
    squares.values.each(&:unmark)
  end
end