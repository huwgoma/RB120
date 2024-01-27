require_relative 'ClassConverter'

# Result of 2 Moves
class Result
  include ClassConverter

  attr_reader :winner, :loser, :winning_value, :outcome

  @@history = []

  def initialize(move1, move2)
    @move1, @move2 = move1, move2
    @loser, @winner = calculate_winner_and_loser
    @winning_value = winner&.move&.value
    @outcome = calculate_outcome

    @@history << self
  end

  def self.history(n = 5)
    @@history.last(n)
  end

  def self.reset_history
    @@history.clear
  end

  def tie?
    move1 == move2
  end

  def announce
    if tie?
      puts "You both picked #{move1} - #{outcome}!"
    else
      puts "#{winner.move} #{winning_action} #{loser.move} - #{outcome}!" 
    end
  end

  def to_s
    "#{moves} (#{outcome}.)"
  end

  private

  attr_reader :move1, :move2

  def calculate_winner_and_loser
    return nil if tie?
    [move1, move2].minmax.map(&:owner)
  end

  def calculate_outcome
    tie? ? "Tie" : "#{winner} wins"
  end

  def moves
    "#{move1.owner}: #{move1}, #{move2.owner}: #{move2}"
  end

  def winning_action
    class_of(winner.move.value)::WINS_AGAINST[loser.move.value]
  end
end