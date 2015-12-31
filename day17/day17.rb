#!/usr/bin/env ruby

require "pp"

class Eggnog
  attr_accessor :container_sizes, :volume

  def initialize(containers, volume)
    self.volume = volume
    self.container_sizes = containers
  end

  def find_container_combinations(used_volume = 0, used_sizes=[], unused_sizes=self.container_sizes)
    return [used_sizes] if used_volume == self.volume # full, success
    return nil if unused_sizes.empty? # we have no more containers, so this branch fails

    container_mixes = []
    remaining_sizes = unused_sizes.dup
    next_size = remaining_sizes.shift

    max = can_use_container?(used_volume, next_size) ? 1 : 0
    min = 0
    min = max if remaining_sizes.empty?

    max.downto(min) do |container_count|
      new_volume = used_volume + (next_size * container_count)
      new_fixed = used_sizes
      new_fixed += [next_size] if container_count > 0
      returned_mixes = find_container_combinations(new_volume, new_fixed, remaining_sizes)
      container_mixes += returned_mixes unless (returned_mixes || []).empty?
    end

    container_mixes
  end

  def can_use_container?(used_volume, container)
    remaining = (self.volume - used_volume)
    remaining >= container
  end
end

def parse_input(input="")
  containers = []
  input.each_line do |line|
    containers << line.strip.chomp.to_i
  end
  containers
end

if __FILE__ == $0
  input = ARGV[0]
  input_volume = (ARGV[1] || 150).to_i
  nog = Eggnog.new(parse_input(input), input_volume)
  combos = nog.find_container_combinations
  pp combos
  p "Found #{combos.size} different combos"
end
