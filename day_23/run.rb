#!/usr/bin/env ruby -w

# a, b = 0, 0
a, b = 1, 0
instructions = ARGF.readlines

i = 0
while i < instructions.size
  case instructions[i]
  when /\Ahlf ([ab])/
    if $1 == "a"
      a /= 2
    else
      b /= 2
    end
    i += 1
  when /\Atpl ([ab])/
    if $1 == "a"
      a *= 3
    else
      b *= 3
    end
    i += 1
  when /\Ainc ([ab])/
    if $1 == "a"
      a += 1
    else
      b += 1
    end
    i += 1
  when /\Ajmp ([-+]\d+)/
    i += $1.to_i
  when /\Ajie ([ab]), ([-+]\d+)/
    if ($1 == "a" ? a : b).even?
      i += $2.to_i
    else
      i += 1
    end
  when /\Ajio ([ab]), ([-+]\d+)/
    if ($1 == "a" ? a : b) == 1
      i += $2.to_i
    else
      i += 1
    end
  else
    fail "Bad instruction:  #{instructions[i]}"
  end
end
p a: a, b: b
