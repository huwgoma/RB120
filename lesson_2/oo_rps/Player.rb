require_relative 'Move'
require_relative 'ClassConverter'

# Player Superclass
class Player
  attr_reader :move, :score

  def initialize
    set_name
    @score = 0
  end

  def increment_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end

  def to_s
    name
  end

  private

  attr_accessor :name
  attr_writer :move, :score
end

# Human Player
class Human < Player
  def set_name
    loop do
      puts "Please enter your name:"
      name = gets.chomp
      next puts "Your name can't be blank!" if name.strip.empty? 
      self.name = name
      break
    end
  end

  def choose_move
    puts "Please choose #{Move.choices}:"
    loop do
      choices = match_choices(gets.chomp)

      if choices.one?
        self.move = Move.new(choices.first, self)
        break
      elsif choices.empty?
        puts "Invalid input! Please enter one of the following choices:"
        puts "#{Move.choices}"
      else
        puts "Did you mean one of these?"
        puts choices
      end
    end    
  end

  private

  def match_choices(choice)
    Move::VALUES.select { |value| value.start_with?(choice.capitalize) }
  end
end

# CPU Player
class Computer < Player
  def initialize
    super
    @move_weights = calculate_weighted_ranges
  end

  def self.random_new
    self.subclasses.sample.new
  end

  def set_name
    self.name = self.class.to_s 
  end

  def choose_move
    random_num = rand(1..100)
    move_value = move_weights.find { |_move, range| range.include?(random_num) }.first
    self.move = Move.new(move_value, self)
  end

  private

  attr_reader :move_weights

  def calculate_weighted_ranges
    move_rates = self.class::MOVE_RATES
    range_start = 0

    Move::VALUES.each_with_object({}).with_index do |(move, ranges), index|
      move_rate = move_rates[index]
      next if move_rate.zero?

      range = calculate_range(range_start, move_rate) #=> eg. 1..20
      ranges[move] = range
      range_start = range.end
    end
  end

  def calculate_range(range_start, probability_rate)
    range_end = range_start + (probability_rate * 100)
    (range_start + 1)..range_end
  end
end

# # CPU Subclasses
# class RandomBot < Computer
#   MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]
# end

# class R2D2 < Computer
#   MOVE_RATES = [1.0, 0, 0, 0, 0]
# end

# class Hal < Computer
#   MOVE_RATES = [0.2, 0, 0.8, 0, 0]
# end

class Mahoraga < Computer
  #include ClassConverter
  
  MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

  def choose_move
    last_result = Result.history.last

    if last_result.nil? || last_result.tie?
      super
    else
      self.move = Move.new(calculate_adaptation(last_result), self)
    end
  end

  private 

  # Psychologically, players tend to repeat their hand if they win; if they lose, 
  # they tend to play a hand that would beat the hand they lost to.
  # To adapt:
  # - If Mahoraga wins, the other player is likely to pick a hand that beats the 
  #   previous winning hand.
  #   => Pick the hand that beats both options.
  #     eg. Rock (Win) -> Paper or Spock -> Lizard eats Paper and poisons Spock.
  #     => Pick Lizard
  # - If Mahoraga loses, the other player is likely to repeat the same hand.
  #   => Pick a hand that beats the previous hand.

  # After 4 rounds, simply pick a move that beats the other person's move (late throw)

  def calculate_adaptation(last_result)
    last_winning_value = last_result.winning_value
    first_adaptations = calculate_first_adaptations(last_winning_value)

    if result.winner == self
      calculate_second_adaptation(first_adaptations)
    else
      # possible_moves = Move.subclasses.select do |subclass|
      #   subclass::WINS_AGAINST.key?(result.winning_value)
      # end
      # possible_moves.sample.to_s
      # binding.pry
    end
    # Input: Result object of the last game to be played
    # Output: A String representing the value of the next move to be played

    # Algorithm:
    # Calculate the last winning value (eg. Rock)
    # Calculate the hands that win against the last winning value. (eg. Paper, Spock)
    # If the winner of the last round was Mahoraga:
    #   Calculate the hand that wins against both adapted options (eg. Lizard)
    # Otherwise, randomly select one of the adapted options.



  end

  def calculate_first_adaptations(last_winning_value)
    # Given a String representing the value of the last winning hand,
    # Find the possible move values that win against that last winning value
    # Return in an array.
    Move.subclasses.select do |hand|
      hand::WINS_AGAINST.key?(last_winning_value)
    end
  end

  def calculate_second_adaptation(hands)
    # Given an Array of Constants (Strings?) representing the hands that win against
    #   the last winning value,
    # Find the move value that wins against both of those first adapted hands
  end

end