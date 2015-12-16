#!/usr/bin/env ruby -w

require "json"

def find_and_add_nums(data)
  total = 0
  case data
  when Array
    data.each do |member|
      total += find_and_add_nums(member)
    end
  when Hash
    unless data.values.include?("red")
      data.each_value do |value|
        total += find_and_add_nums(value)
      end
    end
  when Numeric
    total += data
  end
  total
end

data = JSON.parse(ARGF.read)
p find_and_add_nums(data)
