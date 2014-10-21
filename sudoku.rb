# Example from http://www.puzzles.ca/sudoku_puzzles/sudoku_easy_177.html
GRID = [
  [9   , nil , nil , nil , nil , 7   , 1   , nil , nil] ,
  [nil , nil , nil , nil , nil , 9   , nil , 6   , 7]   ,
  [nil , nil , 6   , nil , nil , nil , 8   , nil , nil] ,
  [nil , 8   , 1   , 6   , nil , nil , 3   , nil , nil] ,
  [nil , nil , nil , nil , 8   , 5   , nil , nil , 9]   ,
  [7   , nil , nil , nil , nil , nil , nil , nil , nil] ,
  [nil , 5   , nil , nil , 2   , nil , nil , nil , 4]   ,
  [nil , 2   , nil , nil , nil , nil , 9   , nil , nil] ,
  [nil , nil , 9   , nil , 3   , nil , nil , nil , nil]
]

def is_valid?(solution)
  # No row can contain duplicates
  (0..8).each do |i|
    row = solution[i].compact
    return false if row.uniq.length != row.length
  end

  # No column can contain duplicates
  solution = solution.transpose
  (0..8).each do |i|
    col = solution[i].compact
    return false if col.uniq.length != col.length
  end

  # No sub-square of 9 can contain duplicates
  (0..8).step(3) do |i|
    (0..8).step(3) do |j|
      sub_solution = solution[i..i+2].map {|column| column[j..j+2]}.flatten.compact
      if sub_solution.uniq.length != sub_solution.length
        return false
      end
    end
  end

  return true
end

def possible_guesses(solution, row, col)
  guesses = (1..9).to_a
  guesses -= solution[row]
  guesses -= solution.transpose[col]
  return guesses
end

def sudoku_solver(solution)
  return nil unless is_valid?(solution) # Unsolvable with current numbers

  # Check for empty spaces
  nil_col = nil
  nil_row = nil
  (0..8).each do |i|
    nil_col = solution[i].find_index(nil)
    if nil_col
      nil_row = i
      break
    end
  end

  return solution unless nil_col # This is a valid and complete solution

  # Contains empty spaces
  guesses = possible_guesses(solution, nil_row, nil_col)
  guesses.each do |guess|
    new_solution = Marshal.load(Marshal.dump(solution)) # Deep copy
    new_solution[nil_row][nil_col] = guess
    result = sudoku_solver(new_solution)
    return result if result
  end

  return nil # None of the possible guesses worked
end

puts 'Solution:'
sudoku_solver(GRID).each { |row| puts row.to_s }
