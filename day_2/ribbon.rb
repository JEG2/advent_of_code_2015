#!/usr/bin/env ruby -w

class Order
  def initialize
    @total = 0
  end

  attr_reader :total

  def add(dimensions)
    fail "Bad input" unless dimensions =~ /\A\d+x\d+x\d+\Z/

    lwh      = dimensions.split("x").map(&:to_i)
    shortest = lwh.sort.first(2)
    @total  += shortest.inject(0) { |sum, side| sum + 2 * side } + lwh.inject(:*)
  end
end

order = Order.new
ARGF.each do |box|
  order.add(box)
end
p order.total
