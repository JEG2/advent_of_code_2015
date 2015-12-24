#!/usr/bin/env ruby -w

class Spell
  def initialize(name: , cost: , duration: nil, &action)
    @name = name
    @cost = cost
    @duration = duration
    @action = action
  end

  attr_reader :name, :cost
  attr_accessor :duration

  attr_reader :action
  private     :action

  def cast(wizard: , enemy: )
    wizard.mana -= cost
    if duration
      dup
    else
      do_effect(wizard: wizard, enemy: enemy)
      nil
    end
  end

  def do_effect(wizard: , enemy: )
    action[wizard, enemy]
  end
end

class Fighter
  def self.from_file(data)
    new(
      hp: data[/^Hit Points:\s*(\d+)/, 1].to_i,
      damage: data[/^Damage:\s*(\d+)/, 1].to_i
    )
  end

  def initialize(hp: , damage: 0, armor: 0, mana: 0)
    @hp = hp
    @damage = damage
    @armor = armor
    @mana = mana
  end

  attr_reader :damage
  attr_accessor :hp, :armor, :mana
end

class Fight
  SPELLS = [
    Spell.new(name: "Magic Missile", cost: 53) { |wizard, enemy|
      enemy.hp -= 4
    },
    Spell.new(name: "Drain", cost: 73) { |wizard, enemy|
      enemy.hp -= 2
      wizard.hp += 2
    },
    Spell.new(name: "Shield", cost: 113, duration: 6) { |wizard, enemy|
      wizard.armor = 7
    },
    Spell.new(name: "Poison", cost: 173, duration: 6) { |wizard, enemy|
      enemy.hp -= 3
    },
    Spell.new(name: "Recharge", cost: 229, duration: 5) { |wizard, enemy|
      wizard.mana += 101
    }
  ]

  def initialize(wizard: , enemy: )
    @wizard = wizard
    @enemy = enemy
    @effects = { }
    @spent = 0
  end

  def initialize_copy(other)
    @wizard = @wizard.dup
    @enemy = @enemy.dup
    @effects = Hash[@effects.map { |name, spell| [name, spell.dup] }]
  end

  attr_reader :wizard, :enemy, :spent

  attr_reader :effects
  private     :effects

  def legal_spells
    active_spells = effects.select { |_, spell| spell.duration > 1 }.map(&:first)
    SPELLS.select { |spell|
      spell.cost <= wizard.mana && !active_spells.include?(spell.name)
    }
  end

  def run_turn(spell)
    manage_effects
    return if winner
    run_wizard_turn(spell)
    return if winner
    manage_effects
    return if winner
    run_enemy_turn
  end

  def winner
    if wizard.hp <= 0
      enemy
    elsif enemy.hp <= 0
      wizard
    end
  end

  private

  def manage_effects
    shielded = effects.include?("Shield")
    effects.delete_if { |_, spell|
      spell.do_effect(wizard: wizard, enemy: enemy)
      spell.duration -= 1
      spell.duration.zero?
    }
    wizard.armor = 0 if shielded && !effects.include?("Shield")
  end

  def run_wizard_turn(spell)
    @spent += spell.cost
    if (effect = spell.cast(wizard: wizard, enemy: enemy))
      effects[spell.name] = effect
    end
  end

  def run_enemy_turn
    wizard.hp -= [1, enemy.damage - wizard.armor].max
  end
end

class Minimizer
  def initialize(fight)
    @q = [fight]
    @minimum = Float::INFINITY
  end

  attr_reader :q
  private     :q

  def minimum_spent
    while (fight = q.shift)
      spells = fight.legal_spells
      spells.each do |spell|
        new_fight = fight.dup
        new_fight.run_turn(spell)
        case new_fight.winner
        when new_fight.wizard
          @minimum = new_fight.spent if new_fight.spent < @minimum
        when nil
          q << new_fight unless new_fight.spent > @minimum
        end
      end
    end
    @minimum
  end
end

fight = Fight.new(
  wizard: Fighter.new(hp: 50, mana: 500),
  enemy: Fighter.from_file(ARGF.read)
)
p Minimizer.new(fight).minimum_spent
