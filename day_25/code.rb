#!/usr/bin/env ruby -w

fail "Bad coordinates" unless ARGF.read =~ /row (\d+), column (\d+)/
goal_y, goal_x = $1.to_i, $2.to_i

code = 20151125
y, x = 1, 1
loop do
  puts "#{x}, #{y}: #{code}" if y % 100 == 0 && x == 1
  break if goal_y == y && goal_x == x
  if y == 1
    y, x = x + 1, 1
  else
    y, x = y - 1, x + 1
  end
  code = code * 252533 % 33554393
end

p code
