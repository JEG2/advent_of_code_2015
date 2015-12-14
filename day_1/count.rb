#!/usr/bin/env ruby -w

input = ARGF.read
p input.count("(") - input.count(")")
