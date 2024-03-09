# Encapsulate the result of a single Twenty-One Game
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

  def tie?
    players.map(&:hand_value).uniq.one?
  end

  def to_s
    if bust?
      "#{loser} went over 21 and busted! #{winner} wins!"
    elsif tie?
      "It's a tie, #{players.first.hand_value}-#{players.last.hand_value}!"
    else
      "#{winner} wins, with a hand of #{winner.hand_value}-#{loser.hand_value}!"
    end
  end

  private

  def determine_winner
    return if tie?

    if bust?
      other_player(players.find(&:busted?))
    else
      players.max_by(&:hand_value)
    end
  end

  def other_player(player)
    return if player.nil?

    player == players.first ? players.last : players.first
  end
end

# Encapsulate the result of a Twenty-One 'match' (multiple games)
class MatchResult < Result
  def tie?
    players.map(&:score).uniq.one?
  end

  def to_s
    if tie?
      "It's a tie, #{players.first.score}-#{players.last.score}!"
    else
      "#{winner} wins, #{winner.score}-#{loser.score}!"
    end
  end

  private

  def determine_winner
    return if tie?

    players.max_by(&:score)
  end
end
