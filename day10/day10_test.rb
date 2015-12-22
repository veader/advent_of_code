#!/usr/bin/env ruby

require_relative "day10"

# [ ["1", "11"],
#   ["11", "21"],
#   ["21", "1211"],
#   ["1211", "111221"],
#   ["111221", "312211"],
# ].each do |test_data|
#   lns = LookAndSay.new(test_data[0])
#   lns.parse!
#   raise "#{lns.sequence} does not equal #{test_data[1]}" unless lns.sequence == test_data[1]
#   p "="*80
# end

REPEAT = 3
p input = "111221"

lns = LookAndSay.new(input)
pp chunks = lns.split

REPEAT.times { |i| lns.parse!; p lns.sequence }
p "After 3: #{lns.sequence}"

chunks.each_with_index do |chunk, idx|
  tmpLns = LookAndSay.new(chunk)
  REPEAT.times { |i| tmpLns.parse!; p tmpLns.sequence }
  p "After 3 [#{idx}]: #{tmpLns.sequence}"
end
