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

  def initialize(marker)
    @marker = marker
    @name = choose_name
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

  attr_writer :score
end

# Human Player
class Human < Player
  include Validatable
  
  # def choose_move
  #   # puts choose an empty square (valid_choices...)
  #   validate_input(valid_choices, "Sorry, that square isn't empty")
  # end
end

# CPU Player
class Computer < Player
  def initialize(marker, board)
    super(marker)
    @board = board
  end

  def choose_name
    ['R2D2', 'Hal', 'Mahoraga'].sample
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