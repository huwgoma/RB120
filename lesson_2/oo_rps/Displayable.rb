# Namespace for Display methods
module Displayable
  private
  
  def display_rules
    puts 'Welcome to Rock Paper Scissors Lizard Spock!'
    puts 'The rules are as follows:'
    puts <<-HEREDOC
Scissors cuts Paper covers Rock crushes Lizard poisons Spock smashes
Scissors decapitates Lizard eats Paper disproves Spock vaporizes Rock
crushes Scissors.
    HEREDOC
    line_break
  end

  def introduce_computer
    puts "Your opponent this round is #{computer}."
    # computer.describe
    #   => name + personality

    # RandomBot will pick moves at complete random.
    # R2D2 will only pick Rock.
    # Hal will probably pick Scissors.
    # Mahoraga will adapt to your moves. If the game drags out, you might 
    #   have a bit of trouble..
  end

  def display_game_state
    clear_screen
    display_history
    line_break
    display_scores
  end
  
  def display_history
    history = Result.history
    return if history.size.zero?
    puts "Last #{history.size} games:"
    # pluralize
    puts history
  end

  def display_scores
    puts "Current score: #{human}: #{human.score}, #{computer}: #{computer.score}"
  end

  def display_round_winner(result)
    winner, loser = result.winner, result.loser
    puts "#{winner} wins the round, #{winner.score}-#{loser.score}!"
  end

  def display_goodbye
    puts "Thanks for playing. Goodbye!"
  end

  def line_break
    puts "\n"
  end

  def clear_screen
    system('clear')
  end
end