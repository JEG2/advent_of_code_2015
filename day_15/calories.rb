#!/usr/bin/env ruby -w

class Ingredient
  FORMAT = /\A(\w+):\s+(.+?)\s*\z/

  def self.parse(ingredient)
    fail "Bad ingredient:  #{ingredient}" unless ingredient =~ FORMAT

    properties = {name: $1}
    $2.split(/,\s+/).each do |name_and_value|
      name, value = name_and_value.split
      properties[name.to_sym] = value.to_i
    end
    new(**properties)
  end

  def initialize(
    name: ,
    capacity: ,
    durability: ,
    flavor: ,
    texture: ,
    calories:
  )
    @name = name
    @capacity = capacity
    @durability = durability
    @flavor = flavor
    @texture = texture
    @calories = calories
  end

  attr_reader :name, :capacity, :durability, :flavor, :texture, :calories
end

class Cookie
  include Comparable

  def initialize
    @capacity = 0
    @durability = 0
    @flavor = 0
    @texture = 0
    @calories = 0
  end

  attr_reader :calories

  attr_reader :capacity, :durability, :flavor, :texture
  private     :capacity, :durability, :flavor, :texture

  def add(ingredient, amount)
    @capacity += ingredient.capacity * amount
    @durability += ingredient.durability * amount
    @flavor += ingredient.flavor * amount
    @texture += ingredient.texture * amount
    @calories += ingredient.calories * amount
  end

  def score
    [capacity, durability, flavor, texture]
      .map { |property| [0, property].max }
      .inject(:*)
  end

  def <=>(other)
    score <=> other.score
  end
end

class Baker
  def initialize(ingredients)
    @ingredients = ingredients
  end

  attr_reader :ingredients
  private     :ingredients

  def perfect(limit, remaining = ingredients, cookie = Cookie.new)
    (1..(limit - remaining.size + 1)).map { |amount|
      new_cookie = cookie.dup
      new_cookie.add(remaining.first, amount)
      if remaining.size == 1
        new_cookie
      else
        perfect(limit - amount, remaining.drop(1), new_cookie)
      end
    }.compact.select { |c| c.calories == 500 }.max
  end
end

# lines = <<END_LINES
# Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
# END_LINES
# ingredients = lines.lines.map { |ingredient| Ingredient.parse(ingredient) }
ingredients = ARGF.map { |ingredient| Ingredient.parse(ingredient) }
p Baker.new(ingredients).perfect(100).score
