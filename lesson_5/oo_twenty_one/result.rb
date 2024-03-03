# Class for calculating/encapsulating the result of a 21 Game
class Result
  attr_reader :players, :winner, :loser

  def initialize(players)
    @players = players
    @winner = determine_winner
    @loser = other_player(winner)
  end

  def bust?
    players.any?(&:busted?)
  end

  def to_s
    if bust?
      "#{loser} went over 21 and busted! #{winner} wins!"
    else
      "#{winner} wins, with a hand worth #{winner.hand_value}-#{loser.hand_value}!"
    end
  end

  private

  def determine_winner
    if bust?
      other_player(players.find(&:busted?))
    else
      players.max_by(&:hand_value)
    end
  end

  def other_player(player)
    player == players.first ? players.last : players.first
  end
end