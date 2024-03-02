# Deck (of Cards)
class Deck
  SUITS = ['♠', '♥', '♦', '♣']
  FACES = Array('2'..'10') + ['Jack', 'Queen', 'King', 'Ace']

  attr_reader :cards

  def initialize
    @cards = generate_cards
    # shuffle! if shuffle
  end

  def shuffle!
    @cards.shuffle!
  end

  def deal!(count = 1)
    cards.shift(count)
  end

  private 

  def generate_cards
    SUITS.product(FACES).map do |(suit, face)|
      Card.new(suit, face)
    end
  end
end

