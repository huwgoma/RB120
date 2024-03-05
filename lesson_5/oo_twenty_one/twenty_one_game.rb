require 'pry'
require 'io/console'

require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'result'

# TO DO:
# Implement scorekeeping (how many games would you like to play?)


# - Card display logic (full vs hidden dealer)
# - Full cards (aesthetic)
# - Scorekeeping (best of ?)


# 4) Spike
# Orchestration Engine for 21
class TwentyOneGame
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
        puts result
        result.winner.increment_score unless result.tie?

        games_played += 1
        break if games_played >= game_limit
        
        reset_game_state
        continue
      end

      match_result = MatchResult.new(players)
      puts match_result


      # play_again?
      break unless play_again?
      reset_match_state
    end
    display_goodbye
    # Thanks for palying!
  end

      # Match Loop
    # How many games would you like to play?
    # game_limit = gets.chomp
      # 
      #
      # 
    # after every game, increment score of winner
    # increment games_played by 1
    # When games_played == game_limit, break
    # play again?

  def play_game
    announce_deal
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
          announce_hit(player)
          player.hit(deck.deal!)
        else
          announce_stay(player)
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

  def announce_hit(player)
    puts "#{player} chose to hit - now drawing..."
    pause
  end

  def announce_stay(player)
    action = player == punter ? 'Switching players' : 'Ending game'
    puts "#{player} chose to stay. #{action}..."
    pause
  end

  def announce_deal
    puts 'Now dealing...'
    pause
  end

  def update_display(full: false)
    clear
    # Display scores
    display_hands(full: full)
  end

  def deal_starting_cards
    players.each do |player|
      player.hit(deck.deal!(STARTING_CARD_COUNT))
    end
  end

  def display_hands(full: false)
    puts "#{dealer}'s hand:"
    dealer.display_hand(full: full)
    
    puts "\n"

    puts "#{punter}'s hand:"
    punter.display_hand
  end

  def display_player_switch
    puts 'Switching players...'
    sleep(1)
  end

  def display_rules
    puts 'Welcome to Twenty One!'
    puts <<~HEREDOC
      The rules of this game are as follows:
      1) You and the CPU ('Dealer') will both start with 2 cards. You will
         see all of your cards, but only 1 of the Dealer's cards.
      2) The goal is to get your hand's value as close to 21 as possible without
         going over.
      3) On your turn, you may either 'Hit' (Draw a card) or 'Stay' (Pass).
      4) When you choose to Stay, the Dealer will take his turn. The Dealer must
         Hit until their hand's value reaches at least 17, after which they must
         Stay.
      5) If either player's hand exceeds 21, they bust and immediately lose. If 
         nobody busted, the player with the higher hand value wins.
    HEREDOC
  end

  def pause
    sleep(1)
  end

  def clear
    system('clear')
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

  def display_goodbye
    puts 'Thanks for playing Twenty-One!'
  end
end

TwentyOneGame.new.play
