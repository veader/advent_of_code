#!/usr/bin/env ruby

require_relative 'day3'

def test_samples(expected_result, samples)
  samples.each do |s|
    result = number_of_houses_visited(s)
    raise "Expected #{result} to equal #{expected_result}" unless expected_result == result
    puts "#{s} => #{result}"
  end
end

test_samples(2, [">", "^v^v^v^v^v"])
test_samples(4, ["^>v<"])
