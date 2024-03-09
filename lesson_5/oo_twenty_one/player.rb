# Player Superclass
class Player
  attr_reader :name, :hand, :hand_value, :score

  def initialize
    @name = choose_name
    @hand = []
    @hand_value = 0
    @score = 0
  end

  def to_s
    name
  end

  def hit(cards)
    add_to_hand(cards)
    update_hand_value
  end

  def busted?
    hand_value > TwentyOneGame::BUST_LIMIT
  end

  # => Move to Card.display when done
  # "\t" question? space with 10s
  def display_hand(show_all: false)
    card_lines = build_card_strings(show_all: show_all)
    puts card_lines
  end

  # full: true by default (so by default, display all cards)
  # dealer - override -> super (full: false)
  # When building card strings, 
  #   If full is FALSE, hide all cards after the first
  #   - Set the inner width, card suit, and card labels. If full is false, 
  #     inner width = min, card suit = ?, card label = ?
  #   ? ? ? 

  def discard_hand
    hand.clear
  end

  def increment_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end

  private

  attr_writer :score, :hand_value

  def add_to_hand(cards)
    hand.push(*cards)
  end

  def update_hand_value
    self.hand_value = calculate_hand_value
  end

  def calculate_hand_value
    aces, other = hand.partition(&:ace?)
    other_sum = other.sum(&:value)

    set_ace_values(aces, other_sum)
    
    other_sum + aces.sum(&:value)
  end

  def build_card_strings(show_all: false)
    # if card == hand.first
    hand.each_with_object(['', '', '', '', '']) do |card, strings|
      suit, label, inner_width = calculate_card_parameters(card, show_all: show_all)
      
      strings[0] += "+#{'-' * inner_width}+\s"
      strings[1] += "|#{suit.ljust(inner_width, ' ')}|\s"
      strings[2] += "|#{label.center(inner_width, ' ')}|\s"
      strings[3] += "|#{suit.rjust(inner_width, ' ')}|\s"
      strings[4] += "+#{'-' * inner_width}+\s"
    end
  end

  # extract here
      # if card == hand.first || hide is not true, show normal card
    # else hide card
  def calculate_card_parameters(card, show_all: false)
    if show_all || card == hand.first
      full_card_parameters(card)
    else
      hidden_card_parameters(card)
    end

    # if show_all || card == hand.first
    #   suit = card.suit
    #   label = card.label
    #   inner_width = label.length == 1 ? Card::INNER_WIDTHS.min : Card::INNER_WIDTHS.max
    # else
    #   suit = '?'
    #   label = '?'
    #   inner_width = Card::INNER_WIDTHS.min
    # end

    # [suit, label, inner_width]
  end

  def full_card_parameters(card)
    suit = card.suit
    label = card.label
    inner_width = label.length + 4 # WIDTH_MODIFIER (add)
    [suit, label, inner_width]
  end

  def hidden_card_parameters(card)
    ['?', '?', 5]
  end

  def set_ace_values(aces, other_sum)
    aces.each_with_index do |ace, index|
      remaining_aces = aces.size - (index + 1)
      ace_max = Ace::VALUES.max

      if other_sum + ace_max + remaining_aces > TwentyOneGame::BUST_LIMIT
        ace.set_value(:min)
      else
        ace.set_value(:max)
      end

      other_sum += ace.value
    end
  end
end

# Dealer draws until 17
class Dealer < Player
  HIT_LIMIT = 17

  def choose_name
    'Dealer'
  end

  def choose_move
    hand_value >= HIT_LIMIT ? 'S' : 'H'
  end

  def display_hand(show_all: false)
    # Hide dealer cards by default, but allow them to be optionally displayed
    super(show_all: show_all) 
    

    # if full
    #   puts hand
    # else
    #   puts "#{hand.first} + #{hand.size - 1} hidden card(s)."
    # end
  end

end

# Punter tries to beat the dealer without going over 21
class Punter < Player
  include Promptable 

  def display_hand(show_all: true)
    # Always show punter cards
    super(show_all: true)
  end
end