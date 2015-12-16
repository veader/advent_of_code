#!/usr/bin/env ruby

def parse_dimensions(input)
  input.split('x').map(&:to_i)
end

def area_of_side(length, width)
  length * width
end

def perimiter_of_side(length, width)
  (2 * length) + (2 * width)
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

def required_ribbon(input)
  length, width, height = parse_dimensions(input)
  sides = []
  sides << perimiter_of_side(length, width)
  sides << perimiter_of_side(length, height)
  sides << perimiter_of_side(width, height)
  smallest_side = sides.min

  volume = length * width * height
  smallest_side + volume # total ribbon
end

if __FILE__ == $0
  input = ARGV[0]
  total_paper = 0
  total_ribbon = 0

  input.each_line do |line|
    paper_needed = required_wrapping_paper(line.strip)
    puts "Paper: #{paper_needed} square feet"
    ribbon_needed = required_ribbon(line.strip)
    puts "Ribbon: #{ribbon_needed} feet"

    total_paper += paper_needed
    total_ribbon += ribbon_needed
  end
  puts
  puts "Total Paper needed: #{total_paper} square feet"
  puts "Total Ribbon needed: #{total_ribbon} feet"
end
