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

  total = names
    .map.with_index { |name, i| (i+1) * name_value(name) } # i+1 so 0th -> 1st
    .reduce(:+)

  puts 'Total name score:', total
end
