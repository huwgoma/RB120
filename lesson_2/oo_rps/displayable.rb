# Namespace for Display methods
module Displayable
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
    computer.describe_personality
  end

  def display_game_state
    clear_screen
    display_history
    display_scores
  end

  def display_history
    history = Result.history
    puts "Games played in this round: #{history.size}"
    display_truncated_history(history)
    line_break
  end

  def display_truncated_history(history)
    truncated_history = history.last(5)
    return if truncated_history.empty?
    puts "Last #{truncated_history.size} games:"
    puts truncated_history
  end

  def display_scores
    puts "Score: #{human}: #{human.score}, #{computer}: #{computer.score}"
  end

  def display_round_winner(result)
    winner = result.winner
    loser = result.loser
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
