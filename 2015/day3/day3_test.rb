#!/usr/bin/env ruby

require_relative 'day3'

def test_samples(expected_result, samples, use_robo=false)
  samples.each do |s|
    result = number_of_houses_visited(s, use_robo)
    raise "Expected #{result} to equal #{expected_result}" unless expected_result == result
    puts "#{s} => #{result}"
  end
end

use_robo_santa = false
test_samples(2, [">", "^v^v^v^v^v"], use_robo_santa)
test_samples(4, ["^>v<"], use_robo_santa)

use_robo_santa = true
test_samples(3, ["^v"], use_robo_santa)
test_samples(3, ["^>v<"], use_robo_santa)
test_samples(11, ["^v^v^v^v^v"], use_robo_santa)
