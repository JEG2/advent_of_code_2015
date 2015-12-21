#!/usr/bin/env ruby -w

class Item
  def initialize(cost: , damage: , armor: )
    @cost = cost
    @damage = damage
    @armor = armor
  end

  attr_reader :cost, :damage, :armor
end

class Fighter
  def self.from_file(data)
    new(
      hp: data[/^Hit Points:\s*(\d+)/, 1].to_i,
      damage: data[/^Damage:\s*(\d+)/, 1].to_i,
      armor: data[/^Armor:\s*(\d+)/, 1].to_i
    )
  end

  def self.from_items(items)
    new(
      hp: 100,
      damage: items.inject(0) { |sum, i| sum + i.damage },
      armor: items.inject(0) { |sum, i| sum + i.armor }
    )
  end

  def initialize(hp: , damage: , armor: )
    @hp = hp
    @damage = damage
    @armor = armor
  end

  attr_reader :hp, :damage, :armor
end

class Fight
  def initialize(enemy)
    @enemy = enemy
  end

  attr_reader :enemy
  private     :enemy

  def wins?(player)
    [
      {hp: enemy.hp, attacker: player, defender: enemy},
      {hp: player.hp, attacker: enemy, defender: player}
    ].cycle do |turn|
      turn[:hp] -= [1, turn[:attacker].damage - turn[:defender].armor].max
      return turn[:attacker] == player if turn[:hp] <= 0
    end
  end
end

shop_weapons = [
  Item.new(cost:  8, damage: 4, armor: 0),
  Item.new(cost: 10, damage: 5, armor: 0),
  Item.new(cost: 25, damage: 6, armor: 0),
  Item.new(cost: 40, damage: 7, armor: 0),
  Item.new(cost: 74, damage: 8, armor: 0)
]
shop_armor = [
  Item.new(cost:   0, damage: 0, armor: 0),
  Item.new(cost:  13, damage: 0, armor: 1),
  Item.new(cost:  31, damage: 0, armor: 2),
  Item.new(cost:  53, damage: 0, armor: 3),
  Item.new(cost:  75, damage: 0, armor: 4),
  Item.new(cost: 102, damage: 0, armor: 5)
]
shop_rings = [
  Item.new(cost:   0, damage: 0, armor: 0),
  Item.new(cost:   0, damage: 0, armor: 0),
  Item.new(cost:  25, damage: 1, armor: 0),
  Item.new(cost:  50, damage: 2, armor: 0),
  Item.new(cost: 100, damage: 3, armor: 0),
  Item.new(cost:  20, damage: 0, armor: 1),
  Item.new(cost:  40, damage: 0, armor: 2),
  Item.new(cost:  80, damage: 0, armor: 3)
]

fight = Fight.new(Fighter.from_file(ARGF.read))
cheapest = Float::INFINITY
shop_weapons.each do |weapon|
  shop_armor.each do |armor|
    shop_rings.permutation(2).each do |rings|
      items = [weapon, armor] + rings
      cost = items.inject(0) { |sum, i| sum + i.cost }
      if cost < cheapest && fight.wins?(Fighter.from_items(items))
        cheapest = cost
      end
    end
  end
end
p cheapest
