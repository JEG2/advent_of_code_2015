#!/usr/bin/env ruby -w

require "set"

class Circle
  RULE_FORMAT = /\A(\w+)\b.+\b(gain|lose)\s(\d+)\b.+\b(\w+)\.\Z/

  def initialize
    # @people = Set.new
    @people = ["me"].to_set
    @rules  = Hash.new { |all, name| all[name] = Hash.new(0) }
  end

  attr_reader :people, :rules
  private     :people, :rules

  def add(rule)
    fail "Bad rule:  #{rule}" unless rule =~ RULE_FORMAT

    person = $1
    adjacent = $4
    points = $2 == "gain" ? $3.to_i : -$3.to_i
    people << person << adjacent
    rules[person][adjacent] = points
  end

  def optimal
    people.to_a.permutation.map { |seating| score(seating) }.max
  end

  private

  def score(seating)
    circle = [seating.last] + seating + [seating.first]
    total = 0
    circle.each_cons(3) do |left, middle, right|
      total += rules[middle][left]
      total += rules[middle][right]
    end
    total
  end
end

circle = Circle.new
ARGF.each do |rule|
  circle.add(rule)
end
p circle.optimal
