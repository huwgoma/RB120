# Card Class
class Card
  INNER_WIDTH_ADDEND = 4

  attr_reader :suit, :face, :label, :value

  # Custom initializer
  def self.create(suit, face)
    face == 'Ace' ? Ace.new(suit, face) : Card.new(suit, face)
  end

  def self.display(cards, show_all: false)
    strings = build_display_strings(cards, show_all: show_all)
    puts strings
  end

  def initialize(suit, face)
    @suit = suit
    @face = face
    @label = calculate_label
    @value = calculate_value
  end

  def ace?
    instance_of?(Ace)
  end

  def to_s
    "#{face} of #{suit}"
  end

  # Card Display Logic
  # "\t" question? space with 10s
  def self.build_display_strings(cards, show_all: false)
    cards.each_with_object(['', '', '', '', '']) do |card, strings|
      suit, label, inner_width = calculate_display_info(cards.first,
                                                        card,
                                                        show_all: show_all)

      strings[0] += "+#{'-' * inner_width}+\s"
      strings[1] += "|#{suit.ljust(inner_width, ' ')}|\s"
      strings[2] += "|#{label.center(inner_width, ' ')}|\s"
      strings[3] += "|#{suit.rjust(inner_width, ' ')}|\s"
      strings[4] += "+#{'-' * inner_width}+\s"
    end
  end

  # Suit, Label, and Card Inner Width
  def self.calculate_display_info(first_card, card, show_all: false)
    if show_all || card == first_card
      [card.suit, card.label, card.label.length + INNER_WIDTH_ADDEND]
    else
      ['?', '?', INNER_WIDTH_ADDEND + 1]
    end
  end

  private

  def calculate_label
    case face
    when '10' then face
    else           face[0]
    end
  end

  def calculate_value
    case face
    when 'Jack', 'Queen', 'King' then 10
    when 'Ace'                   then nil
    # Ace value can't be determined at this point
    else                              face.to_i
    end
  end
end

class Ace < Card
  VALUES = [1, 11]

  def assign_value(sum, remaining_ace_count)
    hypothetical_sum = sum + VALUES.max + remaining_ace_count

    self.value = if hypothetical_sum > TwentyOneGame::BUST_LIMIT
                   VALUES.min
                 else
                   VALUES.max
                 end
  end

  private

  attr_writer :value
end
