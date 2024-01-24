require_relative 'Move'

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
  MOVE_RATES = [0.2, 0.2, 0.2, 0.2, 0.2]

  def choose_move
    last_result = Result.history(1).last
    if last_result.nil?
      super
    else
      last_winning_value = last_result.winner.move
      binding.pry
    end
    #binding.pry

    # Check the last result in Result.history.
    #   If history is blank (ie. first move), default to a random move (20%)
    # Otherwise:
    #   If it won last game, stay with the same hand.
    #   Otherwise (tied or lost), randomly pick a hand that would beat the winning hand
    



    # Checks the winning move that was made in the last game of Result.history
    #   If History is blank, default to random move (20%)
    # Randomly select a Move whose value wins against the last winning move's value

  end
end