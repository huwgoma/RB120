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
    # Refactor this so MOVE_RATES aren't necessary?
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

  def describe_personality
    puts "This CPU #{personality}"
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
class RandomBot < Computer
  MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

  def personality
    "will pick moves at complete random."
  end
end

class R2D2 < Computer
  MOVE_RATES = [1.0, 0, 0, 0, 0]

  def personality
    "will only pick Rock."
  end
end

class Hal < Computer
  MOVE_RATES = [0.1, 0, 0.7, 0.1, 0.1]

  def personality
    "will most likely pick Scissors, and will never pick Paper."
  end
end

class Mahoraga < Computer
  include ClassConverter

  MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

  def choose_move
    @last_result = Result.history.last

    if last_result.nil? || last_result.tie?
      super
    else
      self.move = Move.new(adapt_next_move, self)
    end
  end

  def personality
    "will adapt"
  end

  private

  attr_reader :last_result

  # Psychologically: Players tend to change their hand to what would have won (if they lose);
  # if they won, they will tend to stay with the same hand.
  def adapt_next_move
    first_adaptation = find_winning_hands(last_result.winning_value)

    move = if last_result.winner == self
             find_winning_hands(*first_adaptation).sample
           else
             first_adaptation.sample      
           end
    move || Move::VALUES.sample # Failsafe
  end

  def find_winning_hands(*values_to_beat)
    Move::VALUES.select do |hand|
      # Select all hands that are capable of winning against all given values.
      values_to_beat.all? { |value| class_of(hand)::WINS_AGAINST.keys.include?(value) }
      # (values_to_beat - class_of(hand)::WINS_AGAINST.keys).empty?
    end
  end
end

# 8-turn limit
# Need a data structure (maybe Result@@round_history?) to track games in a round
# - Clear between rounds.