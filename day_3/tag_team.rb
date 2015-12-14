#!/usr/bin/env ruby -w

require "set"

class Santa
  MOVES = {
    ">" => [ 1,  0],
    "v" => [ 0, -1],
    "<" => [-1,  0],
    "^" => [ 0,  1]
  }

  def self.seen
    @seen ||= Set.new
  end

  def initialize
    @deliveries = 0
    @location   = [0, -1]

    move("^")
  end

  attr_reader :deliveries

  attr_reader :path
  private     :path

  def move(direction)
    @location =
      @location.zip(MOVES.fetch(direction)).map { |axis| axis.inject(:+) }
    @deliveries += 1 if self.class.seen.add?(@location)
  end
end

santas = [Santa.new, Santa.new]
turn   = santas.cycle
ARGF.read.each_char do |direction|
  next unless Santa::MOVES.include?(direction)

  turn.next.move(direction)
end
p santas.inject(0) { |sum, santa| sum + santa.deliveries }
