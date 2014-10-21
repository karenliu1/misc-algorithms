def is_palindrome?(number)
  str = number.to_s
  for i in 0..str.length/2
    return false if str[i] != str[str.length - 1 - i]
  end
  return true
end

def is_lychrel?(number)
  50.times do
    sum = number + number.to_s.reverse.to_i
    return false if is_palindrome?(sum)
    number = sum
  end
  return true
end

lychrel_numbers = (1..10_000).to_a.select { |num| is_lychrel?(num) }
puts 'Lychrel numbers below 10,000:', lychrel_numbers.size
