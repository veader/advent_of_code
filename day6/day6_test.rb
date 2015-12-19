#!/usr/bin/env ruby

require_relative 'day6'

deco = Decorations.new(20)
deco.parse_instructions("turn on 1,1 through 4,4\ntoggle 2,4 through 5,5\n")
deco.print_grid
p deco.count_lights_on
