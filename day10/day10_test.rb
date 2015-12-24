#!/usr/bin/env ruby

require_relative "day10"

[ ["1", "11"],
  ["11", "21"],
  ["21", "1211"],
  ["1211", "111221"],
  ["111221", "312211"],
].each do |test_data|
  lns = LookAndSay.new(test_data[0])
  lns.parse!
  raise "#{lns.sequence} does not equal #{test_data[1]}" unless lns.sequence == test_data[1]
  p "="*80
end
