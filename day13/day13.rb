#!/usr/bin/env ruby

require "pp"

class SeatingChart
  attr_accessor :happiness_map, :arrangements, :happiness_deltas

  def initialize(happiness_data)
    self.happiness_map = {}
    self.arrangements = []
    self.happiness_deltas = {}

    parse(happiness_data)
    find_arrangements
    calculate_happiness
  end

  def parse(happiness_data)
    # http://rubular.com/r/r1EtGh8JVM
    regex = /^(\S+) would (lose|gain) (\d+) happiness .*? next to (\S+)\./
    happiness_data.each_line do |line|
      next unless match = line.match(regex)
      self.happiness_map[match.captures[0]] ||= {}
      change = match.captures[2].to_i
      change *= -1 if match.captures[1] == "lose"
      self.happiness_map[match.captures[0]][match.captures[3]] = change
    end
  end

  def possible_people
    self.happiness_map.keys.sort
  end

  def find_arrangements
    seating_arrangements([possible_people.first])
  end

  def seating_arrangements(arrangement)
    if arrangement.count == possible_people.count
      p "Full arrangement: #{arrangement}"
      self.arrangements << arrangement
      return
    end

    self.happiness_map[arrangement.last].keys.each do |person|
      next if arrangement.include?(person)
      seating_arrangements(arrangement+[person])
    end
  end

  def calculate_happiness
    self.arrangements.each do |arr|
      delta = []
      arr.each_cons(2) do |p1, p2|
        delta << self.happiness_map[p1][p2]
        delta << self.happiness_map[p2][p1]
      end
      # complete the loop
      p1 = arr.first
      p2 = arr.last
      delta << self.happiness_map[p1][p2]
      delta << self.happiness_map[p2][p1]

      pp arr
      pp "#{delta} => #{delta.reduce(:+)}"

      self.happiness_deltas[arr.join(',')] = delta.reduce(:+)
    end
  end

  def max_happiness
    happiness = 0
    arrangement = nil
    self.happiness_deltas.each do |arr, delta|
      if delta > happiness
        happiness = delta
        arrangement = arr
      end
    end

    p "MAX: #{arrangement} => #{happiness}"
  end
end

if __FILE__ == $0
  input = ARGV[0]
  seating = SeatingChart.new(input)
  pp seating.happiness_map
  p "="*80
  pp seating.happiness_deltas
  p "="*80
  seating.max_happiness
end
