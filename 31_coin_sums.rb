def count_combos(total, largest_denomination)
  return 0 if total < 0 # Invalid -- we added up to more than the total.
  return 1 if total == 0

  num_combos = 0
  for next_denomination in [200, 100, 50, 20, 10, 5, 2, 1]
    # To prevent dupes (e.g. 100 + 50 + 50 vs. 50 + 50 + 100), sort by denomination.
    next unless next_denomination <= largest_denomination

    num_combos += count_combos(total - next_denomination, next_denomination)
  end
  return num_combos
end

puts 'Total combinations:', count_combos(200, 200)
