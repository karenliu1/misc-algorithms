def get_val(card)
  case card[0]
  when 'T'
    return 10
  when 'J'
    return 11
  when 'Q'
    return 12
  when 'K'
    return 13
  when 'A'
    return 14
  else
    return Integer(card[0])
  end
end

def get_suit(card)
  return card[1]
end

def is_flush?(suits)
  return suits.uniq.count == 1
end

def is_straight?(vals)
  current_val = vals[0] # Pick first val as pivot
  num_consecutive = 1

  # Count consecutive numbers below
  loop do
    current_val -= 1
    current_val = 14 if current_val == 1 # Ace is represented as 14
    if vals.include?(current_val)
      num_consecutive += 1
    else
      break
    end
  end

  # Count consecutive numbers above
  current_val = vals[0]
  loop do
    current_val += 1
    current_val = 2 if current_val == 15
    if vals.include?(current_val)
      num_consecutive += 1
    else
      break
    end
  end

  return num_consecutive == 5
end

# Returns the list of values that occur exactly n times
def of_n_kind(vals, n)
  return vals.select { |v| vals.count(v) == n }.uniq
end

# Returns the number of values that occur exactly n times
def num_of_n_kind(vals, n)
  return of_n_kind(vals, n).count
end

# Returns rank as integer. 0 for high card only, 9 for royal flush
def best_rank(hand)
  vals = hand.map { |card| get_val(card) }
  suits = hand.map { |card| get_suit(card) }

  return 9 if is_flush?(suits) && vals.sort == [10, 11, 12, 13, 14]
  return 8 if is_flush?(suits) && is_straight?(vals)
  return 7 if num_of_n_kind(vals, 4) == 1
  return 6 if num_of_n_kind(vals, 3) == 1 && num_of_n_kind(vals, 2) == 1
  return 5 if is_flush?(suits)
  return 4 if is_straight?(vals)
  return 3 if num_of_n_kind(vals, 3) == 1
  return 2 if num_of_n_kind(vals, 2) == 2
  return 1 if num_of_n_kind(vals, 2) == 1
  return 0
end

# Returns all rank cards, sorted by precedence
def best_cards_in_rank(vals, rank)
  case rank
  when 7 then return of_n_kind(vals, 4)
  when 6 then return of_n_kind(vals, 3).concat(of_n_kind(2))
  when 3 then return of_n_kind(vals, 3)
  when 2 then return of_n_kind(vals, 2).sort.reverse
  when 1 then return of_n_kind(vals, 2)
  else return vals.sort.reverse
  end
end

# Returns 1 if player 1 wins, 0 otherwise
def p1_won?(p1_hand, p2_hand)
  # First, compare the hand rank
  p1_rank = best_rank(p1_hand)
  p2_rank = best_rank(p2_hand)

  return 1 if p1_rank > p2_rank # Player 1 clearly wins
  return 0 if p2_rank > p1_rank # Player 2 clearly wins

  p1_vals = p1_hand.map { |card| get_val(card) }
  p2_vals = p2_hand.map { |card| get_val(card) }

  # If tied, compare best cards for rank
  p1_sorted = best_cards_in_rank(p1_vals, p2_rank)
  p2_sorted = best_cards_in_rank(p2_vals, p2_rank)

  for i in 0..p1_sorted.length-1
    return 1 if p1_sorted[i] > p2_sorted[i]
    return 0 if p1_sorted[i] < p2_sorted[i]
  end

  # If still tied, compare highest card in hand
  p1_sorted = p1_vals.sort.reverse
  p2_sorted = p2_vals.sort.reverse

  for i in 0..p1_sorted.length-1
    return 1 if p1_sorted[i] > p2_sorted[i]
    return 0 if p1_sorted[i] < p2_sorted[i]
  end

  raise 'No clear winner' # Should never get here
end

File.open('p054_poker.txt', 'r') do |f|
  p1_wins = 0
  f.each_line do |line|
    hands = line.split(' ')
    p1_hand = hands[0..4]
    p2_hand = hands[5..9]
    p1_wins += p1_won?(p1_hand, p2_hand)
  end
  puts 'Number of wins by Player 1:', p1_wins
end
