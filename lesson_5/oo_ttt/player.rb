# frozen_string_literal: true

# Player superclass
# TTT Player? -> Become aware of the board
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
  def choose_name
    puts "What's your name?"
    loop do
      name = gets.chomp.strip
      return name unless name.empty?

      puts "You can't have an empty name!"
    end
  end

  def choose_move(valid_choices)
    puts "Choose an empty square (#{valid_choices.joinor(', ')}):"
    loop do
      num = gets.chomp.to_i
      return num if valid_choices.include?(num)

      puts "Sorry, that's not a valid choice."
    end
  end
end

# CPU Player
class Computer < Player
  def initialize(marker, board)
    super(marker)
    @board = board
  end

  def choose_name
    'Mahoraga'
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

# CPU Defense
# Feels like it should be a board method since we need to access board's private shit

# Board#priority_keys(marker)
# Input: String (Marker)
# Output: Hash (Priority keys, separated by offense/defense)

# Examples: 
#     O 2 X 
#     4 X X
#     O 8 9
# priority_keys('O') #=> { offense: [4], defense: [4, 9] }

#     X 2 3
#     4 X 6
#     X O O 
# priority_keys('O') #=> { offense: [], defense: [3, 4] }

# Data:
# - Hash of arrays (offense/defense keys)
# - unmarked_keys array of integers
# - win_conditions nested array of arrays (rows)

# Algorithm:
# Given a string as input, marker:
# Initialize a new Hash, priorities = {}
# Iterate through unmarked_keys. For each key:
#   Iterate through the win_conditions containing the current key. 
#   For each win condition row:
#     If any row has 2 square values identical to marker, add the current empty key
#       to priorities[:offense]
#     If any row has 2 marked squares, and 2 square values NOT equal to marker, add
#       the current empty key to priorities[:defense]
#     


# Board method - Board#priority_keys(marker)
# - Given a marker as input, representing player perspective,
#   return an array of keys representing the priority squares on the board
#   for that marker


# eg. priority_keys('O') => [4, 9]
# - Select the offensive keys first (eg. if 'O' selects 4, they win)
#   - Select keys where the other two squares have the -same- value as `marker`.
# - Next, select defensive keys 
#   - Select keys where the row has 2 marked squares and no values equal to marker.

# Given a string as input, marker:
# (Selection) Iterate through unmarked keys. For each key:
#   Iterate through @win_conditions. For each array of integers representing a line:
#     