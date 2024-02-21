# frozen_string_literal: true

require_relative 'validatable'

# Player Superclass
class Player
  attr_reader :marker, :name, :score

  @@list = []

  def self.list
    @@list
  end

  def self.find_by_marker(marker)
    list.find { |player| player.marker == marker }
  end

  def initialize
    @name = choose_name
    @marker = choose_marker
    @score = 0
    @@list << self
  end

  def to_s
    name
  end

  def increment_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end

  private 

  attr_writer :marker, :score 
end

# Human Player
class Human < Player
  include Validatable
  
  def choose_move(valid_choices)
    puts "Choose an empty square (#{valid_choices.joinor(', ')}):"
    error_message = "That isn't an empty square!"

    validate_input(valid_choices.map(&:to_s), error_message).to_i
  end

  def choose_marker
    'X'
    # What marker would you like to use? (You cannot use <>, since that's the
    #   computer's marker)
    # gets.chomp
    # Cannot be empty
  end

  # Choose marker
  # Allow any single character (non-empty)
  # How to determine the CPU marker?
  # - Maybe the first letter of name?

end

# CPU Player
class Computer < Player
  def initialize(board)
    super()
    @board = board
  end

  def choose_marker
    self.marker = name[0]
  end

  def choose_name
    ['R2D2', 'Hal', 'Wall-E'].sample
  end

  def choose_move(valid_choices)
    priority_keys = board.priority_keys(marker)
    middle_keys = board.unmarked_middle_keys

    priority_keys[:offense].sample ||
      priority_keys[:defense].sample ||
      middle_keys.sample ||
      valid_choices.sample
  end

  private

  attr_reader :board
end