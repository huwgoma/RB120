# frozen_string_literal: true

require_relative 'displayable'

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

  def clear_and_draw
    clear
    draw
  end

  def []=(key, value)
    squares[key].mark(value)
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].empty? }
  end

  def full?
    unmarked_keys.empty?
  end

  def winner?
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
    squares.each_value(&:unmark)
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

    win_conditions.each_with_object(priorities) do |line, priorities|
      empty, marked = squares_at(line).partition(&:empty?)

      # Row is priority
      if empty.one? && marked.map(&:values).uniq.one?























      row_squares = squares.values_at(*line)
      empty, marked = row_squares.partition(&:empty?)

      next unless priority_row?(empty, marked)

      # Row is a priority if one empty square and marked square values uniq is one
      binding.pry
      if priority_row?(row)
        empty_key = squares.key(empty.first)
        row_marker = marked.first.value
        if row_marker == marker
          priorities[:offense] << empty_key
        else
          priorities[:defense] << empty_key
        end
      end
    end


      # [1, 2, 3], [4, 5, 6], [7, 8, 9]
      # [1, 4, 7], [2, 5, 8], [3, 6, 9],
      # [1, 5, 9], [3, 5, 7]

      # Iterate through winning condiitons. For each row:
      # Retrieve the squares at the current row.
      # Check if the row of squares is priority
      #   - exactly 2 squares that are marked, and
      #   - exactly 2 unique values
      # If the row is a priority row, add the key of the empty square in that row
      #   to priorities hash under the appropriate key
      # 
      # Partition the row squares into empty/not empty.


      #   1) Determine the key of the empty square
      #   - Find the square with the value equal to Initial
      #   2) Determine the type of priority (offensive/defensive)
      #   - From the two unique values of that row eg [' ', 'X'], retrieve the
      #     string that is NOT equal to Initial Value of Square
      #     - If row_marker == marker, priorities[offense] << 


      # What if we: 
      # Iterate through winning conditions just once? For each row:
      #   Is that row a priority? If it is - which square?
      #   - Row has exactly 2 marked squares # 1 empty
      #   - Row has exactly 2 unique values # 1 empty, 2 of the same.
      #   If priority? is true:
      #   1) Find the key of the empty square
      #   2) Determine if the priority is offensive or defensive
      #     - Find the non-empty (initial) value - is that value identical to marker?
      #       - If it is => Add to offensive
      #       - Otherwise => Add to defensive

    
  end

  def squares_at(line)
    squares.values_at(*line)
  end

  def priority_line?(line)
    empty_squares, marked_squares = squares_at(line).partition(&:empty?)

    empty_squares.one? && marked_squares.map(&:value).uniq.one?
  end

  # Accessory Methods for #draw
  def calculate_cell_size
    [3, squares.keys.max.to_s.size].max
  end

  def create_row_partition
    "\n#{('---+' * GRID_LENGTH).chop}\n"
  end

  def all_in_a_row?(line)
    squares_at(line).map(&:value).uniq.one?
  end
end
