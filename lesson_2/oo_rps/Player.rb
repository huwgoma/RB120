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
  def initialize(opponent)
    super()
    @opponent = opponent
    # Refactor this so MOVE_RATES aren't necessary?
    @move_weights = calculate_weighted_ranges
  end

  def self.random_new(opponent)
    self.subclasses.sample.new(opponent)
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

  attr_reader :opponent, :move_weights

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

# CPU Subclasses
# class RandomBot < Computer
#   MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

#   def personality
#     "will pick moves at complete random."
#   end
# end

# class R2D2 < Computer
#   MOVE_RATES = [1.0, 0, 0, 0, 0]

#   def personality
#     "will only pick Rock."
#   end
# end

# class Hal < Computer
#   MOVE_RATES = [0.1, 0, 0.7, 0.1, 0.1]

#   def personality
#     "will most likely pick Scissors, and will never pick Paper."
#   end
# end

# Mahoraga
class Mahoraga < Computer
  include ClassConverter

  MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

  def initialize(opponent)
    super(opponent)
    @adaptation_counter = 0
  end

  def choose_move
    self.move = Move.new(calculate_move, self)
    @adaptation_counter += 1
  end

  def personality
    "will adapt to your moves. If you don't end the game quickly, you might have a bit of trouble..."
  end

  private

  # Return a String value representing the next move
  def calculate_move
    return late_throw if fully_adapted?
    Move::VALUES.sample
    # If 8 turns have passed (fully adapted?), return late_throw 
    #   => 'Value' that will always win

    # If first_game? or last_game_tied?, choose a random value (Move::VALUES.sample)

    # Else (Not first game, and not tied last time):
    #   adapt_move
  end



  # attr_reader :last_result

  def fully_adapted?
    @adaptation_counter >= 8
  end

  def late_throw
    find_winning_hands(opponent.move.value).sample
  end

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

# Bug with Result.history and last_result.nil?


# Implement new data structure in Result, keeping track of games specifically within a round.

# 8-turn limit
# Need a data structure (maybe Result@@round_history?) to track games in a round
# - Reset between rounds.


# If Result.round_history.size >= 8, late_throw (cheat)

# Else: If last_game tied? or first_game? (last_game.nil), super (random)

# Else: 