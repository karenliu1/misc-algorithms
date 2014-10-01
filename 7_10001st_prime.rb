# Sieve of Eratosthenes
def primes_up_to_n(n)
  primes = (2..n).to_a

  for i in 0..primes.length-1
    next if primes[i].nil? # Skip marked non-primes

    for factor in 2..n/primes[i]
      # Mark all multiples of primes[i] in the list by setting to nil
      # Index at -2 because we start `primes` at 2, not 0
      primes[factor * primes[i] - 2] = nil
    end
  end

  return primes.compact
end

primes = primes_up_to_n(200000)
puts '10,001st Prime:', primes[10000]
