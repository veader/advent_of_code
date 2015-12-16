#!/usr/bin/env ruby

def move_elevator(input)
  0 + input.count('(') - input.count(')')
end

if __FILE__ == $0
  input = ARGV[0].gsub(/[^()]/,'')
  floor = move_elevator(input)
  puts "Final floor: #{floor}"
end
