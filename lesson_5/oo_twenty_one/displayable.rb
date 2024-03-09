# Module for Display/Announce methods
module Displayable
  def clear
    system('clear')
  end

  def pause
    sleep(1)
  end

  def display_rules
    puts 'Welcome to Twenty One!'
    puts <<~HEREDOC
      The rules of this game are as follows:
      1) You and the CPU ('Dealer') will both start with 2 cards. You will
         see all of your cards, but only 1 of the Dealer's cards.
      2) The goal is to get your hand's value as close to 21 as possible without
         going over.
      3) On your turn, you may either 'Hit' (Draw a card) or 'Stay' (Pass).
      4) When you choose to Stay, the Dealer will take his turn. The Dealer must
         Hit until their hand's value reaches at least 17, after which they must
         Stay.
      5) If either player's hand exceeds 21, they bust and immediately lose. If#{' '}
         nobody busted, the player with the higher hand value wins.
    HEREDOC
  end

  def display_game_state(show_all: false)
    clear
    display_scores
    puts "\n"
    display_hands(show_all: show_all)
  end

  def display_hands(show_all: false)
    players.reverse_each do |player|
      puts "#{player}'s hand:"

      player.display_hand(show_all: show_all)

      puts "\n"
    end
  end

  def display_player_switch
    puts 'Switching players...'
    sleep(1)
  end

  def display_scores
    players.each do |player|
      print "#{player}: #{player.score}\t\t"
    end
    puts "\n"
  end

  def display_hit(player)
    puts "#{player} chose to hit - now drawing..."
    pause
  end

  def display_stay(player)
    action = player == punter ? 'Switching players' : 'Ending game'
    puts "#{player} chose to stay. #{action}..."
    pause
  end

  def display_deal
    puts 'Now dealing...'
    pause
  end

  def display_goodbye
    puts 'Thanks for playing Twenty-One!'
  end
end
