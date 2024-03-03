# Player Superclass
class Player
  BUST_LIMIT = 21

  attr_reader :name, :hand

  def initialize
    @name = choose_name
    @hand = []
  end

  def to_s
    name
  end

  def add_to_hand(cards)
    hand.push(*cards)
  end

  def busted?
    calculate_hand_value > BUST_LIMIT
  end

  def display_hand
    puts hand
  end

  def hand_value
    calculate_hand_value
  end


  private

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

      if other_sum + ace_max + remaining_aces > BUST_LIMIT
        ace.set_value(:min)
      else
        ace.set_value(:max)
      end
    end
  end
end

# Dealer draws until 17
class Dealer < Player
  HIT_LIMIT = 17

  def choose_name
    'House'
  end

  def choose_move
    # Hit until hand total >= 17
    'H' # unless hand total >= 17
  end

  def display_hand(hidden: true)
    puts hand.first
    puts "#{(hand.size - 1)} hidden card."
  end

end

# Punter tries to beat the dealer
class Punter < Player
  def choose_name
    # What's your name?  (not empty)
    'Hugo'
  end
  
  def choose_move
    puts 'Would you like to (H)it or (S)tay?'
    loop do
      choice = gets.chomp.upcase
      return choice if %w(H S).include?(choice)
      puts 'Please enter either H or S!'
    end
    # Prompt for input, either hit or stay
  end
end