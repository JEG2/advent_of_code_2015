#!/usr/bin/env ruby -w

class Grid
  def initialize(initial)
    @lights = initial
    force_corners_on
  end

  attr_reader :lights
  private     :lights

  def step
    @lights =
      @lights.map.with_index { |row, y|
        row.map.with_index { |light, x|
          neighbors = count_neighbors(x, y)
          if light
            neighbors.between?(2, 3)
          else
            neighbors == 3
          end
        }
      }
    force_corners_on
  end

  def count_on
    lights.flatten.count(true)
  end

  def to_s
    lights.map { |row|
      row.map { |light| light ? "#" : "." }.join
    }.join("\n") + "\n"
  end

  private

  def max_x
    lights.first.size - 1
  end

  def max_y
    lights.size - 1
  end

  def count_neighbors(x, y)
    [ [-1, -1], [ 0, -1], [ 1, -1],
      [-1,  0],           [ 1,  0],
      [-1,  1], [ 0,  1], [ 1,  1] ].inject(0) { |sum, (x_offset, y_offset)|
      neighbor_x, neighbor_y = x + x_offset, y + y_offset

      if neighbor_x.between?(0, max_x) && neighbor_y.between?(0, max_y)
        sum + (lights[neighbor_y][neighbor_x] ? 1 : 0)
      else
        sum
      end
    }
  end

  def force_corners_on
    [ [0,     0], [max_x,     0],
      [0, max_y], [max_x, max_y] ].each do |x, y|
      lights[y][x] = true
    end
  end
end

grid = Grid.new(
  ARGF.map { |row| row.strip.split("").map { |light| light == "#" } }
)
100.times do
  grid.step
end
puts grid.count_on
