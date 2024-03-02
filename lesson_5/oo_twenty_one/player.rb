# Player Superclass
class Player
  attr_reader :name, :hand

  def initialize
    @name = choose_name
    @hand = []
  end

  def add_to_hand(cards)
    hand.push(*cards)
  end

  def busted?
    hand.size > 3
  end




  def hit
    # Draw a card
    add_to_hand(cards)
  end

  def stayed?
    # toggle true when player stays, otherwise false
  end

  def hand_value
    # Calculate the current value in @hand
    # - Need scoring rules for Aces
  end

  private
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