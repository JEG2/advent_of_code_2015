#!/usr/bin/env ruby -w

class Grid
  INSTRUCTION_FORMAT = /\A(toggle|turn (?:on|off)) (\d+,\d+) through (\d+,\d+)\Z/

  def initialize
    @lights = Hash.new(0)
  end

  attr_reader :lights
  private     :lights

  def modify(instruction)
    from, to, action = parse(instruction)
    walk(from, to) do |xy, on_off|
      lights[xy] = action[lights[xy]]
    end
  end

  def add_brightness
    total = 0
    walk([0, 0], [999, 999]) do |_, brightness|
      total += brightness
    end
    total
  end

  private

  def parse(instruction)
    fail "Bad instruction" unless instruction =~ INSTRUCTION_FORMAT

    from   = $2.split(",").map(&:to_i)
    to     = $3.split(",").map(&:to_i)
    action =
      case $1
      when "toggle"   then ->(brightness) { brightness + 2 }
      when "turn on"  then ->(brightness) { brightness + 1 }
      when "turn off" then ->(brightness) { [0, brightness - 1].max }
      else                 fail "Unknown action"
      end
    [from, to, action]
  end

  def walk(from, to)
    from.first.upto(to.first) do |x|
      from.last.upto(to.last) do |y|
        yield [x, y], lights[[x, y]]
      end
    end
  end
end

grid = Grid.new
ARGF.each do |instruction|
  puts "Processing #{instruction.strip}..."
  grid.modify(instruction)
end
p grid.add_brightness
