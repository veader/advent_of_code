#!/usr/bin/env ruby

require 'ostruct'

GRID_SIZE=1000

class Decorations
  attr_accessor :grid

  ON=true
  OFF=false

  def initialize(size=GRID_SIZE)
    setup_grid(size)
  end

  def parse_instructions(instructions)
    instructions.each_line do |line|
      pieces = line.strip.downcase.split(' ')
      case pieces.first
      when 'toggle'
        toggle_lights(parse_coord(pieces[1]), parse_coord(pieces[3]))
      when 'turn'
        if pieces[1] == 'on'
          turn_on_lights(parse_coord(pieces[2]), parse_coord(pieces[4]))
        else
          turn_off_lights(parse_coord(pieces[2]), parse_coord(pieces[4]))
        end
      else
        p "Unknown instruction: '#{line}'"
        next
      end
    end
  end

  def parse_coord(coord)
    pieces = coord.split(',')
    OpenStruct.new(x: pieces[0].to_i, y: pieces[1].to_i)
  end

  def set_light_state(starting_coord, ending_coord, state)
    (starting_coord.x).upto(ending_coord.x) do |x|
      (starting_coord.y).upto(ending_coord.y) do |y|
        if state == ON
          @grid[x][y] += 1
        else # OFF
          @grid[x][y] -= 1
          @grid[x][y] = 0 if @grid[x][y] < 0
        end
      end
    end
  end

  def turn_on_lights(starting_coord, ending_coord)
    set_light_state(starting_coord, ending_coord, ON)
  end

  def turn_off_lights(starting_coord, ending_coord)
    set_light_state(starting_coord, ending_coord, OFF)
  end

  def toggle_lights(starting_coord, ending_coord)
    (starting_coord.x).upto(ending_coord.x) do |x|
      (starting_coord.y).upto(ending_coord.y) do |y|
        @grid[x][y] += 2
      end
    end
  end

  def setup_grid(size)
    @grid = Array.new(size, 0)
    size.times { |i| @grid[i] = Array.new(size, 0) }
  end

  # def count_lights_on
  #   count = 0
  #   grid.each { |row| row.each { |cell| count += 1 if cell } }
  #   count
  # end
  def overall_brightness
    brightness = 0
    grid.each { |row| row.each { |cell| brightness += cell } }
    brightness
  end

  def print_grid
    grid.each do |row|
      # p row.map { |cell| cell ? '*' : '.' }.join(' ')
      p row.join(' ')
    end
  end
end

if __FILE__ == $0
  input = ARGV[0]
  deco = Decorations.new
  deco.parse_instructions(input)
  # p "There are now #{deco.count_lights_on} lights ON."
  p "The overall brightness is now #{deco.overall_brightness}"
end
