#!/usr/bin/env ruby

require_relative 'day7'

circ = Circuit.new
circ.parse_instructions(
  "123 -> x
  456 -> y
  x AND y -> d
  x OR y -> e
  x LSHIFT 2 -> f
  y RSHIFT 2 -> g
  NOT x -> h
  NOT y -> i")
circ.print
