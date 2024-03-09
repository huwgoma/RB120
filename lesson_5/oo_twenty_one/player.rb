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

  def draw(cards)
    add_to_hand(cards)
    update_hand_value
  end

  def busted?
    hand_value > TwentyOneGame::BUST_LIMIT
  end

  def display_hand(show_all: false)
    Card.display(hand, show_all: show_all)
  end

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
    aces, non_aces = hand.partition(&:ace?)
    sum = non_aces.sum(&:value)

    set_ace_values(aces, sum)

    sum + aces.sum(&:value)
  end

  def set_ace_values(aces, sum)
    aces.each_with_index do |ace, index|
      remaining_ace_count = aces.size - (index + 1)

      ace.assign_value(sum, remaining_ace_count)
      sum += ace.value
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
  end
end

# Punter - Player PoV
class Punter < Player
  include Promptable

  def display_hand(*)
    # Always show punter cards
    super(show_all: true)
  end
end
