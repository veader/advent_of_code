#!/usr/bin/env ruby

require "pp"
require_relative "day18"

# data = \
# "....#..#..
# ..........
# ..#..#....
# ....#.....
# ..........
# ..........
# ..........
# ..#..#....
# ....#.....
# ....#....."
#
# lights = LightDisplay.new(data, 10)
# lights.print
#
# (0..9).each do |i|
#   pp
#   p "Neighbor Coords for #{i}x#{i}"
#   pp lights.neighbors(i,i)
# end

# ---------------------------------------------------------------
# # FIRST STAR
# data = \
# ".#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####.."
#
# lights = LightDisplay.new(data, 6)
# lights.print
# p "--------"
# lights.animate(4)
# lights.print

# ---------------------------------------------------------------
# # SECOND STAR
data = \
"##.#.#
...##.
#....#
..#...
#.#..#
####.#"

lights = LightDisplay.new(data, 6)
lights.print
p "--------"
lights.animate(5)
lights.print
