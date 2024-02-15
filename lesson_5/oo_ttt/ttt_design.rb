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

  def initialize
    @squares = create_squares
  end

  def display
    puts " #{value_at_square(1)} | #{value_at_square(2)} | #{value_at_square(3)} "
    puts "---+---+---"
    puts " #{value_at_square(4)} | #{value_at_square(5)} | #{value_at_square(6)} "
    puts "---+---+---"
    puts " #{value_at_square(7)} | #{value_at_square(8)} | #{value_at_square(9)} "
  end
  # 3x3 grid of 'squares'
  # - each square can be represented with a Square object
  # - how to represent the 3x3 grid? hash (keys 0-9)? (nested) array?

  def create_squares
    (1..GRID_LENGTH ** 2).each_with_object({}) do |key, squares|
      squares[key] = Square.new
    end
  end

  def value_at_square(key)
    @squares[key].value
  end

end


class Square
  attr_reader :value

  INITIAL_VALUE = ' '

  def initialize
    @value = INITIAL_VALUE
  end
  # Track the state of the square 
  # - Default state is empty (nil?)
  # - Can be marked by either 'X' or 'O' (strings?)
end

class Player
  # States: 
  # - Player's marker (X or O)
  # Behaviors:
  # - "Take turns playing" => choose_move
  #   #choose_move: Choose a square on the board, validate the choice, then mark the 
  #     square (by updating that square's state)
end

class TTTGame
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    display_welcome
    # set current player (random?)
    
    loop do
      board.display
      # display_board #(game state)
      # current_player.choose_move
      # break if someone_won? || board_full?
      # switch current player
      break
    end

    # display game result
    display_goodbye
  end

  def display_welcome
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye
    puts "Thanks for playing - goodbye!"
  end
end

TTTGame.new.play
