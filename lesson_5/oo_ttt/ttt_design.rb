require 'pry'
# 1) Describe the problem 
# 2) Extract nouns and verbs from problem description
# 3) Organize the verbs with the performing nouns
# 4) Make an initial guess at the class/method design, and do a spike to explore
#   the problem
# 5) CRC cards


# 1) Tic Tac Toe is a game in which 2 players take turns marking a 3-by-3 board
#   with their 'symbol' (typically X or O). The first player to mark 3 squares in
#   a row (horizontal, vertical, or diagonal - doesn't matter) wins.

# 2) Nouns: Game, Player (Symbol?), Turn, Board, Square
#    Verbs: take turns, marks, wins

# 3) Game (Engine)
#    Player
#     - marks, takes turns, wins
#    Turn
#    Board
#    Square

# 4) Spike
class Board
  GRID_LENGTH = 3
  WIN_CONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9],  # rows
              [1, 4, 7], [2, 5, 8], [3, 6, 9],  # columns
              [1, 5, 9], [3, 5, 7]]             # diagonals

  attr_reader :squares

  def initialize
    @squares = create_squares
  end

  def display
    system 'clear'
    puts " #{value_at(1)} | #{value_at(2)} | #{value_at(3)} "
    puts "---+---+---"
    puts " #{value_at(4)} | #{value_at(5)} | #{value_at(6)} "
    puts "---+---+---"
    puts " #{value_at(7)} | #{value_at(8)} | #{value_at(9)} "
  end
  # 3x3 grid of 'squares'
  # - each square can be represented with a Square object
  # - how to represent the 3x3 grid? hash (keys 0-9)? (nested) array?

  def create_squares
    (1..GRID_LENGTH ** 2).each_with_object({}) do |key, squares|
      squares[key] = Square.new
    end
  end

  def value_at(key)
    squares[key].value
  end

  def mark_at(key, value)
    squares[key].mark(value)
  end

  def unmarked_keys
    squares.keys.select { |key| squares[key].empty? }
  end

  def full?
    unmarked_keys.empty?
  end

  def has_winner?(current_marker)
    !!detect_winner(current_marker)
  end

  # Return the marker of the winner, or nil if no winner
  def detect_winner(current_marker)
    WIN_CONS.each do |line|
      return current_marker if winning_line?(line, current_marker)
    end
    nil
  end

  def winning_line?(line, marker)
    squares.values_at(*line).all? { |square| square.value == marker }
  end

  def reset
    squares.values.each(&:unmark)
  end
end


class Square
  attr_reader :value

  INITIAL_VALUE = ' '

  def initialize
    @value = INITIAL_VALUE
  end

  def mark(value)
    self.value = value
  end

  def unmark
    self.value = INITIAL_VALUE
  end

  def empty?
    value == INITIAL_VALUE
  end

  private

  attr_writer :value
  # Track the state of the square 
  # - Default state is empty (nil?)
  # - Can be marked by either 'X' or 'O' (strings?)
end

class Player
  attr_reader :marker, :board

  def initialize(marker, board)
    @marker = marker
    @board = board
  end
  # States: 
  # - Player's marker (X or O)
  # Behaviors:
  # - "Take turns playing" => choose_move
  #   #choose_move: Choose a square on the board, validate the choice, then mark the 
  #     square (by updating that square's state)
end

class Human < Player
  def choose_move
    puts "Choose an empty square (#{board.unmarked_keys.join(', ')}):"
    loop do
      num = gets.chomp.to_i
      return num if board.unmarked_keys.include?(num)
      puts "Sorry, that's not a valid choice."
    end
  end
end

class Computer < Player
  def choose_move
    board.unmarked_keys.sample
  end
end

class TTTGame
  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new('X', board)
    @computer = Computer.new('O', board)
  end

  def play
    display_welcome
    gets.chomp #pause

    board.display
    set_current_player
    # Program Loop
    loop do
      board.display
      
      # Game Loop
      loop do
        # display game state
        board.mark_at(current_player.choose_move, current_player.marker)
        board.display
        break if board.full? || board.has_winner?(current_player.marker)

        switch_current_player
      end

      display_result
      break unless play_again?
      board.reset
    end

    display_goodbye

  end


  def display_welcome
    system('clear')
    puts "Welcome to Tic Tac Toe!"
  end

  def set_current_player
    @current_player, @next_player = human, computer
  end

  def switch_current_player
    self.current_player, self.next_player = next_player, current_player
  end

  private

  attr_accessor :current_player, :next_player

  def display_result
    case board.detect_winner(current_player.marker)
    when human.marker    then puts 'You won!'
    when computer.marker then puts 'Computer won!'
    else                      puts "It's a tie!"
    end

  end

  def play_again?
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      return answer == 'y' if %w(y n).include?(answer)
      puts "Sorry - please enter y or n."
    end
  end

  def display_goodbye
    puts "Thanks for playing - goodbye!"
  end
end

TTTGame.new.play
