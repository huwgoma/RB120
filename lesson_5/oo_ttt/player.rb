# frozen_string_literal: true

require_relative 'validatable'
require_relative 'displayable'

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
  include Displayable

  def initialize(other_marker)
    super()
    @marker = choose_marker(other_marker)
  end

  # CHOOSE = DONE
  def choose_name
    puts "What's your name?"

    validator = -> (name) { valid_name?(name) }
    error_message = "Your name can't be empty!"
    
    validate_input(validator, error_message)
  end

  # CHOOSE = DONE
  def choose_marker(other_marker)
    display_marker_choice_prompt(other_marker)

    validator = -> (marker, other_marker) { valid_marker?(marker, other_marker) }
    error_message = "Your marker must be exactly 1 non-empty character, and cannot
    be #{other_marker} (that's the CPU's marker.)"

    validate_input(validator, error_message, other_marker).strip
  end
  
  # CHOOSE = DONE
  def choose_move(empty_keys)
    puts "Choose an empty square (#{empty_keys.joinor(', ')}):"

    validator = -> (key, empty_keys) { valid_member?(key, empty_keys)}
    error_message = "That isn't an empty square!"

    validate_input(validator, error_message, empty_keys.map(&:to_s)).to_i
  end
end

# CPU Player
class Computer < Player
  def initialize(board)
    super()
    @marker = choose_marker
    @board = board
  end

  def choose_name
    ['R2D2', 'Hal', 'Wall-E'].sample
  end

  def choose_marker
    name[0]
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