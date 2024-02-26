# frozen_string_literal: true

# Represents TTT Board
class Board
  include Displayable

  GRID_LENGTH = 3
  GRID_AREA = GRID_LENGTH**2

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

  def []=(key, value)
    squares[key].mark(value)
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].empty? }
  end

  def marked_keys
    squares.keys.select { |key| squares[key].marked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def winner?
    !!winning_marker
  end

  def winning_marker
    win_conditions.each do |row|
      first_square = squares[row.first]
      next if first_square.empty?

      return first_square.value if all_in_a_row?(row)
    end
    nil
  end

  def reset
    squares.each_value(&:unmark)
  end

  def priority_keys(marker)
    calculate_priority_keys(marker)
  end

  # Return the key(s) representing the middle of the board
  def unmarked_middle_keys
    calculate_middle_keys - marked_keys
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
  
  # Calculating Priority Keys
  def calculate_priority_keys(marker)
    priorities = { offense: [], defense: [] }

    win_conditions.each_with_object(priorities) do |row, priorities|
      next unless priority_row?(row)

      empty_squares, marked_squares = partition_empty_squares(row)

      empty_key = squares.key(empty_squares.first)
      row_marker = marked_squares.first.value
      priority_type = row_marker == marker ? :offense : :defense

      priorities[priority_type] << empty_key
    end
  end

  def calculate_middle_keys
    if GRID_LENGTH.odd?
      [(GRID_AREA / 2) + 1]
    else
      calculate_winning_diagonals.map do |diagonal|
        diagonal[(GRID_LENGTH / 2 - 1), 2]
      end.flatten
    end
  end

  def squares_at(row)
    squares.values_at(*row)
  end

  # Partition the squares in a row based on whether they are empty/marked
  def partition_empty_squares(row)
    squares_at(row).partition(&:empty?)
  end

  def priority_row?(row)
    empty_squares, marked_squares = partition_empty_squares(row)

    empty_squares.one? && marked_squares.map(&:value).uniq.one?
  end

  # Accessory Methods for #draw
  def calculate_cell_size
    [3, squares.keys.max.to_s.size].max
  end

  def create_row_partition
    "\n#{('---+' * GRID_LENGTH).chop}\n"
  end

  def all_in_a_row?(row)
    squares_at(row).map(&:value).uniq.one?
  end
end
