#!/usr/bin/env ruby -w

require "set"

class Trip
  def initialize
    @cities = Set.new
    @distances = { }
  end

  attr_reader :cities, :distances
  private     :cities, :distances

  def add_distance(leg)
    fail "Bad leg: #{leg}" unless leg =~ /\A(\w+) to (\w+) = (\d+)\Z/

    from, to, distance = $1, $2, $3.to_i
    cities << from << to
    distances[[from, to]] = distance
    distances[[to, from]] = distance
  end

  def shortest
    paths.min
  end

  def longest
    paths.max
  end

  private

  def paths
    @paths ||= cities.to_a.permutation.to_a.map { |trip|
      trip
        .each_cons(2)
        .map { |from_and_to| distances.fetch(from_and_to) }
        .inject(:+)
    }
  end
end

trip = Trip.new
# trip.add_distance("London to Dublin = 464")
# trip.add_distance("London to Belfast = 518")
# trip.add_distance("Dublin to Belfast = 141")
ARGF.each do |leg|
  trip.add_distance(leg)
end
p trip.shortest
p trip.longest
