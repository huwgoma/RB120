# Module for methods that involve prompting user for input
module Promptable
  include Validatable

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

  def choose_game_limit
    puts 'How many games would you like to play? (1-10)'
    loop do
      games = gets.chomp
      return games.to_i if ('1'..'10').include?(games)
      puts 'Please pick a number between 1 and 10!'
    end
  end

  def continue
    puts 'Press any key to continue:'
    STDIN.getch
  end

  def play_again?
    puts 'Do you want to play again? (Y/N)'

    loop do
      choice = gets.chomp.upcase
      return choice == 'Y' if %w(Y N).include?(choice)
      puts 'Please enter either Y or N!'
    end
  end
end