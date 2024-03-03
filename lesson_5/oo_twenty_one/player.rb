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
    aces, other = hand.partition(&:ace?)
    sum = other.sum(&:value)
    
    aces.each_with_index do |ace, index|
      remaining_aces = aces.size - (index + 1)
      ace_max = Ace::VALUES.max
      
      if sum + ace_max + remaining_aces > BUST_LIMIT
        ace.set_value(:min)
      else
        ace.set_value(:max)
      end
    end

    sum + aces.sum(&:value)
      # Given an array of aces and a total sum of other card values:
      # Iterate through each ace, with index. For each ace:
      #   -> Calculate and set the value of that ace
      #   Calculate the number of remaining aces:
      #     - aces.size - (index + 1)
      #     eg. [A, A] - first ace, index 0
      #     Remaining aces: 1 (size - index + 1 => 1)
      #   Add ace's max value, remaining aces (*1), and total sum
      #   - If the result is greater than the BUST_LIMIT, set current ace value to
      #     its min
      #   - Otherwise, set current ace value to its max.
      # We have to re-calculate this every time, so change ace @value to a constant
      # 
      # if sum + ... > LIMIT
      #   ace.set_value
      # else

      # end
      # binding.pry
    # end

    # 1.upto(aces.size) do |n|
    #   remaining_aces = aces.size - n

    #   if sum + (11 + remaining_aces) > BUST_LIMIT
    #     sum += 1
    #   else
    #     sum += 11
    #   end
    # end

    # sum
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