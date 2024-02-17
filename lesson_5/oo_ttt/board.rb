require_relative 'displayable'
# require_relative 'square'

class Board
  include Displayable
  
  GRID_LENGTH = 4
  GRID_SIZE = GRID_LENGTH ** 2

  # Update Win cons to be scalable too
  WIN_CONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],  # rows
              [1, 4, 7], [2, 5, 8], [3, 6, 9],  # columns
              [1, 5, 9], [3, 5, 7]]             # diagonals

  attr_reader :squares

  def initialize
    @squares = create_squares
  end

  # Board Drawing Methods
  def draw
    cell_size = calculate_cell_size
    row_partition = create_row_partition
    column_partition = '|'

    squares.each do |key, square|
      partition = (key % GRID_LENGTH).zero? ? row_partition : column_partition
      cell_value = square.empty? ? key.to_s : square.value
      print cell_value.center(cell_size, ' ')
      print partition unless key >= GRID_SIZE
    end

    puts "\n"
  end

  def calculate_cell_size
    [3, squares.keys.max.to_s.size].max
  end

  def create_row_partition
    "\n#{('---+' * GRID_LENGTH).chop}\n"
  end

  def clear_and_draw
    clear
    draw
  end

  def create_squares
    (1..GRID_SIZE).each_with_object({}) do |key, squares|
      squares[key] = Square.new
    end
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