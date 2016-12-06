#!/usr/bin/env ruby

class Coordinate
  attr_accessor :x, :y

  def initialize(x, y)
    self.x = x
    self.y = y
  end

  def move(direction)
    case direction
    when "^"
      self.y += 1
    when "v"
      self.y -= 1
    when "<"
      self.x -= 1
    when ">"
      self.x += 1
    end
  end

  def location
    "#{x},#{y}"
  end
end

def santa_tracker(navigation_instructions)
  current_coord = Coordinate.new(0, 0)
  house_map = {}

  house_map[current_coord.location] = 1 # start on first house

  navigation_instructions.chars.each_with_index do |dir, idx|
    current_coord.move(dir)
    house_map[current_coord.location] ||= 0
    house_map[current_coord.location] += 1
  end

  house_map
end

def split_navigation_instructions(navigation_instructions)
  santa_instructions = []
  robo_instructions  = []
  navigation_instructions.chars.each_with_index do |char, idx|
    if idx % 2 == 0
      santa_instructions << char
    else
      robo_instructions << char
    end
  end
  [santa_instructions.join(''), robo_instructions.join('')]
end

def number_of_houses_visited(navigation_instructions, use_robo_santa=false)
  if use_robo_santa
    santa_instructions, robo_instructions = split_navigation_instructions(navigation_instructions)
    santa_house_map = santa_tracker(santa_instructions)
    robo_house_map = santa_tracker(robo_instructions)

    (santa_house_map.keys + robo_house_map.keys).uniq.count
  else
    house_map = santa_tracker(navigation_instructions)
    house_map.keys.count
  end
end

if __FILE__ == $0
  input = ARGV[0]
  use_robo = (ARGV[1] || "").downcase == "robo"
  houses = number_of_houses_visited(input, use_robo)
  puts "Santa visited #{houses} houses"
end
