#!/usr/bin/env ruby

require_relative 'day4'

def test_samples(expected_result, samples)
  samples.each do |s|
    result = mine_for_coins(s)
    raise "Expected #{result} to equal #{expected_result}" unless expected_result == result
    puts "#{s} => #{result}"
  end
end

test_samples(609043, ["abcdef"])
test_samples(1048970, ["pqrstuv"])
