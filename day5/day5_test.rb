#!/usr/bin/env ruby

require_relative 'day5'

def test_samples(expected_result, samples)
  samples.each do |s|
    result = nice_string?(s)
    unless expected_result == result
      # puts "Has vowels..." if has_vowels?(s)
      # puts "Has repeats..." if has_repeating_chars?(s)
      # puts "Does not have bad sequences..." if does_not_have_rejects?(s)
      raise "Expected #{result} to equal #{expected_result} => #{s}"
    end
    puts "#{s} => #{result}"
  end
end

test_samples(true, ["ugknbfddgicrmopn", "aaa"])
test_samples(false, ["jchzalrnumimnmhp", "haegwjzuvuyypxyu", "dvszwmarrgswjxmb"])
