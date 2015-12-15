#!/usr/bin/env ruby -w

require "digest"

secret_key = ARGV.shift or abort "USAGE:  #{$PROGRAM_NAME} SECRET_KEY"

1.upto(Float::INFINITY) do |i|
  hash = Digest::MD5.hexdigest("#{secret_key}#{i}")
  # if hash.start_with?("00000")
  if hash.start_with?("000000")
    puts i
    exit
  end
end
