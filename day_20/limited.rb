#!/usr/bin/env ruby -w

# modified from:  https://www.reddit.com/r/adventofcode/comments/3xjpp2/day_20_solutions/cy5abc3

target = 34_000_000
size = target / 10
counts = Array.new(size, 0)
1.upto(size) do |n|
  counter = 0
  n.step(by: n, to: size - 1) do |i|
    counts[i] += 11 * n
    counter += 1
    break if counter == 50
  end
end
p counts.index { |c| c >= target }
