# Design a Sports Team with 4 players (attacker, midfielder, defender, goalkeeper)
# All player jerseys are blue 
# - except the goalkeeper, whose jersey is white with blue stripes
# All players can run
# - all players can also shoot the ball
# Attackers can lob the ball
# Midfielders can pass the ball
# Defenders can block the ball

# The referee is not a player
# - referee has a whistle 
# - wears black
# - can run
# - can whistle

module Runnable
  def run
    'running!'
  end
end

class SportsTeam
  def initialize
    @players = [Attacker.new, Midfielder.new, Defender.new, Goalkeeper.new]
  end
  # has 4 players (attacker, midfielder, defender, goalkeeper)
end

class Player
  include Runnable
  
  def initialize
    @jersey_color = 'blue'
  end

  def shoot
    'shoot!'
  end

end

class Attacker < Player
  def lob
    'lob!'
  end
end

class Midfielder < Player
  def pass
    'pass to someone else'
  end
end

class Defender < Player
  def block
    'blocked!'
  end
end

class Goalkeeper < Player
  def initialize
    @jersey_color = 'white with blue stripes'
  end
end

class Referee
  include Runnable
  
  def initialize
    @has_whistle = true
    @jersey_color = 'black'
  end

  def whistle
    'fwwwwweeeeeeeeee!'
  end
end