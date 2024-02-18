class Player
  attr_reader :marker, :name

  def initialize(marker)
    @marker = marker
    @name = choose_name
  end

  def to_s
    name
  end
end

class Human < Player
  def choose_move(valid_choices)
    puts "Choose an empty square (#{valid_choices.join(', ')}):"
    loop do
      num = gets.chomp.to_i
      return num if valid_choices.include?(num)
      puts "Sorry, that's not a valid choice."
    end
  end

  def choose_name
    puts "What's your name?"
    loop do
      name = gets.chomp.strip
      return name unless name.empty?
      puts "You can't have an empty name!"
    end
  end
end

class Computer < Player
  def choose_move(valid_choices)
    valid_choices.sample
  end

  def choose_name
    'Mahoraga'
  end
end