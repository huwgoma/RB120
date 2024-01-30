# Result of 2 Moves
class Result
  attr_reader :winner, :loser, :winning_value, :outcome

  @@history = []

  def initialize(move1, move2)
    @move1 = move1
    @move2 = move2
    @loser, @winner = calculate_winner_and_loser
    @winning_value = winner&.move&.type
    @outcome = calculate_outcome

    @@history << self
  end

  def self.history
    @@history
  end

  def self.clear_history
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
    winner.move.class::WINS_AGAINST[loser.move.type]
  end
end
