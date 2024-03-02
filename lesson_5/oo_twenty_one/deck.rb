# Deck (of Cards)
class Deck
  SUITS = ['♠', '♥', '♦', '♣']
  FACES = Array('2'..'10') + ['Jack', 'Queen', 'King', 'Ace']

  attr_reader :cards

  def initialize
    @cards = generate_cards
  end

  private 

  def generate_cards
    SUITS.product(FACES).map do |(suit, face)|
      Card.new(suit, face)
    end
  end
end
