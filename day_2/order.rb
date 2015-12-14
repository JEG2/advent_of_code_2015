#!/usr/bin/env ruby -w

class Order
  def initialize
    @total = 0
  end

  attr_reader :total

  def add(dimensions)
    fail "Bad input" unless dimensions =~ /\A\d+x\d+x\d+\Z/

    l, w, h  = dimensions.split("x").map(&:to_i)
    sides    = [l * w, w * h, h * l]
    @total  += sides.inject(0) { |sum, side| sum + 2 * side } + sides.min
  end
end

order = Order.new
ARGF.each do |box|
  order.add(box)
end
p order.total
