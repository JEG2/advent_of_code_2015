#!/usr/bin/env ruby -w

def factor(n)
  1
    .upto(Math.sqrt(n))
    .select { |i| (n % i).zero? }
    .each_with_object([ ]) do |i, factors|
      factors << i
      factors << n / i unless i == n / i
    end
    .sort
end

def presents(n)
  factor(n).inject(0) { |sum, i| sum + i * 10 }
end

1.upto(Float::INFINITY) do |i|
  if presents(i) >= 34_000_000
    p i
    exit
  end
end
