# frozen_string_literal: true

# Player Superclass
class Player
  attr_reader :marker, :name, :score

  # Choosing to disable this cop, since we haven't learned about class
  # instance variables yet.
  # rubocop:disable Style/ClassVars
  @@list = []
  # rubocop:enable Style/ClassVars

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
  include Promptable

  def initialize(other_marker)
    super()
    @marker = choose_marker(other_marker)
  end
end

# CPU Player
class Computer < Player
  def initialize(board)
    super()
    @marker = choose_marker
    @board = board
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

  def choose_name
    %w[R2D2 Hal Wall-E].sample
  end

  def choose_marker
    name[0]
  end
end
