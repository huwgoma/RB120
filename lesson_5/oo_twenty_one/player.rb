# Player Superclass
class Player
  BUST_LIMIT = 21

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
    hand_value > BUST_LIMIT
    # Move BUST_LIMIT out of here
  end

  def display_hand
    puts hand
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
  def choose_name
    puts "What's your name?"
    loop do
      name = gets.chomp.strip
      return name unless name.empty?
      puts "Your name can't be empty!"
    end
  end
  
  def choose_move
    puts 'Would you like to (H)it or (S)tay?'
    loop do
      choice = gets.chomp.upcase
      return choice if %w(H S).include?(choice)
      puts 'Please enter either H or S!'
    end
  end
end