require_relative 'class_converter'

# Move Superclass
class Move
  include ClassConverter
  include Comparable

  attr_reader :owner, :value

  VALUES = ['Rock', 'Paper', 'Scissors', 'Lizard', 'Spock']

  def initialize(value, owner)
    @value = value
    @owner = owner
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
    value
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

# I did not like the design decision to create 5 separate classes for each type
#   of Move. It does not feel like there is really any point to instantiating
#   eg. Rock objects, since every Rock object will be exactly the same, with no
#   variance in states.
# Semantically, it seems to make more sense to just use the 5 subclasses as name-
#   spaces for class methods or constants; for example, the information
#   about what a 'Rock' wins against is a class-level detail that pertains to all
#   Rocks as a whole, rather than any one individual Rock.
