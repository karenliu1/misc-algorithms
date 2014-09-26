def name_value(name)
  return name.split('')
    .map { |letter| letter.ord - 64 } # A is 1
    .reduce(:+)
end

File.open('p022_names.txt', 'r') do |f|
  names = f.gets.split(',')
  names.each do |name|
    name.tr!('\"', '') # Remove surrounding quotes
  end
  names.sort!

  total = 0
  for i in 0..names.length - 1
    total += (i+1) * name_value(names[i]) # i+1 because the 0th name is counted as the 1st
  end

  puts 'Total name score:', total
end
