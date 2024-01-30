require_relative 'class_converter'

# Get rid of class converter
# Create a new class: MoveFactory
# - Takes an input string and creates/returns the corresponding move subclass object
# eg. MoveFactory.create_move(type, owner)
# Given a string (type) and a player object (owner):
#   Verify that type is a key in MOVE_TYPES - if not, raise error (? necessary? we are already verifying input )
#   If type is indeed a key:
#     Create and return the object of the corresponding type (eg. 'Rock' => new Rock object )

# Data:
# Hash containing the String-Constant conversions, MOVE_TYPES
#   { 'Rock' => Rock, 'Paper' => Paper, ... }
# 

# Comparing Moves
# Each class should maintain WINS_AGAINST hash
#   { 'Scissors' => 'crushes' }
# Move#<=>
# - Compare using @type (self.class.to_s) - string representation of the move's type
#   => 0 if @type == other_move.type
#   => 1 if self.WINS_AGAINST contains a key matching the other_move.type 

# Choosing Moves:
# - Generate string, validate if player
# - pass String to MoveFactory along with self (player owner)


# Move Superclass
class Move
  include ClassConverter
  include Comparable

  attr_reader :owner, :type

  VALUES = ['Rock', 'Paper', 'Scissors', 'Lizard', 'Spock']

  def initialize(owner)
    @owner = owner
    @type = self.class.to_s
    # change all instances of move.value to move.type (and VALUES => TYPES?)
  end

  def self.choices
    str = VALUES.join(', ')
    last_comma_index = str.rindex(',')
    str.insert(last_comma_index + 1, ' or')
  end

  def <=>(other_move)
    return 0 if value == other_move.value

    class_of(value)::WINS_AGAINST.key?(other_move.value) ? 1 : -1
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
  MOVE_TYPES = Move::VALUES.map do |value|
    [value, Object.const_get(value)]
  end.to_h

  def self.create_move(type, owner)
    MOVE_TYPES.fetch(type).new(owner)
  end
end
