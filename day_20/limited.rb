#!/usr/bin/env ruby -w

GOAL = 34_000_000

houses = Array.new(GOAL + 1, 0)
1.upto(GOAL) do |elf|
  presents = elf * 11
  1.upto(50) do |offset|
    house = elf * offset
    break if house > GOAL
    houses[house] += presents
  end
end

p houses.index { |house| house >= GOAL }
