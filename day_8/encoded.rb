#!/usr/bin/env ruby -w

total = 0
ARGF.each do |code|
  code.strip!
  encoded = code.inspect
  total += encoded.size - code.size
end
p total
