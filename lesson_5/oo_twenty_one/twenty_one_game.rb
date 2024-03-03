require 'pry'

require_relative 'deck'
require_relative 'card'
require_relative 'player'
# Twenty One - Rules
# Card game (52-card deck); 4 suits, 13 values (2-10, j, q, k)
# - 'Deck'
# Two players: Banker (CPU) and Punter
# - Both players have 2 cards to start 
# - The game is played from the punter's POV
# - The punter can see all of their cards, but only one of the banker's cards
# Goal: Get as close to 21 without going over
# - If either the punter or banker goes over 21, they bust and the other player
#   wins

# Card Values: 
# Number cards are worth their face value
# Jack Queen King are worth 10
# Ace is worth either 1 or 11, depending on the total value of the hand.
# - If the total value would exceed 21, the ace's value is 1; otherwise, it's 
#   worth 11.
# - This value is dynamic, so 2 aces in one hand will have different values, and 
#   will update in real-time.

# Turns:
# Punter starts. Two choices for the punter - hit or stay
# - Hit means the player draws another card
# - Stay means the player turn ends
# Banker must draw until their hand value is >= 17.
# - If the banker does not bust, compare the banker and punter's hand values.


# 1) Describe the problem
#   21 is a card game consisting of a banker and a punter. The goal of the game is
#     to get as close to 21 without going over.
#   - Both players start with 2 cards from a normal 52-card deck.
#   - The punter starts first, and can either HIT or STAY.
#     - HIT: Draw another card.
#     - STAY: End the turn, and go to the banker's turn.
#   - The banker moves second, and must HIT until his hand value equals or 
#     exceeds 17, at which point he must STAY. 
#   - If, at any point, either the punter or banker's hand value goes over 21,
#     that player busts and the game immediately ends with the other player's 
#     victory.
#   - Otherwise, if neither player busts, the scores are compared at the end of 
#     the banker's turn. The player with the higher score (closer to 21) wins.
#     If both hands are equal, then it's a tie. 

# 2) Nouns / Verbs
#   - Game (Orchestration Engine)
#       - Punter moves, Check for bust, Repeat until punter stays
#       - Dealer moves, Check for bust, repeat until dealer stays
#       - If bust at any point, exit looping and skip to end of game 
#       - Compare dealer and punter hand totals to find winner
#   - Card 
#     - @suit, @face, @value
#     - Ace < Card? Still a card, but with more specialized behavior
#   - Deck
#     - @cards = 52 new cards (13 A-K of each suit)
#     - cards need to be Dealed from @cards
#   - Player => Banker/Punter
#     - @hand (of cards)
#     - hand_total (value of the cards in hand)
#     - busted? (if @hand_total > 21)
#     - Hit: Draw a new card from the deck 
#     - Stay: Pass and do nothing

# 4) Spike
# Orchestration Engine for 21
class TwentyOneGame
  STARTING_CARD_COUNT = 2

  attr_reader :deck, :dealer, :punter


  def initialize
    
    @dealer = Dealer.new
    @punter = Punter.new
  end

  def play
    @deck = Deck.new
    deck.shuffle!
    deal_starting_cards

    

    # Game Loop
    # Punter chooses move.
    #   Hit -> Hit -> Until Stay or Bust
    # Dealer chooses move unless punter busted.
    #   Hit -> Hit -> Until Stay or Bust
    
    # Full send 
    [punter, dealer].each do |player|
      loop do
        move = player.choose_move

        player.add_to_hand(deck.deal!) if move == 'H'
        player.display_hand # not if dealer ?
        
        break if player.busted? || move == 'S'
      end

      break if player.busted?
    end


    binding.pry
    # punter_turn
    # dealer_turn unless punter.bust?
    # calculate_game_result
    # 
    # winner = if punter.bust? 
    #             dealer
    #          elsif dealer.bust?
    #             punter
    #          else
    #             dealer, punter .maxby hand value
    
    # current_player = punter
    # 
    # current player moves.
    # If current player busted, break
    # Otherwise, switch current player.
    # Break if both players stayed.
    # 

    # loop do
    #   current player move
    #   break if current player busted?
    #   switch current player if current player stayed
    #   break if both players stayed
    # end
    # win logic:
    # - If either player busted, the other player is the winner
    # - Otherwise, compare hand values to determine winner
    #   

  end

  def deal_starting_cards
    [dealer, punter].each do |player|
      player.add_to_hand(deck.deal!(STARTING_CARD_COUNT))
    end
  end

  # def punter_turn
  #   punter.choose_move # return a string representing move 'h'/'s'
  #   break if move == 's'
  #   # how to represent moves? hit/stay?
  #   # until punter.stayed? || punter.busted?
  # end
end

TwentyOneGame.new.play


# Deck 'deal' => Remove the first card from the deck
# Player 'draw' => Add the given card to the players hand


# 
# Loop until punter either stays or busts
# - If punter stays, switch the player to dealer
# - If punter busts, skip the dealer's turn and go straight to calculating end of game  