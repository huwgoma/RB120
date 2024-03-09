require 'pry'
require 'io/console'

require_relative 'displayable'
require_relative 'promptable'
require_relative 'deck'
require_relative 'card'
require_relative 'player'
require_relative 'result'

# EnforcedShorthandSyntax: either

# Orchestration Engine
class TwentyOneGame
  include Displayable
  include Promptable

  BUST_LIMIT = 21
  STARTING_CARD_COUNT = 2

  attr_reader :deck, :dealer, :punter, :players

  def initialize
    clear
    display_rules
    @deck = Deck.new(shuffle: true)
    @dealer = Dealer.new
    @punter = Punter.new
    @players = [punter, dealer]
  end

  def play
    loop do
      game_limit = choose_game_limit

      match_loop(game_limit)
      match_result = MatchResult.new(players)
      puts match_result

      break unless play_again?

      reset_game_state
      reset_match_state
    end
    display_goodbye
  end

  private

  def match_loop(game_limit)
    games_played = 0

    loop do
      clear
      play_game
      post_game

      games_played += 1
      break if games_played >= game_limit

      reset_game_state
      continue
    end
  end

  def play_game
    display_scores
    display_deal
    deal_starting_cards

    display_game_state
    player_turns
  end

  def deal_starting_cards
    players.each do |player|
      player.draw(deck.deal!(STARTING_CARD_COUNT))
    end
  end

  def player_turns
    players.each do |player|
      loop do
        move = player.choose_move
        move == 'H' ? hit(player) : stay(player)

        display_game_state(show_all: player == dealer)
        break if player.busted? || move == 'S'
      end

      break if player.busted?
    end
  end

  # Player draws
  def hit(player)
    display_hit(player)
    player.draw(deck.deal!)
  end

  # Player does nothing
  def stay(player)
    display_stay(player)
  end

  def post_game
    result = Result.new(players)
    increment_score(result.winner) unless result.tie?

    display_game_state(show_all: !punter.busted?)
    # show all unless punter busted
    puts result
  end

  def increment_score(winner)
    winner.increment_score
  end

  def reset_game_state
    players.each(&:discard_hand)
    deck.reset
    deck.shuffle!
  end

  def reset_match_state
    players.each(&:reset_score)
  end
end

TwentyOneGame.new.play
