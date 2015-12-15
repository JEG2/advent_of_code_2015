#!/usr/bin/env ruby -w

class Counter
  def initialize
    @nice = 0
  end

  attr_reader :nice

  def check(string)
    @nice += 1 if nice?(string)
  end

  private

  def nice?(string)
    # string.count("aeiou") >= 3 &&
    #   string =~ /(.)\1/ &&
    #   %w[ab cd pq xy].none? { |s| string.include?(s) }
    string =~ /(..).*\1/ &&
      string  =~ /(.).\1/
  end
end

counter = Counter.new
ARGF.each do |string|
  counter.check(string)
end
p counter.nice
