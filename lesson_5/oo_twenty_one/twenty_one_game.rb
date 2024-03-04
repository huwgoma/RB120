require 'pry'

require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'result'

# TO DO:
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
    system 'clear'
    display_rules
    @dealer = Dealer.new
    @punter = Punter.new
    @players = [punter, dealer]
  end

  def play
    system 'clear'
    initialize_deck
    deal_starting_cards
    # Now Dealing...
    display_hands
    # Display work
    # Welcome to Twenty One!
    # Rules are blah blah blah,....
    # What's your name? -> Prompt for name
    # How many rounds would you like to play? 

    # Game Display Flow
    # 1) Would you like to Hit or Stay?
    #   - If move == 'H', hit: Add a card to the player's hand, then 
    #     clear the screen and update the display

    # 2) If move == 'S', stay: 
    #   - prompt 'switching players'....
    #   - wait 1 second
    # 3) Then start the dealer's turn
    #   - If move == 'H', hit: Add a card to the player's hand, wait 1s, then
    #     clear screen and update display



    players.each do |player|
      loop do
        move = player.choose_move

        if move == 'H'
          announce_hit(player)
          player.add_to_hand(deck.deal!)
        else
          announce_stay(player)
        end

        update_display(full: player == dealer)

        break if player.busted? || move == 'S'
      end

      break if player.busted?
    end

    result = Result.new(players)
    puts result
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

  def update_display(full: false)
    system 'clear'
    # Display scores
    display_hands(full: full)
  end

  def initialize_deck
    @deck = Deck.new
    deck.shuffle!
  end

  def deal_starting_cards
    players.each do |player|
      player.add_to_hand(deck.deal!(STARTING_CARD_COUNT))
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
end

TwentyOneGame.new.play
