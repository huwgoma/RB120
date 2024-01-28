require_relative 'move'
require_relative 'class_converter'

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
  def choose_move
    puts "Please choose one of #{Move.choices}:"
    loop do
      choices = match_choices(gets.chomp)

      if valid_choice?(choices)
        self.move = Move.new(choices.first, self)
        break
      else
        puts move_choice_error(choices)
      end
    end
  end

  private

  def set_name
    loop do
      puts "Please enter your name:"
      name = gets.chomp
      next puts "Your name can't be blank!" if name.strip.empty?
      self.name = name
      break
    end
  end

  def valid_choice?(choices)
    choices.one?
  end

  def move_choice_error(choices)
    if choices.empty?
      "Invalid input! Please enter one of the following choices:
#{Move.choices}"
    else
      "Did you mean one of these?
#{choices.join(', ')}"
    end
  end

  def match_choices(choice)
    Move::VALUES.select { |value| value.start_with?(choice.capitalize) }
  end
end

# CPU Player
class Computer < Player
  def initialize(_opponent)
    super()
    introduce
    @weighted_moves = calculate_move_weights
  end

  def self.random_new(opponent)
    subclasses.sample.new(opponent)
  end

  def choose_move
    self.move = Move.new(generate_random_move, self)
  end

  private

  attr_reader :weighted_moves

  def set_name
    self.name = self.class.to_s
  end

  def introduce
    puts "You will be playing against #{name} this round."
    puts "This CPU #{personality}"
  end

  def generate_random_move
    if weighted_moves
      random_num = rand(1..100)
      weighted_moves.find { |_move, range| range.include?(random_num) }.first
    else
      Move::VALUES.sample
    end
  end

  def calculate_move_weights
    return unless self.class.const_defined?('MOVE_RATES')

    move_rates = self.class::MOVE_RATES
    range_start = 0

    Move::VALUES.each_with_object({}).with_index do |(move, ranges), index|
      move_rate = move_rates[index]
      next if move_rate.zero?

      range = calculate_range(range_start, move_rate)
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

  def initialize(opponent)
    super(opponent)
    @opponent = opponent
    
    @adaptations = initialize_adaptations
  end

  def choose_move
    increment_adaptation
    self.move = Move.new(calculate_move, self)
  end

  def personality
    "will adapt to your moves.
If you don't end the game quickly, you might have a bit of trouble..."
  end

  private

  attr_reader :opponent, :adaptations

  def initialize_adaptations
    Move::VALUES.map { |value| [value, 0] }.to_h
  end

  def increment_adaptation
    adaptations[opponent.move.value] += 1
  end

  def calculate_move
    last_result = Result.history.last

    moves = if fully_adapted?(opponent.move.value)
              late_throw
            elsif first_game?(last_result) || last_result.tie?
              Move::VALUES
            else
              adapt_move(last_result)
            end
    moves.sample
  end

  def fully_adapted?(value)
    adaptations[value] >= 4
  end

  def first_game?(last_result)
    last_result.nil?
  end

  def won_last_game?(last_result)
    last_result.winner == self
  end

  def late_throw
    find_winning_values(opponent.move.value)
  end

  # Psychologically:
  # - If someone wins, they are likely to stay with the same hand.
  # - If they lose, they are likely to switch to a hand that would
  #   have beaten the previous winning hand.
  def adapt_move(last_result)
    first_adaptation = find_winning_values(last_result.winning_value)

    if won_last_game?(last_result)
      find_winning_values(*first_adaptation)
    else
      first_adaptation
    end
  end

  def find_winning_values(*values_to_beat)
    Move::VALUES.select do |value|
      (values_to_beat - class_of(value)::WINS_AGAINST.keys).empty?
    end
  end
end
