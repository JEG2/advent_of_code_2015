#!/usr/bin/env ruby -w

class Machine
  def initialize
    @replacements = { }
    @target = nil
  end

  attr_reader :replacements, :target
  private     :replacements, :target

  def add_replacement(replacement)
    fail "Bad replacement:  #{replacement}" \
      unless replacement =~ /\A(\w+)\s*=>\s*(\w+)\Z/
    replacements[$2] = $1
  end

  def add_target(target)
    @target = target.strip
  end

  def shrink
    steps = 0
    loop do
      start = steps
      replacements.each do |large, small|
        steps += 1 if target.sub!(large, small)
      end
      break if start == steps
    end
    steps
  end
end

machine = Machine.new
ARGF.each do |line|
  if line.include?("=>")
    machine.add_replacement(line)
  elsif line =~ /\S/
    machine.add_target(line)
  end
end
# machine.add_replacement("e => H")
# machine.add_replacement("e => O")
# machine.add_replacement("H => HO")
# machine.add_replacement("H => OH")
# machine.add_replacement("O => HH")
# machine.add_target("HOHOHO")
p machine.shrink
