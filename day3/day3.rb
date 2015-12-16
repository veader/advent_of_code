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

def number_of_houses_visited(navigation_instructions)
  house_map = santa_tracker(navigation_instructions)
  house_map.keys.count
end

if __FILE__ == $0
  input = ARGV[0]
  houses = number_of_houses_visited(input)
  puts "Santa visited #{houses} houses"
end
