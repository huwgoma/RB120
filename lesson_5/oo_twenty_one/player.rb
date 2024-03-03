# Player Superclass
class Player
  BUST_LIMIT = 21

  attr_reader :name, :hand

  def initialize
    @name = choose_name
    @hand = []
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

  def calculate_hand_value
    # Input: An array of Card objects with Integer values 
    # - Aces are the sole exception; their value is either 1 or 11 (repped by array)
    # Output: An integer (sum of Card values)
    # Rules:
    #   - Aces are worth either 1 or 11, depending on the rest of the hand's value.
    #     - If the 
    #     - Otherwise it's worth 1

    # Examples:
    # [King, 7] => 17
    # [Ace, King] => 21
    # [Ace, Ace, King] => 12 (10+1+1)
    # [Ace, Ace, 9] => 21 (9+11+1)
    # [Ace, Ace, King, 10] => 22 (10 + 10 + 1 + 1)

    # Data: 
    # Array of cards given as input
    # - Maybe partition cards into aces/non-aces?
    # - Sum the non-aces first to obtain the non-ace total
    # - For each ace, 
    #   - Add 11 + (1 * number of remaining aces) to non-ace total
    #     - if the resulting sum exceeds 21, add 1 instead

    # eg. [7, 3, A, A]
    # non-ace total: 10
    # [A, A] - Try adding 12 (11+1) to 10 => 22 - greater than 21, so add 1 instead

    # (Total: 10), 2 Aces 1..2
    # First Ace:
    #   10 + 11 + 1 (1: 2 - 1)
    # second Ace:
    #   11 + 11 (0: 2 - 2)

    # [7, 4, A]
    # Add 11 to 10 -> 21

    aces, other = hand.partition(&:ace?)
    sum = other.sum(&:value)

    1.upto(aces.size) do |n|
      remaining_aces = aces.size - n

      if sum + (11 + remaining_aces) > BUST_LIMIT
        sum += 1
      else
        sum += 11
      end
    end

    sum
    # Algorithm:
    # Given an array of card objects, cards:
    # Partition cards into aces and non-aces. 
    # Iterate through non-aces and sum them by their integer values (non-ace-sum)
    
    # Iterate from 1 up to N (number of aces). For each loop:
    #   Add 11 + (aces.size - n) to non ace sum
    #   - If result is greater than 21, increment sum by 1; otherwise, by 11
    #   ...
    #   Return sum
    #   
    # 
   

    
    # Should we modify the Ace value?
    # If sum + (11 + remaining_aces) >LIMIT
    #   ace.value = ace.value.min
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