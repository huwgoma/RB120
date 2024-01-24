require_relative 'ClassConverter'

# Result of 2 Moves
class Result
  include ClassConverter

  attr_reader :winner, :loser, :value

  @@history = []

  def initialize(move1, move2)
    @move1, @move2 = move1, move2
    # winner or winning move? -> Try winning move
    @winner = find_winner
    @loser = find_loser
    @value = calculate_value

    @@history << self
  end

  def self.history(n = 5)
    @@history.last(n)
  end

  def tie?
    move1 == move2
  end

  def announcement
    if tie?
      "You both picked #{move1} - #{value}!"
    else
      "#{winner.move} #{winning_action} #{loser.move} - #{value}!" 
    end
  end

  def to_s
    "#{moves} (#{value}.)"
  end

  private

  attr_reader :move1, :move2

  def find_winner
    return nil if tie?
    [move1, move2].max.owner
  end

  def find_loser
    return nil if tie?
    [move1, move2].min.owner
  end

  def calculate_value
    tie? ? "Tie" : "#{winner} wins"
  end

  def moves
    "#{move1.owner}: #{move1}, #{move2.owner}: #{move2}"
  end

  def winning_action
    class_of(winner.move.value)::WINS_AGAINST[loser.move.value]
  end
end