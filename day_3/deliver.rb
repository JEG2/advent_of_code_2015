#!/usr/bin/env ruby -w

require "set"

class Santa
  MOVES = {
    ">" => [ 1,  0],
    "v" => [ 0, -1],
    "<" => [-1,  0],
    "^" => [ 0,  1]
  }

  def initialize(path)
    @path       = path
    @deliveries = 1
    @location   = [0, 0]
    @seen       = [@location].to_set
  end

  attr_reader :path, :deliveries, :seen
  private     :path, :deliveries, :seen

  def count_deliveries
    make_moves
    deliveries
  end

  private

  def make_moves
    path.each_char do |direction|
      next unless MOVES.include?(direction)

      @location =
        @location.zip(MOVES.fetch(direction)).map { |axis| axis.inject(:+) }
      @deliveries += 1 if seen.add?(@location)
    end
  end
end

p Santa.new(ARGF.read).count_deliveries
