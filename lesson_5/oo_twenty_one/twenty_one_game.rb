require 'pry'
require 'io/console'

require_relative 'displayable'
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'result'

# TO DO:
# - clean up 

# - Card display logic (full vs hidden dealer)
# - Full cards (aesthetic)


# 4) Spike
# Orchestration Engine for 21
class TwentyOneGame
  include Displayable
  
  BUST_LIMIT = 21
  STARTING_CARD_COUNT = 2

  attr_reader :deck, :dealer, :punter, :players

  def initialize
    clear
    display_rules
    @deck = Deck.new(shuffle: true)
    @dealer = Dealer.new
    @punter = Punter.new
    @players = [punter, dealer]
  end

  def play

    loop do
      game_limit = choose_game_limit
      games_played = 0
      # Match loop
      loop do
        clear
        
        play_game

        result = Result.new(players)
        result.winner.increment_score unless result.tie?
        update_display(full: true)
        puts result
        

        games_played += 1
        break if games_played >= game_limit
        
        reset_game_state
        continue
      end

      match_result = MatchResult.new(players)
      puts match_result


      break unless play_again?
      reset_match_state
    end
    display_goodbye
  end

  def play_game
    display_scores
    display_deal
    deal_starting_cards
    
    update_display
    player_turns
  end

  def reset_game_state
    players.each(&:discard_hand)
    deck.reset
    deck.shuffle!
  end

  def reset_match_state
    reset_game_state
    players.each(&:reset_score)
  end

  def player_turns
    players.each do |player|
      loop do
        move = player.choose_move

        if move == 'H'
          display_hit(player)
          player.hit(deck.deal!)
        else
          display_stay(player)
        end

        update_display(full: player == dealer)

        break if player.busted? || move == 'S'
      end

      break if player.busted?
    end
  end

  def choose_game_limit
    puts 'How many games would you like to play? (1-10)'
    loop do
      games = gets.chomp
      return games.to_i if ('1'..'10').include?(games)
      puts 'Please pick a number between 1 and 10!'
    end
  end

  def deal_starting_cards
    players.each do |player|
      player.hit(deck.deal!(STARTING_CARD_COUNT))
    end
  end

  def continue
    puts 'Press any key to continue:'
    STDIN.getch
  end

  def play_again?
    puts 'Do you want to play again? (Y/N)'

    loop do
      choice = gets.chomp.upcase
      return choice == 'Y' if %w(Y N).include?(choice)
      puts 'Please enter either Y or N!'
    end
  end
end

TwentyOneGame.new.play
