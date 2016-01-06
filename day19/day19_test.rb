#!/usr/bin/env ruby

require "pp"
require_relative "day19"

# data = "H => HO
# H => OH
# O => HH
#
# HOH"
#
# med = Medicine.new(data)
# # med.print
# molecules = med.find_new_molecules
# pp molecules
# results = ["HOOH", "HOHO", "OHOH", "HOOH", "HHHH"]
# results.each do |r|
#   raise "#{r} should have been a result" unless molecules.include?(r)
# end

data= "e => H
e => O
H => HO
H => OH
O => HH

HOHOHO"

med = Medicine.new(data)
med.shortest_path_to_med("e")
