#!/usr/bin/env ruby

def move_elevator(input)
  # 0 + input.count('(') - input.count(')')
  floor = 0
  basement_position = nil
  input.chars.each_with_index do |char, idx|
    case char
    when "("
      floor += 1
    when ")"
      floor -= 1
      basement_position = idx + 1 if basement_position.nil? && floor < 0
    end
  end
  [floor, moved_to_basement_position]
end

if __FILE__ == $0
  input = ARGV[0].gsub(/[^()]/,'')
  floor, basement = move_elevator(input)
  puts "Final floor: #{floor}, moved to basement on #{basement}"
end
