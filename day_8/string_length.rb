#!/usr/bin/env ruby -w

total = 0
ARGF.each do |code|
  code.strip!
  memory = eval(code)
  total += code.size - memory.size
end
p total
