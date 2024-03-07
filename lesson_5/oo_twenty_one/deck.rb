# Deck (of Cards)
class Deck
  SUITS = ['♠', '♥', '♦', '♣']
  FACES = Array('2'..'10') + ['Jack', 'Queen', 'King', 'Ace']

  attr_reader :cards

  def initialize(shuffle: false)
    @cards = generate_cards
    shuffle! if shuffle
  end

  def shuffle!
    cards.shuffle!
  end

  def deal!(count = 1)
    cards.shift(count)
  end

  def reset
    self.cards = generate_cards
  end

  private

  attr_writer :cards

  def generate_cards
    SUITS.product(FACES).map do |(suit, face)|
      Card.create(suit, face)
    end
  end
end

