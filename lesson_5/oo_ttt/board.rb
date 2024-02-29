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

  def []=(key, value)
    squares[key].mark(value)
  end

  def [](key)
    squares[key]
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
    winning_row = win_conditions.find { |row| winning_row?(row) }
    return if winning_row.nil?

    self[winning_row.first].value
  end

  def reset
    squares.each_value(&:unmark)
  end

  def priority_keys(marker)
    priority_rows = find_priority_rows
    partition_priority_keys(priority_rows, marker)
  end

  def unmarked_center_keys
    find_center_keys - marked_keys
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

  def winning_row?(row)
    row_squares = squares_at(row)
    row_squares.all?(&:marked?) && row_squares.map(&:value).uniq.one?
  end

  # 'Priority' means the row has 1 empty square and 2 marked squares w/ the same value.
  def find_priority_rows
    win_conditions.select { |row| priority_row?(row) }
  end

  def partition_priority_keys(priority_rows, marker)
    priority_rows.each_with_object({ offense: [], defense: [] }) do |row, priorities|
      row_squares = row.zip(squares_at(row)).to_h
      empty_key = row_squares.key(row_squares.values.find(&:empty?))
      row_mark = row_squares.values.find(&:marked?).value

      type = marker == row_mark ? :offense : :defense
      priorities[type] << empty_key
    end
  end

  def priority_row?(row)
    empty_squares, marked_squares = squares_at(row).partition(&:empty?)

    empty_squares.one? && marked_squares.map(&:value).uniq.one?
  end

  def find_center_keys
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

  def calculate_cell_size
    [3, squares.keys.max.to_s.size].max
  end
end
