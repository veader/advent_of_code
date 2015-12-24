#!/usr/bin/env ruby

require_relative "day12"

[ ['[1,2,3]', 6],
  ['{"a":2,"b":4}', 6],
  ['[[[3]]]', 3],
  ['{"a":{"b":4},"c":-1}', 3],
  ['{"a":[-1,1]}', 0],
  ['[-1,{"a":1}]', 0],
  ['[]', 0],
  ['{}', 0],
].each do |test_data|
  ans = test_data.last
  pp str = test_data.first
  doc = AddDoc.new(str)
  sum = doc.hack_add
  raise "Sum should equal #{ans} for #{str} - got #{sum}" unless sum == ans
end
