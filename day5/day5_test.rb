#!/usr/bin/env ruby

require_relative 'day5'

# FIRST STAR ----------------
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

# SECOND STAR ----------------
["xyxy", "aabcdefgaa"].each do |test_str|
  raise "Expected #{test_str} to have repeating char sequence" unless has_repeated_sequence?(test_str)
end

raise "Expected aaa to not have repeating char sequence" if has_repeated_sequence?("aaa")

["xyx", "abcdefeghi", "aaa"].each do |test_str|
  unless has_repeating_chars_offset_by_one?(test_str)
    raise "Expected #{test_str} to have repeating char with 1 char between"
  end
end

["qjhvhtzxzqqjkmpb", "xxyxx"].each do |nice_str|
  raise "Expected #{nice_str} to be nice" unless nice_string2?(nice_str)
end

["uurcxstgmygtbstg", "ieodomkazucvgmuy"].each do |naughty_str|
  raise "Exepcted #{naughty_str} to be naughty" if nice_string2?(naughty_str)
end
