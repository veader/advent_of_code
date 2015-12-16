#!/usr/bin/env ruby

def parse_dimensions(input)
  input.split('x').map(&:to_i)
end

def area_of_side(length, width)
  length * width
end

def required_wrapping_paper(input)
  length, width, height = parse_dimensions(input)
  total_area = 0
  side1 = area_of_side(length, width)
  side2 = area_of_side(length, height)
  side3 = area_of_side(width, height)
  smallest_side = [side1, side2, side3].min
  (side1 * 2) + (side2 * 2) + (side3 * 2) + smallest_side
end

if __FILE__ == $0
  input = ARGV[0]
  total_paper = 0

  input.each_line do |line|
    paper_needed = required_wrapping_paper(line.strip)
    puts "Paper needed: #{paper_needed} square feet"
    total_paper += paper_needed
  end
  puts
  puts "Total paper needed: #{total_paper} square feet"
end
