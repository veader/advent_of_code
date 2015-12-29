#!/usr/bin/env ruby

require "pp"
require_relative "day16"

data = "Sue 483: goldfish: 0, cars: 3, perfumes: 10
Sue 484: pomeranians: 1, samoyeds: 1, perfumes: 3
Sue 485: trees: 0, akitas: 2, vizslas: 4
Sue 486: cars: 3, vizslas: 8, goldfish: 1
Sue 487: pomeranians: 9, vizslas: 2, children: 10
Sue 488: akitas: 6, vizslas: 10, perfumes: 9"

data_attribs = "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"

list = SueList.new(data)
pp list
p "="*80

attribs = parse_attributes(data_attribs)
pp attribs
p "="*80

list.find_sue_matching(attribs)
