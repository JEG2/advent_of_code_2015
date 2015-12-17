#!/usr/bin/env ruby -w

containers = ARGF.read.scan(/\d+/).map(&:to_i)
count = 0
(1..containers.size).each do |size|
  containers.combination(size).each do |combo|
    count += 1 if combo.inject(:+) == 150
  end
end
p count
