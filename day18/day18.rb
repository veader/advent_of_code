#!/usr/bin/env ruby

require "pp"
# require "ostruct"

GRID_SIZE=100

class LightDisplay
  attr_accessor :grid, :size

  ON="#"
  OFF="."

  def initialize(initial_state="", size=GRID_SIZE)
    self.size = size
    self.grid = new_grid
    parse(initial_state)
  end

  def parse(state="")
    state.split("\n").each_with_index do |line, x|
      line = line.chomp.strip
      line.chars.each_with_index { |c, y| self.grid[x][y] = c }
    end
  end

  def lights_on
    count = 0
    0.upto(self.size - 1).each do |x|
      0.upto(self.size - 1).each do |y|
        count += 1 if self.grid[x][y] == ON
      end
    end
    count
  end

  def animate(cycle_count)
    cycle_count.times { |i| animate_grid }
  end

  def animate_grid
    after_grid = new_grid
    0.upto(self.size - 1).each do |x|
      0.upto(self.size - 1).each do |y|
        after_grid[x][y] = lights_new_state(x,y)
      end
    end
    self.grid = force_corners_on(after_grid)
  end

  def lights_new_state(x,y)
    current_state = self.grid[x][y]
    light_neighbors =
    on_count = 0
    neighbor_lights = neighbors(x,y)
    neighbor_lights.each do |coord|
      on_count += 1 if self.grid[coord.first][coord.last] == ON
    end

    case current_state
    when ON
      # A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
      (2..3).include?(on_count) ? ON : OFF
    when OFF
      # A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
      on_count == 3 ? ON : OFF
    else
      raise "WHAT?!?"
    end
  end

  def neighbors(x,y)
    neighbor_coords = []
    (x-1..x+1).each do |neighborX|
      next if neighborX < 0 || neighborX >= self.size
      (y-1..y+1).each do |neighborY|
        next if neighborY < 0 || neighborY >= self.size
        next if neighborY == y && neighborX == x
        neighbor_coords << [neighborX, neighborY]
      end
    end
    neighbor_coords
  end

  def new_grid
    grid = Array.new(self.size, OFF)
    size.times { |i| grid[i] = Array.new(self.size, OFF) }
    force_corners_on(grid)
  end

  def force_corners_on(grid)
    grid[0][0] = ON
    grid[0][self.size-1] = ON
    grid[self.size-1][0] = ON
    grid[self.size-1][self.size-1] = ON
    grid
  end

  def print
    @grid.each { |row| p row.join("") }
  end
end

if __FILE__ == $0
  input = ARGV[0]
  animate_count = (ARGV[1] || 100).to_i
  lights = LightDisplay.new(input, 100)
  lights.animate(animate_count)
  p "After #{animate_count} steps: #{lights.lights_on} lights are ON"
end
