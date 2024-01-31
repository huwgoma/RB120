# Move Superclass
class Move
  include Comparable

  attr_reader :owner, :type

  VALUES = ['Rock', 'Paper', 'Scissors', 'Lizard', 'Spock']

  def initialize(owner)
    @owner = owner
    @type = self.class.to_s
    # change all instances of move.value to move.type (and VALUES => TYPES?)
  end

  def self.types
    VALUES.map { |type| [type, Object.const_get(type)] }.to_h
  end

  def self.choices
    str = VALUES.join(', ')
    last_comma_index = str.rindex(',')
    str.insert(last_comma_index + 1, ' or')
  end

  def <=>(other_move)
    return 0 if type == other_move.type
    self.class::WINS_AGAINST.key?(other_move.type) ? 1 : -1
  end

  def to_s
    type
  end
end

# Subclasses for 5 types of Moves
class Rock < Move
  WINS_AGAINST = {
    'Scissors' => 'crushes', 'Lizard' => 'crushes'
  }
end

class Paper < Move
  WINS_AGAINST = {
    'Spock' => 'disproves', 'Rock' => 'covers'
  }
end

class Scissors < Move
  WINS_AGAINST = {
    'Paper' => 'cuts', 'Lizard' => 'decapitates'
  }
end

class Lizard < Move
  WINS_AGAINST = {
    'Spock' => 'poisons', 'Paper' => 'eats'
  }
end

class Spock < Move
  WINS_AGAINST = {
    'Rock' => 'vaporizes', 'Scissors' => 'smashes'
  }
end

# MoveFactory Class for creating Move subclass objects
class MoveFactory
  MOVE_TYPES = Move.types

  def self.create_move(type, owner)
    MOVE_TYPES[type].new(owner)
  end
end
