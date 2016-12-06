#!/usr/bin/env ruby

require_relative 'day2'

def test_samples(expected_result, samples)
  samples.each do |s|
    result = required_wrapping_paper(s)
    raise "Expected #{result} to equal #{expected_result}" unless expected_result == result
    puts "#{s} => #{result}"
  end
end

test_samples(58, ["2x3x4"])
test_samples(43, ["1x1x10"])
