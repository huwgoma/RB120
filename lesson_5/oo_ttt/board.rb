require_relative 'displayable'

class Board
  include Displayable
  
  GRID_LENGTH = 3
  GRID_AREA = GRID_LENGTH ** 2

  def initialize
    @squares = create_squares
    @win_conditions = calculate_win_conditions
  end

  def draw
    cell_size = calculate_cell_size
    row_partition = create_row_partition
    column_partition = '|'

    squares.each do |key, square|
      partition = (key % GRID_LENGTH).zero? ? row_partition : column_partition
      cell_value = square.empty? ? key.to_s : square.value
      print cell_value.center(cell_size, ' ')
      print partition unless key >= GRID_AREA
    end
    puts "\n"
  end

  def clear_and_draw
    clear
    draw
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

  def winning_marker
    win_conditions.each do |line|
      first_square = squares[line.first]
      next if first_square.empty?

      return first_square.value if all_in_a_row?(line)
    end
    nil
  end

  def reset
    squares.values.each(&:unmark)
  end

  private

  attr_reader :squares, :win_conditions

  def create_squares
    (1..GRID_AREA).each_with_object({}) do |key, squares|
      squares[key] = Square.new
    end
  end

  # Calculating win conditions
  def calculate_win_conditions
    winning_rows = calculate_winning_rows
    winning_cols = calculate_winning_cols
    winning_diagonals = calculate_winning_diagonals

    winning_rows + winning_cols + winning_diagonals
  end

  def calculate_winning_rows
    (1..GRID_AREA).each_slice(GRID_LENGTH).to_a
  end

  def calculate_winning_cols
    (1..GRID_LENGTH).map do |origin|
      column = [origin]
      column << origin += GRID_LENGTH until column.size == GRID_LENGTH
      column
    end
  end

  def calculate_winning_diagonals
    [1, GRID_LENGTH].map do |origin|
      diagonal = [origin]
      increment = origin == 1 ? (GRID_LENGTH + 1) : (GRID_LENGTH - 1)
      diagonal << origin += increment until diagonal.size == GRID_LENGTH
      diagonal
    end
  end

  # Accessory Methods for #draw
  def calculate_cell_size
    [3, squares.keys.max.to_s.size].max
  end

  def create_row_partition
    "\n#{('---+' * GRID_LENGTH).chop}\n"
  end

  def all_in_a_row?(line)
    squares.values_at(*line).map(&:value).uniq.one?
  end
end
