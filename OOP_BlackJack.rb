#player to model both players
#human extend from player to model user
#computer extend from player to model dealer
#card to model card, include value and suit
#game to model the whole gaming process, include calculate value, determine win, and replay

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def print_card
    print "{#{value} of #{suit}}"
  end
end

class Deck

  attr_accessor :deck

  SUITS = ['SPADE','HEART','DIAMOND','CLUB']
  VALUES = ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace']

  def initialize #create a deck of cards using suits and values, then shuffle! the deck
    @deck = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @deck << Card.new(suit, value)
      end
    end
    @deck.shuffle!
  end

  def pop
    @deck.pop
  end

end

class Player
  attr_accessor :cards, :player_sum, :name, :string

  def initialize(name)
    @player_sum = 0 #keep track of the sum of the player's cards
    @cards = [] #keep track of player's cards
  end

  def print_cards
    @string = ""
    @cards.each do |card|
      #@string + card.value.to_s + " of " card.suit.to_s
    end
    @string
  end

end

module HelpMethods

  def calculate_total(cards)
    sum = 0
    cards.each do |card|
      sum += card2value(card.value)
    end
    cards.select{|card| card.suit == "Ace"}.count.times do
      sum -= 10 if sum > 21
    end
    sum
  end

  def card2value(card)
    card_values = {'2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'Jack'=>10, 'Queen'=>10, 'King'=>10, 'Ace'=>11}
    return card_values.fetch(card)
  end

  def bust_or_blackjack?(player)
    if player.name != 'Matrix' #player is not computer

      if player.player_sum == 21 #check if user hit BlackJack
        p "============================================"
        p "BLACKJACK!!! #{player.name.upcase}! YOU WON!"
        p "============================================"
      elsif player.player_sum > 21
        puts "KABOOM! #{player.name}, you went bust..."
      end

    end #end if

    if player.name == 'Matrix'
      if player.player_sum > 21
        puts "Congrats, dealer just went bust, you win!"
      elsif player.player_sum == 21
        puts "Sorry, looks like dealder hit BlackJack..."
      end
    end


  end


end #end HelpMethods

class Human < Player
  include HelpMethods

end

class Computer < Player
  include HelpMethods

end

class BlackJack
  include HelpMethods

  def initialize
    @deck = Deck.new
    @human = Human.new('Neo')
    @computer = Computer.new('Matrix')
    @computer.name = "Matrix"
    @playing = true

    2.times do
      @human.cards << @deck.pop
      @computer.cards << @deck.pop
    end

    @human.player_sum = calculate_total(@human.cards)
    @computer.player_sum = calculate_total(@computer.cards)

  end

  def intro
    puts "Welcome to Blackjack!"
    puts "Please enter your name:"
    @human.name = gets.chomp

  end

  def player_turn(player)

    p "#{player.name}, you have: #{player.cards}, your total is: #{player.player_sum}"

    if player.player_sum == 21 #check if user hit BlackJack
      p "Congradulations #{player.name}! You hit BlackJack!"
    end

    while player.player_sum < 21 #the player's turn

      begin
        puts "#{player.name}, please enter one of the following choices: 1)Hit or 2)Stay"
        user_input = gets.chomp
      end until [1,2].include?(user_input.to_i)

      if user_input.to_i == 2
        puts "#{player.name}, you have chosen to stay!"
        break
      end

      player.cards <<  @deck.pop
      player.player_sum = calculate_total(player.cards)

      p "#{player.name}, you have: #{player.cards}"
      puts "Your total is: #{player.player_sum}"

      if player.player_sum > 21
        puts "KABOOM! #{player.name}, you went bust!"
        break
      elsif player.player_sum == 21
        puts "BLACKJACK!!! Congrats #{player.name}, you win!"
        break
      end

    end#end while

  end#end player_turn

  def computer_turn(computer)
    if computer.player_sum == 21 #the dealer's turn
      p "Sorry, looks like dealer hit BlackJack..."
      #exit
    end

    while computer.player_sum < 17
      computer.cards << @deck.pop
      p "The dealder's cards are: #{computer.cards}"
      computer.player_sum = calculate_total(computer.cards)

      if computer.player_sum > 21
        puts "Congrats, dealer just went bust, you win!"
      elsif computer.player_sum == 21
        puts "Sorry, looks like dealder hit BlackJack..."
      end
    end #end of dealer's turn

  end #end computer_turn

  def check_win(computer, player, name)
    player.player_sum = calculate_total(player.cards)
    computer.player_sum = calculate_total(computer.cards)
    puts "your card total is: #{player.player_sum}"
    puts "dealer card total is: #{computer.player_sum}"
    if player.player_sum > computer.player_sum
      puts "Congrats #{name}, you win, top job!"
    elsif player.player_sum < computer.player_sum
      puts "Sorry, you lose!"
    elsif player.player_sum == computer.player_sum
      puts "Tie, no one wins."
    end
  end

  def replay
    begin
      puts "Do you want to play again? (Y/N)"
      user_input = gets.chomp.downcase
      if user_input == 'y'
        BlackJack.new.play
      elsif user_input == 'n'
        puts "================Thank you for playing!===================="
        puts "This game is created by Eugene Chang a.k.a ToxicStar, 2014"
        puts "=========================================================="
        @playing == false
        #exit
      end
    end until ['y','n'].include?(user_input)
  end

  def play
     begin
       intro
       player_turn(@human)

       if @human.player_sum < 21 #if player did not went bust
         computer_turn(@computer)

         if @computer.player_sum < 21 #if both player and dealer did not went bust
           check_win(@computer, @human, @human.name)
         end
       end
       replay
     end until @playing = false
     exit
  end

end

#Deck.new.print
BlackJack.new.play
