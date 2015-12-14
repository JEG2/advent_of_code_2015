#!/usr/bin/env ruby -w

require "strscan"

class Interpreter
  def initialize(instructions)
    @instructions = StringScanner.new(instructions)
    @floor        = 0
  end

  attr_reader :instructions, :floor
  private     :instructions, :floor

  def find_move_to_basement
    while instructions?
      read_instruction
      return position if in_basement?
    end
    nil
  end

  private

  def instructions?
    !instructions.eos?
  end

  def read_instruction
    move(/\(/, 1) || move(/\)/, -1)
  end

  def move(instruction, floors)
    if instructions.scan(instruction)
      @floor += floors
      true
    else
      false
    end
  end

  def in_basement?
    floor < 0
  end

  def position
    instructions.pos
  end
end

p Interpreter.new(ARGF.read).find_move_to_basement
