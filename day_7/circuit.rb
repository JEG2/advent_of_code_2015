#!/usr/bin/env ruby -w

class Circuit
  MAX_SIGNAL = 65_535
  MAX_SIZE   = MAX_SIGNAL.to_s(2).size

  def initialize
    @wires = { }
  end

  attr_reader :wires
  private     :wires

  def connect(instruction)
    wire, value =
      case instruction
      when /\A(\w+) -> (\w+)\Z/
        [$2, -> { decode($1) }]
      when /\A(\w+) AND (\w+) -> (\w+)\Z/
        [$3, -> { decode($1) & decode($2) }]
      when /\A(\w+) OR (\w+) -> (\w+)\Z/
        [$3, -> { decode($1) | decode($2) }]
      when /\A(\w+) LSHIFT (\d+) -> (\w+)\Z/
        [$3, -> { [decode($1) << $2.to_i, MAX_SIGNAL].min }]
      when /\A(\w+) RSHIFT (\d+) -> (\w+)\Z/
        [$3, -> { decode($1) >> $2.to_i }]
      when /\ANOT (\w+) -> (\w+)\Z/
        [$2, -> { sprintf("%0#{MAX_SIZE}b", decode($1)).tr("01", "10").to_i(2) }]
      else
        fail "Unknown instruction:  #{instruction}"
      end
    wires[wire] = value
  end

  def decode(signal_or_wire)
    if signal_or_wire =~ /\A\d+\z/
      signal_or_wire.to_i
    else
      signal(signal_or_wire)
    end
  end

  def signal(wire)
    value = wires[wire]
    if value.is_a?(Proc)
      wires[wire] = value.call
    else
      value
    end
  end

  def to_s
    wires.keys.sort.map { |wire| "#{wire}: #{signal(wire)}" }.join("\n") + "\n"
  end
end

circuit = Circuit.new
ARGF.each do |instruction|
  circuit.connect(instruction)
end
# puts circuit
p circuit.signal("a")
