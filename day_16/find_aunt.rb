#!/usr/bin/env ruby -w

class Aunt
  FORMAT = /\ASue\s+(\d+):\s*(.+?)\s*\z/

  def self.parse(description)
    fail "Bad description:  #{description}" unless description =~ FORMAT

    number = $1.to_i
    properties = Hash[ $2.split(/, /).map { |compound|
      name, amount = compound.split(/:\s*/)
      [name, amount.to_i]
    } ]
    new(number, properties)
  end

  def initialize(number, details)
    @number = number
    @details = details
  end

  attr_reader :number

  attr_reader :details
  private     :details

  def match?(criteria)
    details.all? { |name, amount| criteria[name] == amount }
  end
end

GIFT_GIVER = {
  "children" => 3,
  "cats" => 7,
  "samoyeds" => 2,
  "pomeranians" => 3,
  "akitas" => 0,
  "vizslas" => 0,
  "goldfish" => 5,
  "trees" => 3,
  "cars" => 2,
  "perfumes" => 1
}

aunts = ARGF.map { |description| Aunt.parse(description) }
p aunts.find { |aunt| aunt.match?(GIFT_GIVER) }.number
