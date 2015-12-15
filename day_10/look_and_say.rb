#!/usr/bin/env ruby -w

unless ARGV.size == 2 && ARGV.all? { |a| a =~ /\A\d+\z/ }
  abort "USAGE:  #{$PROGRAM_NAME} NUM ITERATIONS"
end
num, iterations = ARGV.map(&:dup)

def look_and_say(digits)
  new_digits = ""
  while digits.sub!(/\A((.)\2*)/, "")
    new_digits << "#{$1.size}#{$2}"
  end
  new_digits
end

iterations.to_i.times do
  num = look_and_say(num)
end
p num.size
