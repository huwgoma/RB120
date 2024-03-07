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

  # => Displayable?
  def display_hand
    lines = hand.each_with_object([]) do |card, lines|
      binding.pry
    
    
    end
      puts hand
  end

  # Display Hand Refactor - Display full hands
  # +-----+ +------+
  # |♣    | |♣     |
  # |  ?  | |  10  |
  # |    ♣| |     ♣|
  # +-----+ +------+ 
  # single  double

  # Input: Array of card objects, @hand
  # Output: Visual representation of the cards in the hand
  #   - Need to print line by line

  # Data: 
  # - The array of card objects (@hand)
  # - Iterate through each card and determine the:
  #   - width of the card
  #   - suit and face (face determines width)
  #   eg. [Ace(♣, Ace), Card(♣, 9), Card(♣, 10)]
  #   display_strings = ['', '', '', '', '']
  
  # Algorithm eg. [Ace(♣, Ace), Card(♣, 9), Card(♣, 10)]
  #   display_strings = ['', '', '', '', '']
  # Iterate through cards. For each card:
  #   - Ask the card for its display_value => ['A', '9', '10']
  #   - Calculate the inner_width of the card, based on display_value.
  #     - If display_value size is 1, i_width is 7; if 2, i_width = 8
  #   - Update the lines in display_strings:
  #   1) "+", "-" * inner width, "+"
  #   2) "|", suit right pad space to inner width, "|"
  #   3) "|", display value.center space to inner width, "|"
  #   4) "|", suit left pad space to inner width, "|"
  #   5) same as 1)
  # - Update the corresponding string in display_strings 



  # - Maybe create another array - 5 elements (strings), 1 for each line. 


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

  private

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

  def display_hand(full: false)
    if full
      puts hand
    else
      puts "#{hand.first} + #{hand.size - 1} hidden card(s)."
    end
  end

end

# Punter tries to beat the dealer without going over 21
class Punter < Player
  include Promptable 
end