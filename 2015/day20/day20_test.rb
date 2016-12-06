#!/usr/bin/env ruby

require "pp"
require_relative "day20"

# { 1 => 10,
#   2 => 30,
#   3 => 40,
#   4 => 70,
#   5 => 60,
#   6 => 120,
#   7 => 80,
#   8 => 150,
#   9 => 130
# }.each do |num, presents|
#   house = House.new(num)
#   result = house.determine_present_count
#   raise "House (#{num}) should have gotten #{presents} presents, got #{result}." unless result == presents
# end
#
# p "All tests PASS!"

house = House.new(110)
# Star 1 = 2160
p house.determine_present_count
