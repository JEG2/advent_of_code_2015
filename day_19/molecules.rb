#!/usr/bin/env ruby -w

require "set"

class Machine
  def initialize
    @replacements = Hash.new { |all, name| all[name] = [ ] }
    @start = nil
  end

  attr_reader :replacements, :start
  private     :replacements, :start

  def add_replacement(replacement)
    fail "Bad replacement:  #{replacement}" \
      unless replacement =~ /\A(\w+)\s*=>\s*(\w+)\Z/
    replacements[$1] << $2
  end

  def add_start(start)
    @start = start.strip
  end

  def count_distinct_replacements
    distinct = Set.new
    start.scan(/\G(.*?)(#{replacements.keys.uniq.join("|")})/o) do
      replacements[$2].each do |replacement|
        distinct << $~.pre_match + $1 + replacement + $~.post_match
      end
    end
    distinct.size
  end
end

machine = Machine.new
ARGF.each do |line|
  if line.include?("=>")
    machine.add_replacement(line)
  elsif line =~ /\S/
    machine.add_start(line)
  end
end
p machine.count_distinct_replacements
