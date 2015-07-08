#Method def start

def initialize_deck
  # Define cards and playing deck

  suits = ['♥', '♦', '♠', '♣']
  numbers = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  $playing_cards = numbers.product(suits)
  number_of_decks = 0
  while number_of_decks < 1 || number_of_decks > 5
    puts "How many decks do you want to play with (1-5)?"
    number_of_decks = gets.chomp.to_i
  end
  $playing_cards *= number_of_decks
  puts "You are playing with #{$playing_cards.count} cards."
  $playing_cards.shuffle!
end

def deal_initial_hand
  $dealer_hand = []
  $player_hand = []
  2.times do
    $dealer_hand.push $playing_cards.pop
    $player_hand.push $playing_cards.pop
  end
end

#Define card points

def get_card_points card
  points = card[0].to_i
  if points == 0
    if card[0] == 'A'
      points = 1;
    else points = 10
    end
  end
  return points
end

#Calcumlate total

def get_total_points hand
  sum = 0
  number_of_aces = 0
  for card in hand
    card_pts = get_card_points card
    if card_pts == 1
      number_of_aces += 1
    end
      sum += card_pts
  end
  number_of_aces.times do
    (sum <= 11) ? sum += 10 : break
  end
  return sum
end

#Method def end
initialize_deck
deal_initial_hand

puts "Dealer hand: #{$dealer_hand.first},hidden"
puts "Player hand: #{$player_hand}"

dealer_total = 0
player_total = 0


stop_playing = false
player_busted = false

while !stop_playing
  user_choice = " "
  while user_choice !='H' && user_choice !='S'
    puts 'Hit (H) or Stay (S)?'
    user_choice = gets.chomp.upcase
  end
  player_total = get_total_points $player_hand
  if user_choice =='H'
    $player_hand.push $playing_cards.pop
    player_total = get_total_points $player_hand
    puts "Player hand #{$player_hand}"
    if player_total > 21
      puts "Bust! You lose."
      stop_playing = true
      player_busted = true
    end
    if player_total == 21
      puts "BLACKJACK!!! You win!"
      stop_playing = true
    end
  else
    break
  end
end

if !player_busted
  stop_playing = false
  while !stop_playing
    dealer_total = get_total_points $dealer_hand
    if dealer_total >= 17
      stop_playing = true
      puts "Dealer hand #{$dealer_hand}"
      puts "Player hand #{$player_hand}"
      if dealer_total > 21
        puts "Dealer Busts!"
      else
        puts "Dealer total: #{dealer_total}"
        puts "Player total: #{player_total}"
      end
    end
    $dealer_hand.push $playing_cards.pop
  end
end

if (player_total > 21 || (dealer_total < 22 && dealer_total >= player_total))
  puts "Dealer Wins!"
else
  puts "Player Wins!"
end