#!/usr/bin/env ruby

require_relative 'day1'

def test_samples(expected_result, samples)
  samples.each do |s|
    result = move_elevator(s)
    raise "Expected #{result} to equal #{expected_result}" unless expected_result == result
    puts "#{s} => #{result}"
  end
end

test_samples(0, ["(())", "()()"])
test_samples(3, ["(((", "(()(()("])
test_samples(3, ["))((((("])
test_samples(-1, ["())", "))("])
test_samples(-3, [")))", ")())())"])
